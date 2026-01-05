package com.hendracodes.kopit

import android.inputmethodservice.InputMethodService
import android.view.View
import android.view.inputmethod.EditorInfo
import android.widget.FrameLayout
import android.widget.LinearLayout
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class ClipboardInputMethodService : InputMethodService() {
    private var flutterEngine: FlutterEngine? = null
    private var flutterView: FlutterView? = null
    private val ENGINE_ID = "clipboard_keyboard_engine"

    override fun onCreate() {
        super.onCreate()
        // Initialize Flutter Engine if not already cached
        if (FlutterEngineCache.getInstance().get(ENGINE_ID) == null) {
            flutterEngine = FlutterEngine(this)
            flutterEngine?.dartExecutor?.executeDartEntrypoint(
                DartExecutor.DartEntrypoint.createDefault()
            )
            FlutterEngineCache.getInstance().put(ENGINE_ID, flutterEngine)
        } else {
            flutterEngine = FlutterEngineCache.getInstance().get(ENGINE_ID)
        }
    }

    override fun onCreateInputView(): View {
        val linearLayout = LinearLayout(this)
        linearLayout.layoutParams = LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            LinearLayout.LayoutParams.MATCH_PARENT
        )
        linearLayout.orientation = LinearLayout.VERTICAL

        // Create Flutter View
        flutterView = FlutterView(this)
        
        // Attach the cached engine
        flutterEngine?.let { engine ->
            flutterView?.attachToFlutterEngine(engine)
        }

        linearLayout.addView(flutterView, LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            600 // Fixed height for now, can be dynamic
        ))

        return linearLayout
    }

    override fun onDestroy() {
        super.onDestroy()
        flutterView?.detachFromFlutterEngine()
    }
}
