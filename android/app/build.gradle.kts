plugins {
    id("com.android.application")
    // id("kotlin-android") si usas Kotlin
}

android {
    compileSdk = 33

    defaultConfig {
        applicationId = "com.example.flutter_application_1"
        minSdk = 21
        targetSdk = 33
        versionCode = 1
        versionName = "1.0"

        // Kotlin DSL para resValue
        resValue("string", "google_api_key", "\"${System.getenv("GOOGLE_API_KEY") ?: "TU_API_KEY_DEFAULT"}\"")
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
            // ProGuard, minifyEnabled, etc.
        }
    }
}
