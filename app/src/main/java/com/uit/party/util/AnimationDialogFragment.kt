package com.uit.party.util

import android.animation.Animator
import android.view.View
import android.view.ViewAnimationUtils
import android.view.animation.AccelerateInterpolator
import android.view.animation.DecelerateInterpolator
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.Fragment
import java.util.*
import kotlin.math.hypot

class AnimationDialogFragment {
    fun closeDialog(fragment: DialogFragment, v: View, cX: Int, cY: Int) {

        val animator = prepareUnRevealAnimator(v, cX, cY)
        animator.addListener(object : Animator.AnimatorListener {
            override fun onAnimationRepeat(p0: Animator?) {

            }

            override fun onAnimationEnd(p0: Animator?) {
                fragment.dismiss()
            }

            override fun onAnimationCancel(p0: Animator?) {
            }

            override fun onAnimationStart(p0: Animator?) {
            }

        })
        animator.start()
    }

    fun closeFragment(fragment: Fragment, v: View, cX: Int, cY: Int) {

        val animator = prepareUnRevealAnimator(v, cX, cY)
        animator.addListener(object : Animator.AnimatorListener {
            override fun onAnimationRepeat(p0: Animator?) {

            }

            override fun onAnimationEnd(p0: Animator?) {
                fragment.activity?.onBackPressed()
            }

            override fun onAnimationCancel(p0: Animator?) {
            }

            override fun onAnimationStart(p0: Animator?) {
            }

        })
        animator.start()
    }

    fun openDialog(v: View, cX: Int, cY: Int){
        val radius = hypot(v.right.toDouble(), v.bottom.toDouble()).toInt()
        val reveal = ViewAnimationUtils.createCircularReveal(v, cX, cY, 0f, radius.toFloat())
        reveal.interpolator = AccelerateInterpolator(2f)
        reveal.duration = 500
        reveal.start()
    }


    /**
     * Get the animator to unreveal the circle
     *
     * @param cx center x of the circle (or where the view was touched)
     * @param cy center y of the circle (or where the view was touched)
     * @return Animator object that will be used for the animation
     */
    private fun prepareUnRevealAnimator(v: View, cx: Int, cy: Int): Animator {
        val radius = getEnclosingCircleRadius(v, cx, cy)
        val anim = ViewAnimationUtils.createCircularReveal(v, cx, cy, radius.toFloat(), 0f)
        anim.interpolator = AccelerateInterpolator(2f)
        anim.duration = 300
        return anim
    }

    /**
     * To be really accurate we have to start the circle on the furthest corner of the view
     *
     * @param v  the view to unreveal
     * @param cx center x of the circle
     * @param cy center y of the circle
     * @return the maximum radius
     */
    private fun getEnclosingCircleRadius(v: View, cx: Int, cy: Int): Int {
        val realCenterX = cx + v.left
        val realCenterY = cy + v.top
        val distanceTopLeft = hypot((realCenterX - v.left).toDouble(), (realCenterY - v.top).toDouble()).toInt()
        val distanceTopRight = hypot((v.right - realCenterX).toDouble(), (realCenterY - v.top).toDouble()).toInt()
        val distanceBottomLeft =
            hypot((realCenterX - v.left).toDouble(), (v.bottom - realCenterY).toDouble()).toInt()
        val distanceBottomRight =
            hypot((v.right - realCenterX).toDouble(), (v.bottom - realCenterY).toDouble()).toInt()

        val distances = arrayOf(distanceTopLeft, distanceTopRight, distanceBottomLeft, distanceBottomRight)

        return Collections.max(listOf(*distances))
    }
}
