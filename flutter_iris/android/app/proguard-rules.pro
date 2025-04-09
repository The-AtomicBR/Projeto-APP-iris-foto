# === TENSORFLOW LITE (seu conteúdo atual) ===
-keep class org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.gpu.** { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory$Options { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegate { *; }
-keep class org.tensorflow.** { *; }
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options

# === FLUTTER PLUGINS ===
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.engine.** { *; }
-keep class io.flutter.app.** { *; }
-dontwarn io.flutter.**

# === ML KIT ===
-keep class com.google.mlkit.vision.** { *; }
-keep class com.google.mlkit.common.** { *; }
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

# === OPÇÕES DE RECONHECIMENTO DE TEXTO (evita erro de classes ausentes) ===
-keep class com.google.mlkit.vision.text.chinese.** { *; }
-keep class com.google.mlkit.vision.text.japanese.** { *; }
-keep class com.google.mlkit.vision.text.korean.** { *; }
-keep class com.google.mlkit.vision.text.devanagari.** { *; }

# === ANOTAÇÕES E REFLEXÃO ===
-keepattributes *Annotation*
-keep class androidx.lifecycle.DefaultLifecycleObserver { *; }
-keep class androidx.lifecycle.LifecycleObserver { *; }
