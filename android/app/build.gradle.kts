plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")  // Plugin necesario para Firebase
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flutter_application_1"  // Cambia esto por el namespace de tu app

    // Usa compileSdk definido por Flutter
    compileSdk = flutter.compileSdkVersion

    // En vez de 'ndkVersion = flutter.ndkVersion', especifica NDK 27
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.flutter_application_1"  // Cambia esto por el ID de tu app
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Resuelve la ambigüedad en firebase_app_distribution_android
        missingDimensionStrategy("default", "production")
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."  // Ruta al directorio de tu fuente Flutter
}
