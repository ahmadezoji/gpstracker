package com.next.cargpstracker

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

import android.os.Bundle;
import android.telephony.SmsManager;
import android.util.Log;
import android.widget.Toast
import io.flutter.view.FlutterView
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    private val CHANNEL =  "platfrom.channel.message/info";

    private val callResult: MethodChannel.Result? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.i("user_debug", "MainActivity: onCreate")
        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))
        MethodChannel(FlutterView(this), CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "send") {
                val num = call.argument<String>("phone")
                val msg = call.argument<String>("msg")
                sendSMS(num, msg, result)
            } else {
                result.notImplemented()
            }
        }
    }
    //sending sms from native
    private fun sendSMS(phoneNo: String?, msg: String?, result: MethodChannel.Result) {
        try {
            val smsManager: SmsManager = SmsManager.getDefault()
            smsManager.sendTextMessage(phoneNo, null, msg, null, null)
            result.success("SMS Sent")
        } catch (ex: Exception) {
            ex.printStackTrace()
            result.error("Err", "Sms Not Sent", "")
        }
    }
}
