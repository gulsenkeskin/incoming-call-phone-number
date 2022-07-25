package com.example.phone_call_demo

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.telephony.PhoneStateListener
import android.telephony.TelephonyManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel


class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val callReceiver = object : EventChannel.StreamHandler, BroadcastReceiver() {
            var eventSink: EventChannel.EventSink? = null
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }

            override fun onReceive(p0: Context?, p1: Intent?) {

//                var savedNumber: String? = "yok"
//                if (p1?.getAction().equals("android.intent.action.NEW_OUTGOING_CALL")) {
//                    savedNumber = p1?.getExtras().getString("android.intent.extra.PHONE_NUMBER")
//                } else {
//                    val stateStr: String? = p1?.getExtras().getString(TelephonyManager.EXTRA_STATE)
//                    val number: String? =
//                        p1?.getExtras().getString(TelephonyManager.EXTRA_INCOMING_NUMBER)
//                    var state = 0
//                    if (stateStr.equals(TelephonyManager.EXTRA_STATE_IDLE)) {
//                        state = TelephonyManager.CALL_STATE_IDLE
//                    } else if (stateStr.equals(TelephonyManager.EXTRA_STATE_OFFHOOK)) {
//                        state = TelephonyManager.CALL_STATE_OFFHOOK
//                    } else if (stateStr.equals(TelephonyManager.EXTRA_STATE_RINGING)) {
//                        state = TelephonyManager.CALL_STATE_RINGING
//                    }
//
//                  eventSink?.success("$state - $number")
//
//
//                }




                val telephony: TelephonyManager =
                    context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
                telephony.listen(object : PhoneStateListener() {
                    override fun onCallStateChanged(state: Int, incomingNumber: String) {
                        super.onCallStateChanged(state, incomingNumber)
                            eventSink?.success("$incomingNumber-$state")
                    }
                }, PhoneStateListener.LISTEN_CALL_STATE)

            }
        }

        registerReceiver(callReceiver, IntentFilter("android.intent.action.PHONE_STATE"))
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.app/callStream")
            .setStreamHandler(callReceiver)






    }
}
