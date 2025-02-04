package com.plated

import io.flutter.embedding.android.FlutterFragmentActivity
import android.content.Intent
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import android.os.Build
import android.util.Rational
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "broadcast_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "sendBroadcast" -> {  //  Handle Firebase notification broadcast
                    val title = call.argument<String>("title") ?: ""
                    val body = call.argument<String>("body") ?: ""

                    // Create and send the broadcast
                    val intent = Intent("com.plated.NOTIFICATION_RECEIVED")
                    intent.putExtra("title", title)
                    intent.putExtra("body", body)

                    // Send broadcast to Flutter
                    LocalBroadcastManager.getInstance(this).sendBroadcast(intent)

                    // Notify Flutter of notification
                    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).invokeMethod(
                        "onNotificationReceived", "$title - $body"
                    )

                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

}
