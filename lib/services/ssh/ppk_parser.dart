/// PuTTY PPK key format parser for CloudShell.
///
/// Converts PuTTY PPK v2/v3 private keys to OpenSSH PEM format
/// so they can be used with dartssh2's `SSHKeyPair.fromPem()`.
/// Currently supports unencrypted PPK v2 for RSA and Ed25519.
library;

import 'dart:convert';
import 'dart:typed_data';

/// Exception thrown when PPK parsing or conversion fails.
class PpkException implements Exception {
  const PpkException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Parser and converter for PuTTY PPK key files.
///
/// PPK v2 format:
/// ```
/// PuTTY-User-Key-File-2: ssh-rsa
/// Encryption: none
/// Comment: user@host
/// Public-Lines: N
/// <base64>
/// Private-Lines: N
/// <base64>
/// Private-MAC: <hex>
/// ```
class PpkParser {
  PpkParser._();

  /// Returns true if the content appears to be PPK format.
  static bool isPpkFormat(String content) {
    return content.trimLeft().startsWith('PuTTY-User-Key-File-');
  }

  /// Converts PPK content to OpenSSH PEM format.
  ///
  /// Currently supports:
  /// - PPK v2, unencrypted, RSA keys
  /// - PPK v2, unencrypted, Ed25519 keys
  ///
  /// Throws [PpkException] if the key format is unsupported.
  static String convertToPem(String ppkContent, {String? passphrase}) {
    final lines = ppkContent.split('\n').map((l) => l.trimRight()).toList();
    if (lines.isEmpty) throw const PpkException('Empty PPK content');

    // Detect version
    final versionLine = lines.first;
    int version;
    String keyType;
    if (versionLine.startsWith('PuTTY-User-Key-File-2:')) {
      version = 2;
      keyType = versionLine.substring('PuTTY-User-Key-File-2:'.length).trim();
    } else if (versionLine.startsWith('PuTTY-User-Key-File-3:')) {
      version = 3;
      keyType = versionLine.substring('PuTTY-User-Key-File-3:'.length).trim();
    } else {
      throw const PpkException('Not a valid PPK file');
    }

    if (version == 3) {
      throw const PpkException(
          'PPK v3 format is not yet supported. '
          'Please convert to OpenSSH format using PuTTYgen.');
    }

    // Parse headers
    final headers = <String, String>{};
    var i = 1;
    while (i < lines.length) {
      final line = lines[i];
      if (line.contains(':') && !line.startsWith(' ')) {
        final colonIdx = line.indexOf(':');
        headers[line.substring(0, colonIdx).trim()] =
            line.substring(colonIdx + 1).trim();
      }
      i++;
    }

    final encryption = headers['Encryption'] ?? 'none';
    if (encryption != 'none') {
      if (passphrase == null || passphrase.isEmpty) {
        throw const PpkException(
            'This PPK key is encrypted. Please provide a passphrase.');
      }
      throw const PpkException(
          'Encrypted PPK keys are not yet supported. '
          'Please convert to OpenSSH format using PuTTYgen, '
          'or decrypt the key first.');
    }

    // Extract Public-Lines section
    final publicLines = _extractSection(lines, 'Public-Lines');
    final publicBytes = base64Decode(publicLines);

    // Extract Private-Lines section
    final privateLines = _extractSection(lines, 'Private-Lines');
    final privateBytes = base64Decode(privateLines);

    // Convert based on key type
    switch (keyType) {
      case 'ssh-rsa':
        return _rsaToPem(publicBytes, privateBytes);
      case 'ssh-ed25519':
        return _ed25519ToPem(publicBytes, privateBytes);
      case 'ecdsa-sha2-nistp256':
      case 'ecdsa-sha2-nistp384':
      case 'ecdsa-sha2-nistp521':
        throw PpkException(
            'ECDSA PPK import is not yet supported. '
            'Please convert to OpenSSH format using PuTTYgen.');
      default:
        throw PpkException('Unsupported PPK key type: $keyType');
    }
  }

