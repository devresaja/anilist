import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties().apply {
    val f = rootProject.file("local.properties")
    if (f.exists()) f.inputStream().use(::load)
}

val flutterVersionCode = (localProperties.getProperty("flutter.versionCode") ?: "1").toInt()
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

val keystoreProperties = Properties().apply {
    val f = rootProject.file("key.properties")
    if (f.exists()) f.inputStream().use(::load)
}

fun loadEnv(name: String): Properties = Properties().apply {
    val f = file("${rootProject.projectDir.parent}/$name")
    if (f.exists()) f.inputStream().use(::load)
}
val env = loadEnv(".env")
val envDev = loadEnv(".env.dev")

android {
    namespace = "com.anilist.android"
    compileSdk = 36
    ndkVersion = "28.0.13004108"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }
    
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.anilist.android"
        minSdk = 24
        targetSdk = 36
        versionCode = flutterVersionCode
        versionName = flutterVersionName

        resValue("string", "app_name", "Anilist")
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = (keystoreProperties["storeFile"] as String?)?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
        }
        getByName("profile") {}
        getByName("debug") {}
    }

    flavorDimensions += "flavor-type"
    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "Anilist-dev")
            resValue(
                "string",
                "admob_app_id",
                envDev.getProperty("admobAppId", "").replace("'", "")
            )
            signingConfig = signingConfigs.getByName("debug")
        }

        create("prod") {
            dimension = "flavor-type"
            resValue(
                "string",
                "admob_app_id",
                env.getProperty("admobAppId", "").replace("'", "")
            )
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

val scProd by lazy { android.signingConfigs.getByName("release") }
val scDebug by lazy { android.signingConfigs.getByName("debug") }

androidComponents {
    // Set all build variant of flavor dev to use signinConfig debug
    onVariants(selector().withFlavor("flavor-type" to "dev")) { variant ->
        variant.signingConfig?.setConfig(scDebug)
    }

    // Set all build variant of flavor release to use signinConfig release
    onVariants(selector().withFlavor("flavor-type" to "prod")) { variant ->
        variant.signingConfig?.setConfig(scProd)
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.4.0"))
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
