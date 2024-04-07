package com.example.klavi_link_demo_flutter

import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.net.URISyntaxException

class MainActivity: FlutterActivity() {
    private var CHANNEL = "com.klavi.flutter.launch-app"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "launchApp") {
                val uri = Uri.parse(call.arguments())
                try {
                    val intent = if (uri.scheme == "intent") {
                        Intent.parseUri(uri.toString(), Intent.URI_INTENT_SCHEME)
                    } else {
                        Intent(Intent.ACTION_VIEW, uri)
                    }
                    startActivity(intent)
                } catch (e: ActivityNotFoundException) {
                    e.printStackTrace()
                } catch (e: URISyntaxException) {
                    e.printStackTrace()
                }
                result.success("launchApp success")
            } else {
                result.notImplemented()
            }
        }
    }
}