  /// Extracts a multi-line base64 section from PPK content.
  ///
  /// Finds the `{sectionName}: N` header, then reads N lines of base64.
  static String _extractSection(List<String> lines, String sectionName) {
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].startsWith('$sectionName:')) {
        final count = int.tryParse(
            lines[i].substring('$sectionName:'.length).trim());
        if (count == null || count <= 0) {
          throw PpkException('Invalid $sectionName count');
        }
        final sectionLines = <String>[];
        for (var j = i + 1; j <= i + count && j < lines.length; j++) {
          sectionLines.add(lines[j].trim());
        }
        return sectionLines.join();
      }
    }
    throw PpkException('Missing $sectionName section');
  }

  // ---------------------------------------------------------------------------
  // RSA PPK → PEM conversion
  // ---------------------------------------------------------------------------

  /// Converts RSA PPK public/private data to PKCS#1 PEM format.
  ///
  /// PPK public blob: [type_len][type][e_len][e][n_len][n]
  /// PPK private blob: [d_len][d][p_len][p][q_len][q][iqmp_len][iqmp]
  /// PKCS#1 RSAPrivateKey: SEQUENCE { version, n, e, d, p, q, dp, dq, qinv }
  static String _rsaToPem(Uint8List publicBytes, Uint8List privateBytes) {
    // Parse public key blob: skip key type string, then read e, n
    var offset = 0;
    final (_, off1) = _readSshString(publicBytes, offset); // key type
    offset = off1;
    final (eBytes, off2) = _readSshMpint(publicBytes, offset); // e
    offset = off2;
    final (nBytes, _) = _readSshMpint(publicBytes, offset); // n

    // Parse private key blob: d, p, q, iqmp
    offset = 0;
    final (dBytes, off4) = _readSshMpint(privateBytes, offset); // d
    offset = off4;
    final (pBytes, off5) = _readSshMpint(privateBytes, offset); // p
    offset = off5;
    final (qBytes, off6) = _readSshMpint(privateBytes, offset); // q
    offset = off6;
    final (iqmpBytes, _) = _readSshMpint(privateBytes, offset); // iqmp

    // Compute dp = d mod (p-1) and dq = d mod (q-1)
    final d = _bytesToBigInt(dBytes);
    final p = _bytesToBigInt(pBytes);
    final q = _bytesToBigInt(qBytes);
    final dp = d % (p - BigInt.one);
    final dq = d % (q - BigInt.one);

    // Encode as DER PKCS#1 RSAPrivateKey
    final der = _encodeDerSequence([
      _encodeDerInteger(BigInt.zero), // version = 0
      _encodeDerInteger(_bytesToBigInt(nBytes)),
      _encodeDerInteger(_bytesToBigInt(eBytes)),
      _encodeDerInteger(d),
      _encodeDerInteger(p),
      _encodeDerInteger(q),
      _encodeDerInteger(dp),
      _encodeDerInteger(dq),
      _encodeDerInteger(_bytesToBigInt(iqmpBytes)),
    ]);

    // Wrap in PEM
    final b64 = base64Encode(der);
    final pemLines = <String>['-----BEGIN RSA PRIVATE KEY-----'];
    for (var i = 0; i < b64.length; i += 64) {
      pemLines.add(b64.substring(i, i + 64 > b64.length ? b64.length : i + 64));
    }
    pemLines.add('-----END RSA PRIVATE KEY-----');
    return pemLines.join('\n');
  }

  // ---------------------------------------------------------------------------
  // Ed25519 PPK → OpenSSH PEM conversion
  // ---------------------------------------------------------------------------

  /// Converts Ed25519 PPK public/private data to OpenSSH PEM format.
  ///
  /// PPK public blob: [type_len][type][pubkey_len][32-byte pubkey]
  /// PPK private blob: [64-byte private key (seed + public)]
  ///
  /// OpenSSH format wraps this in a specific binary structure.
  static String _ed25519ToPem(Uint8List publicBytes, Uint8List privateBytes) {
    // Parse public key: skip type string, read 32-byte pubkey
    var offset = 0;
    final (_, off1) = _readSshString(publicBytes, offset); // "ssh-ed25519"
    offset = off1;
    final (pubKey, _) = _readSshBytes(publicBytes, offset); // 32-byte pubkey

    // PPK stores 64-byte ed25519 private key (32-byte seed + 32-byte public)
    // But dartssh2 expects OpenSSH format which also stores the 64-byte key
    Uint8List privKey;
    if (privateBytes.length == 64) {
      privKey = privateBytes;
    } else {
      // Some PPK versions store only the 32-byte seed
      privKey = Uint8List(64)
        ..setRange(0, 32, privateBytes)
        ..setRange(32, 64, pubKey);
    }

    // Build OpenSSH key format
    return _buildOpenSshPem('ssh-ed25519', pubKey, privKey);
  }

  /// Builds an OpenSSH PEM key file from key components.
  ///
  /// OpenSSH private key format:
  /// ```
  /// "openssh-key-v1\0"
  /// cipher: "none"
  /// kdfname: "none"
  /// kdfoptions: ""
  /// number of keys: 1
  /// public key blob
  /// private section (checkint, checkint, keytype, key data, comment, padding)
  /// ```
  static String _buildOpenSshPem(
      String keyType, Uint8List pubKey, Uint8List privKey) {
    final bb = BytesBuilder();

    // Auth magic
    bb.add(utf8.encode('openssh-key-v1'));
    bb.addByte(0);

    // ciphername: "none"
    _writeSshString(bb, 'none');
    // kdfname: "none"
    _writeSshString(bb, 'none');
    // kdfoptions: empty string
    _writeSshU32(bb, 0);
    // number of keys: 1
    _writeSshU32(bb, 1);

    // Public key blob
    final pubBlob = BytesBuilder();
    _writeSshString(pubBlob, keyType);
    _writeSshBytes(pubBlob, pubKey);
    final pubBlobBytes = pubBlob.takeBytes();
    _writeSshU32(bb, pubBlobBytes.length);
    bb.add(pubBlobBytes);

    // Private section
    final privSection = BytesBuilder();
    // checkint (random, but same twice)
    const checkInt = 0x12345678;
    _writeSshU32(privSection, checkInt);
    _writeSshU32(privSection, checkInt);

    // Key type
    _writeSshString(privSection, keyType);
    // Public key
    _writeSshBytes(privSection, pubKey);
    // Private key (64 bytes for ed25519: seed + pubkey)
    _writeSshBytes(privSection, privKey);
    // Comment (empty)
    _writeSshString(privSection, '');

    // Padding (1, 2, 3, 4, ... up to block size 8)
    final privBytes = privSection.takeBytes();
    final padLen = (8 - (privBytes.length % 8)) % 8;
    final paddedPriv = Uint8List(privBytes.length + padLen);
    paddedPriv.setRange(0, privBytes.length, privBytes);
    for (var i = 0; i < padLen; i++) {
      paddedPriv[privBytes.length + i] = i + 1;
    }

    _writeSshU32(bb, paddedPriv.length);
    bb.add(paddedPriv);

    final keyData = bb.takeBytes();
    final b64 = base64Encode(keyData);

    final pemLines = <String>['-----BEGIN OPENSSH PRIVATE KEY-----'];
    for (var i = 0; i < b64.length; i += 70) {
      pemLines.add(b64.substring(i, i + 70 > b64.length ? b64.length : i + 70));
    }
    pemLines.add('-----END OPENSSH PRIVATE KEY-----');
    return pemLines.join('\n');
  }

  // ---------------------------------------------------------------------------
  // SSH wire format helpers
  // ---------------------------------------------------------------------------

  /// Reads a length-prefixed SSH string and returns (value, newOffset).
  static (String, int) _readSshString(Uint8List data, int offset) {
    final (bytes, newOffset) = _readSshBytes(data, offset);
    return (utf8.decode(bytes), newOffset);
  }

  /// Reads a length-prefixed byte array and returns (bytes, newOffset).
  static (Uint8List, int) _readSshBytes(Uint8List data, int offset) {
    if (offset + 4 > data.length) throw const PpkException('Truncated data');
    final len = (data[offset] << 24) |
        (data[offset + 1] << 16) |
        (data[offset + 2] << 8) |
        data[offset + 3];
    offset += 4;
    if (offset + len > data.length) throw const PpkException('Truncated data');
    return (Uint8List.fromList(data.sublist(offset, offset + len)), offset + len);
  }

  /// Reads an SSH mpint (multi-precision integer) as raw bytes.
  static (Uint8List, int) _readSshMpint(Uint8List data, int offset) {
    return _readSshBytes(data, offset);
  }

  /// Writes a uint32 in big-endian to a BytesBuilder.
  static void _writeSshU32(BytesBuilder bb, int value) {
    bb.addByte((value >> 24) & 0xFF);
    bb.addByte((value >> 16) & 0xFF);
    bb.addByte((value >> 8) & 0xFF);
    bb.addByte(value & 0xFF);
  }

  /// Writes a length-prefixed SSH string.
  static void _writeSshString(BytesBuilder bb, String value) {
    final bytes = utf8.encode(value);
    _writeSshU32(bb, bytes.length);
    bb.add(bytes);
  }

  /// Writes a length-prefixed byte array.
  static void _writeSshBytes(BytesBuilder bb, Uint8List value) {
    _writeSshU32(bb, value.length);
    bb.add(value);
  }

  // ---------------------------------------------------------------------------
  // ASN.1 DER encoding helpers (for PKCS#1)
  // ---------------------------------------------------------------------------

  /// Encodes a BigInt as a DER INTEGER.
  static Uint8List _encodeDerInteger(BigInt value) {
    final bytes = _bigIntToBytes(value);

    // Ensure leading zero if high bit is set (positive number convention)
    final needsLeadingZero = bytes.isNotEmpty && (bytes[0] & 0x80) != 0;
    Uint8List content;
    if (needsLeadingZero) {
      content = Uint8List(bytes.length + 1);
      content.setRange(1, bytes.length + 1, bytes);
    } else {
      content = bytes;
    }

    return _encodeDerTlv(0x02, content);
  }

  /// Encodes a DER SEQUENCE from a list of encoded elements.
  static Uint8List _encodeDerSequence(List<Uint8List> elements) {
    final bb = BytesBuilder();
    for (final e in elements) {
      bb.add(e);
    }
    return _encodeDerTlv(0x30, bb.takeBytes());
  }

  /// Encodes a TLV (tag-length-value) in DER format.
  static Uint8List _encodeDerTlv(int tag, Uint8List value) {
    final lengthBytes = _encodeDerLength(value.length);
    final result = Uint8List(1 + lengthBytes.length + value.length);
    result[0] = tag;
    result.setRange(1, 1 + lengthBytes.length, lengthBytes);
    result.setRange(1 + lengthBytes.length, result.length, value);
    return result;
  }

  /// Encodes a DER length value.
  static Uint8List _encodeDerLength(int length) {
    if (length < 0x80) {
      return Uint8List.fromList([length]);
    }
    // Multi-byte length
    final bytes = <int>[];
    var temp = length;
    while (temp > 0) {
      bytes.insert(0, temp & 0xFF);
      temp >>= 8;
    }
    return Uint8List.fromList([0x80 | bytes.length, ...bytes]);
  }

  // ---------------------------------------------------------------------------
  // BigInt <-> Bytes helpers
  // ---------------------------------------------------------------------------

  /// Converts unsigned big-endian bytes to BigInt.
  static BigInt _bytesToBigInt(Uint8List bytes) {
    var result = BigInt.zero;
    for (final b in bytes) {
      result = (result << 8) | BigInt.from(b);
    }
    return result;
  }

  /// Converts a non-negative BigInt to unsigned big-endian bytes.
  static Uint8List _bigIntToBytes(BigInt value) {
    if (value == BigInt.zero) return Uint8List.fromList([0]);
    final bytes = <int>[];
    var temp = value;
    while (temp > BigInt.zero) {
      bytes.insert(0, (temp & BigInt.from(0xFF)).toInt());
      temp >>= 8;
    }
    return Uint8List.fromList(bytes);
  }
}
