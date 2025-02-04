import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class NotificationReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val title = intent.getStringExtra("title") ?: ""
        val body = intent.getStringExtra("body") ?: ""

        Handler(Looper.getMainLooper()).post {
            MethodChannel((context as FlutterActivity).flutterEngine!!.dartExecutor.binaryMessenger, "notification_channel")
                .invokeMethod("onNotificationReceived", "$title - $body")
        }
    }
}
