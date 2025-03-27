# Razorpay SDK
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Google Pay
-keep class com.google.android.apps.nbu.paisa.** { *; }
-dontwarn com.google.android.apps.nbu.paisa.**

# ProGuard Annotations
-keep @interface proguard.annotation.Keep
-keep @interface proguard.annotation.KeepClassMembers

# General Android rules (if not already present)
-dontwarn android.arch.**
-keep class android.support.** { *; }
