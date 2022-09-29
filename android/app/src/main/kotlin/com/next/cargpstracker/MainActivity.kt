package com.next.cargpstracker

import android.content.pm.PackageManager
import android.os.Bundle
import android.telephony.SmsManager
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.view.FlutterView
import java.util.jar.Manifest
import android.Manifest.permission
import android.widget.Toast
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.messaging.FirebaseMessaging
import android.util.Log


class MainActivity : FlutterActivity() {
//    private val CHANNEL =  "myChannel";

    private val CHANNEL = "com.next.cargpstracker/sendMsg"

    private val callResult: MethodChannel.Result? = null
    var channel: MethodChannel? = null
    var RECORD_REQUEST_CODE = 0
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.i("user_debug", "MainActivity: onCreate")
        FirebaseMessaging.getInstance().token.addOnCompleteListener(OnCompleteListener { task ->
            Log.d("token stat",task.isSuccessful.toString())
            if (!task.isSuccessful) {

                return@OnCompleteListener
            }
            val newToken: String = task.result
            Log.d("newToken", newToken)
//            sendRegistrationToServer(token)

        })
//        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))
//        channel = MethodChannel(FlutterView(this), "myChannel")

//        MethodChannel(FlutterView(this), CHANNEL).setMethodCallHandler { call, result ->
//            if (call.method == "send") {
//                val num = call.argument<String>("phone")
//                val msg = call.argument<String>("msg")
//                sendSMS(num, msg, result)
//            } else {
//                result.notImplemented()
//            }
//        }
//
//

//
//        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL).setMethodCallHandler {
//            // Note: this method is invoked on the main thread.
//            call, result ->
//            if (call.method == "send") {
//                val num = call.argument<String>("phone")
//                val msg = call.argument<String>("msg")
//                sendSMS(num, msg, result)
//            } else {
//                result.notImplemented()
//            }
//        }

//        val permissionCheck: Int = ContextCompat.checkSelfPermission(
//            this,
//            android.Manifest.permission.WRITE_CALENDAR
//        )
//        if (permissionCheck != PackageManager.PERMISSION_GRANTED) {
//
//            ActivityCompat.requestPermissions(this,
//                arrayOf( android.Manifest.permission.WRITE_CALENDAR),
//                RECORD_REQUEST_CODE)
//        }
        val permission = ContextCompat.checkSelfPermission(
            this,
            android.Manifest.permission.SEND_SMS
        )

        if (permission != PackageManager.PERMISSION_GRANTED) {

            ActivityCompat.requestPermissions(
                this,
                arrayOf(android.Manifest.permission.SEND_SMS),
                RECORD_REQUEST_CODE
            )
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
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

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>, grantResults: IntArray
    ) {
        when (requestCode) {
            RECORD_REQUEST_CODE -> {

                if (grantResults[0] != PackageManager.PERMISSION_GRANTED) {

                    Log.i("TAG", "Permission has been denied by user")
                } else {
                    Log.i("TAG", "Permission has been granted by user")
                }
            }
        }
    }

}
