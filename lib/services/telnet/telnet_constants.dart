// RFC 854 Telnet protocol constants.
//
// Defines IAC commands, negotiation verbs, and common option codes
// used by TelnetParser and TelnetSession.

/// Interpret As Command — signals the start of a telnet command sequence.
const int iac = 255;

// --- Negotiation verbs ---

/// Sender wants to enable an option.
const int will = 251;

/// Sender refuses to enable an option.
const int wont = 252;

/// Sender requests the other side enable an option.
const int doOpt = 253;

/// Sender requests the other side disable an option.
const int dontOpt = 254;

// --- Subnegotiation ---

/// Start of subnegotiation parameters.
const int sb = 250;

/// End of subnegotiation parameters.
const int se = 240;

// --- Common option codes ---

/// Echo (RFC 857).
const int optEcho = 1;

/// Suppress Go Ahead (RFC 858).
const int optSga = 3;

/// Terminal Type (RFC 1091).
const int optTerminalType = 24;

/// Negotiate About Window Size (RFC 1073).
const int optNaws = 31;

/// Terminal Speed (RFC 1079).
const int optTerminalSpeed = 32;

/// Linemode (RFC 1184).
const int optLinemode = 34;

/// New Environment Option (RFC 1572).
const int optNewEnviron = 39;

// --- Subnegotiation sub-commands ---

/// IS sub-command (used in TERMINAL-TYPE subnegotiation).
const int subIs = 0;

/// SEND sub-command (used in TERMINAL-TYPE subnegotiation).
const int subSend = 1;
