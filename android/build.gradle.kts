allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Fix legacy plugins (flutter_libserialport 0.4.0) that lack AGP 8+ namespace,
// have low compileSdk, and JVM target mismatches.
subprojects {
    plugins.withId("com.android.library") {
        val android = extensions.getByType<com.android.build.gradle.LibraryExtension>()
        if (android.namespace.isNullOrEmpty()) {
            android.namespace = "dev.cloudshell.${project.name.replace("-", "_")}"
        }
        if (android.compileSdk != null && android.compileSdk!! < 34) {
            android.compileSdk = 34
        }
        android.compileOptions {
            sourceCompatibility = JavaVersion.VERSION_17
            targetCompatibility = JavaVersion.VERSION_17
        }
    }
    plugins.withId("org.jetbrains.kotlin.android") {
        extensions.findByType<org.jetbrains.kotlin.gradle.dsl.KotlinAndroidProjectExtension>()?.apply {
            compilerOptions.jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
