package com.example.simple_monri_flutter_app

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.simple_monri_flutter_app.monri_http_helper.MonriHttpHelper


class MainActivity : FlutterActivity() {
    private val CHANNEL = "monri.create.payment.session.channel";
    private val createPaymentSessionMethod = "monri.create.payment.session.method";

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            // Note: this method is invoked on the main thread.
            if (call.method.equals(createPaymentSessionMethod)) {
                MonriHttpHelper.createPaymentSession(result::success).execute();
            }
        }
    }
}
