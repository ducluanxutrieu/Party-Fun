package com.uit.party.ui

import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.transition.Transition
import android.transition.TransitionInflater
import android.view.View
import android.view.ViewAnimationUtils
import android.view.animation.AccelerateInterpolator
import android.widget.Toast
import androidx.databinding.DataBindingUtil
import androidx.lifecycle.ViewModelProviders
import com.uit.party.R
import com.uit.party.databinding.ActivityRegisterBinding
import com.uit.party.view_model.register.RegisterCallback
import com.uit.party.view_model.register.RegisterViewModel
import com.uit.party.view_model.register.RegisterViewModelFactory
import kotlinx.android.synthetic.main.activity_register.*

class RegisterActivity : AppCompatActivity(), RegisterCallback {
    private lateinit var binding: ActivityRegisterBinding
    private lateinit var viewModel: RegisterViewModel
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setupBinding()
        showEnterAnimation()
    }

    private fun showEnterAnimation() {
        val transition = TransitionInflater.from(this).inflateTransition(R.transition.fabtransition)
        window.sharedElementEnterTransition = transition

        transition.addListener(object : Transition.TransitionListener{
            override fun onTransitionEnd(p0: Transition?) {
                transition.removeListener(this)
                animateRevealShow()
            }

            override fun onTransitionResume(p0: Transition?) {
            }

            override fun onTransitionPause(p0: Transition?) {
            }

            override fun onTransitionCancel(p0: Transition?) {
            }

            override fun onTransitionStart(p0: Transition?) {
                binding.viewModel?.setCardViewShow()
            }

        })
    }



    private fun setupBinding() {
        binding = DataBindingUtil.setContentView(this, R.layout.activity_register)
        viewModel = ViewModelProviders.of(this,
            RegisterViewModelFactory(this)
        ).get(RegisterViewModel(this)::class.java)
        binding.viewModel = viewModel
        viewModel.init(this)
    }

    override fun onBackLogin() {
       animateRevealClose()
        super.onBackPressed()
    }

    override fun onRegister() {

    }

    override fun onFail(message: String) {
        Toast.makeText(this, message, Toast.LENGTH_LONG).show()
    }


    override fun onBackPressed() {
        animateRevealClose()
        super.onBackPressed()
    }

    fun animateRevealShow() {
        val mAnimator = ViewAnimationUtils.createCircularReveal(binding.cvAdd, binding.cvAdd.width/2, 0,(fab.width/2).toFloat(), binding.cvAdd.height.toFloat())
        mAnimator.duration = 500
        mAnimator.interpolator = AccelerateInterpolator()
        mAnimator.addListener(object : AnimatorListenerAdapter(){
            override fun onAnimationStart(animation: Animator?) {
                binding.viewModel?.showCardView?.set(View.VISIBLE)
                super.onAnimationStart(animation)
            }
        })
        mAnimator.start()
    }

    private fun animateRevealClose() {
        val mAnimator = ViewAnimationUtils.createCircularReveal(binding.cvAdd, binding.cvAdd.width / 2, 0, binding.cvAdd.height.toFloat(), (fab.width / 2).toFloat())
        mAnimator.duration = 500
        mAnimator.interpolator = AccelerateInterpolator()
        mAnimator.addListener(object : AnimatorListenerAdapter() {
            override fun onAnimationEnd(animation: Animator) {
                binding.viewModel?.showCardView?.set(View.INVISIBLE)
                super.onAnimationEnd(animation)
                fab.setImageResource(R.drawable.plus)
            }
        })
        mAnimator.start()
    }
}
