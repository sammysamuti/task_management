# Preserve generic signatures
-keepclassmembers,allowobfuscation class * {
    public <methods>;
}

# Preserve the flutterlocalnotifications library to prevent issues with R8/ProGuard
-keep class com.dexterous.flutterlocalnotifications.** { *; }
