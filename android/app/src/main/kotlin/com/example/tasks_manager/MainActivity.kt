package com.example.tasks_manager

import android.animation.ObjectAnimator
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.View
import android.view.animation.AnticipateInterpolator
import androidx.core.animation.doOnEnd
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    // Aligns the Flutter view vertically with the window.
    WindowCompat.setDecorFitsSystemWindows(window, false)

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
      // Disable the Android splash screen fade out animation to avoid
      // a flicker before the similar frame is drawn in Flutter.
      splashScreen.setOnExitAnimationListener { splashScreenView ->

        // Add a delay before starting the animation
        Handler(Looper.getMainLooper()).postDelayed({
          // Set animation
          val slideUp = ObjectAnimator.ofFloat(
            splashScreenView,
            View.TRANSLATION_Y,
            0f,
            -splashScreenView.height.toFloat()
          )
          slideUp.interpolator = AnticipateInterpolator()
          slideUp.duration = 600L // Duration of the slide-up animation

          // Call SplashScreenView.remove at the end of your custom animation.
          slideUp.doOnEnd { splashScreenView.remove() }

          // Run your animation.
          slideUp.start()
        }, 1000L) // Delay in milliseconds (e.g., 1000ms = 1 second)
      }
    }

    super.onCreate(savedInstanceState)
  }
}
