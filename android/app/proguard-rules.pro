#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep public class com.google.android.gms.* { public *; }
-keep com.google.android.gms.** 
-keep class com.google.android.gms.internal.** { *; }
-keep com.google.android.gms.ads.** { *; }
-dontwarn com.google.android.gms.internal.** { *; }
-keep com.google.firebase.iid.** { *; }

-dontwarn com.google.android.gms.internal.clearcut.** { *; }
-keep class * extends java.util.ListResourceBundle {
    protected Object[][] getContents();
}

-keep public class com.google.android.gms.common.internal.safeparcel.SafeParcelable {
    public static final *** NULL;
}

-keepnames @com.google.android.gms.common.annotation.KeepName class *
-keepclassmembernames class * {
    @com.google.android.gms.common.annotation.KeepName *;
}

-keepnames class * implements android.os.Parcelable {
    public static final ** CREATOR;
}