package com.example.laba14

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.text/channel" // Оновлений канал

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getNativeMessage") { // Оновлена назва методу
                // Повертаємо статичну стрічку "Hi, Mom!"
                result.success("Hi, Mom!")
            } else {
                result.notImplemented()
            }
        }
    }
}
