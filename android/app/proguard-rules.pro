# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in /Volumes/DATA/SETUP/AndroidSDK/sdk/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile
# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}
#
#-keep class org.webrtc.** { *; }
#-keep public class org.webrtc.** { *; }
#

#-injars      bin/classes
#-injars      libs
#-outjars     bin/classes-processed.jar
#-libraryjars /usr/local/java/android-sdk/platforms/android-9/android.jar
#
#-dontpreverify
#-repackageclasses ''
#-allowaccessmodification
#-optimizations !code/simplification/arithmetic
#-keepattributes *Annotation*
#
#-keep public class * extends android.app.Activity
#-keep public class * extends android.app.Application
#-keep public class * extends android.app.Service
#-keep public class * extends android.content.BroadcastReceiver
#-keep public class * extends android.content.ContentProvider
#
#
##-keep public class com.hoasao.hsvideocalllib.*
#

## Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**
#end flutter

#For Hoasaolib
-keep public class com.hoasao.hsvideocalllib.SDKInitializer {
    public <init>(...);
    int MEDIA_TYPE_VOICE;
    int MEDIA_TYPE_VIDEO1;
    int MEDIA_TYPE_VIDEO2;
 }
 #remove all log
 -assumenosideeffects class android.util.Log { *; }


 #for example
 -keep class com.hoasao.hsvideocalllib.User {
     com.hoasao.hsvideocalllib.User create(java.lang.String);
     void setAddress(java.lang.String);
     java.lang.String getName();
 }
 -keep public class com.hoasao.hsvideocalllib.NullHostNameVerifier {
     public <init>(...);
  }
  -keep public class com.hoasao.hsvideocalllib.TrustAllCerts {
      public <init>(...);
   }
 -keepattributes LocalVariableTable,LocalVariableTypeTable

# Jackson refers to these but they're unavailable/unused in typical runtimes
-dontwarn javax.xml.**
-dontwarn javax.activation.**
-dontwarn org.joda.**
-dontwarn javax.ws.rs.**
-dontwarn org.w3c.dom.bootstrap.**
-dontwarn java.beans.Introspector

-keep class org.apache.http.** { *; }
-dontwarn org.apache.http.**
-dontwarn android.net.**


-keep class org.webrtc.** { *; }
-keep public class org.webrtc.** { *; }

# Jackson refers to these but they're unavailable/unused in typical runtimes
-dontwarn javax.xml.**
-dontwarn javax.activation.**
-dontwarn org.joda.**
-dontwarn javax.ws.rs.**
-dontwarn org.w3c.dom.bootstrap.**
-dontwarn java.beans.Introspector

## --------------- Start Project specifics --------------- ##

-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-dontskipnonpubliclibraryclassmembers
-dontpreverify
-verbose
-dump class_files.txt
-printseeds seeds.txt
-printusage unused.txt
-printmapping mapping.txt
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*

#-allowaccessmodification
-keepattributes *Annotation*
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable


# Keep the support library
-keep class android.support.v4.** { *; }
-keep interface android.support.v4.** { *; }


-keep class com.google.analytics.** { *; }

-keep public class android.support.v7.widget.** { *; }
-keep public class android.support.v7.internal.widget.** { *; }
-keep public class android.support.v7.internal.view.menu.** { *; }

-keep public class * extends android.support.v4.view.ActionProvider {
    public <init>(android.content.Context);
}

# Application classes that will be serialized/deserialized over Gson
# or have been blown up by ProGuard in the past

## ---------------- End Project specifics ---------------- ##



-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.Preference
-keep public class com.android.vending.licensing.ILicensingService
-keep public class android.net.http.SslError
-keep public class android.webkit.WebViewClient
-keep class org.apache.http.** { *; }

-keep class com.squareup.okhttp.** { *; }
-keep interface com.squareup.okhttp.** { *; }
-dontwarn com.squareup.okhttp.**

-dontwarn org.apache.http.**
-dontwarn org.apache.commons.**
-dontwarn android.net.**
-dontwarn rx.**
-dontwarn retrofit.**
-dontwarn retrofit2.Platform$Java8
-dontwarn okio.**
-dontwarn fi.foyt.foursquare.**

-keep class retrofit.** { *; }
-keepclasseswithmembers class * {
    @retrofit.http.* <methods>;
}

-keep class sun.misc.Unsafe { *; }
#your package path where your gson models are stored
-keep class com.example.models.** { *; }

-dontnote com.android.vending.licensing.ILicensingService
-dontnote android.net.http.*
-dontnote org.apache.commons.codec.**
-dontnote org.apache.http.**
-dontnote org.apache.commons.logging.**
-dontnote com.android.internal.http.multipart.**
-dontnote libcore.icu.ICU
-dontnote sun.misc.Unsafe
#-dontwarn com.android.support:support-v4
#-dontwarn com.android.support:appcompat-v7
#-dontwarn com.google.android.gms:play-services-gcm
#-dontwarn com.google.android.gms:play-services-analytics


#To remove debug logs:
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}


# Explicitly preserve all serialization members. The Serializable interface
# is only a marker interface, so it wouldn't save them.
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Preserve all native method names and the names of their classes.
-keepclasseswithmembernames class * {
    native <methods>;
}

-keepclasseswithmembernames class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}

-keepclasseswithmembernames class * {
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

# Preserve static fields of inner classes of R classes that might be accessed
# through introspection.
-keepclassmembers class **.R$* {
  public static <fields>;
}

# Preserve the special static methods that are required in all enumeration classes.
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

#-keep public class * {
#    public private *;
#}

-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}
##---------------End: proguard configuration common for all Android apps ----------

##---------------Begin: proguard configuration for Gson  ----------
# Gson uses generic type information stored in a class file when working with fields. Proguard
# removes such information by default, so configure it to keep all of it.
-keepattributes Signature

# Gson specific classes
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.stream.** { *; }
-keep public class com.google.android.gms.** { *; }

# Application classes that will be serialized/deserialized over Gson
-keep class com.google.gson.examples.android.model.** { *; }

##---------------End: proguard configuration for Gson  ----------

-keep class * extends java.util.ListResourceBundle {
    protected Object[][] getContents();
}

#BEGIN HIEUNV9 Tich hop Cisco SDK

#-keep class javax.ws.rs.** { *; }
#-keep class org.joda.time.** { *; }
#-keep class javax.** { *; }
#-keep class java.beans.** { *; }
#-keep class org.w3c.** { *; }
#
#-dontwarn javax.ws.rs.**
#-dontwarn org.joda.time.**
#-dontwarn javax.**
#-dontwarn org.w3c.**
#-dontwarn java.beans.**

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
-keepclassmembers class fqcn.of.javascript.interface.for.webview {
   public *;
}

-keep class org.webrtc.** { *; }
-keep public class org.webrtc.** { *; }

# Jackson refers to these but they're unavailable/unused in typical runtimes
-dontwarn javax.xml.**
-dontwarn javax.activation.**
-dontwarn org.joda.**
-dontwarn javax.ws.rs.**
-dontwarn org.w3c.dom.bootstrap.**
-dontwarn java.beans.Introspector

#END