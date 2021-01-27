package com.cbcloud.screenshot_detector

import android.content.Context
import androidx.annotation.NonNull
import com.abangfadli.shotwatch.ShotWatch

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** ScreenshotDetectorPlugin */
class ScreenshotDetectorPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var shotWatch: ShotWatch
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "cb-cloud/screenshot_detector")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "initialize" -> {
                val screenshotListener = ShotWatch.Listener { channel.invokeMethod("onCallback", null) }
                shotWatch = ShotWatch(context.contentResolver, screenshotListener)
                result.success("initialize")
            }
            "activate" -> {
                shotWatch.register()
                result.success("activate")
            }
            "inactivate" -> {
                shotWatch.unregister()
                result.success("inactivate")
            }
            "dispose" -> {
                shotWatch.unregister()
                result.success("dispose")
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

}
