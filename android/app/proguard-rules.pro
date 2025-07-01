# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Keep Parcelable classes
-keepclassmembers class * implements android.os.Parcelable {
    static ** CREATOR;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Remove unused code
-dontwarn **
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification

# Keep annotations
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keepattributes Signature
-keepattributes Exceptions

# Hive specific rules
-keep class * extends com.google.protobuf.GeneratedMessageLite { *; }
-keep class * implements androidx.sqlite.db.SupportSQLiteOpenHelper { *; }

# API level 12 compatibility
-keep class android.support.** { *; }
-keep class androidx.** { *; }
-keep class com.google.android.** { *; }

# Keep WebView related classes for older Android versions
-keep class android.webkit.** { *; }

# Added for Aura project

# Keep data models
-keep class com.example.aura.features.Auth.data.models.** { *; }
-keep class com.example.aura.features.home.data.models.** { *; }
-keep class com.example.aura.features.profile.data.models.** { *; }

# Keep all members of data models
-keepclassmembers class **.models.** {
  <fields>;
  <methods>;
}

# Keep Dio and related networking classes
-keepclasseswithmembernames class kotlin.coroutines.jvm.internal.BaseContinuationImpl {
    private java.lang.Object L$0;
}
-dontwarn okhttp3.**
-dontwarn retrofit2.**
-keep class retrofit2.** { *; }
-keep interface retrofit2.** { *; }
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod 