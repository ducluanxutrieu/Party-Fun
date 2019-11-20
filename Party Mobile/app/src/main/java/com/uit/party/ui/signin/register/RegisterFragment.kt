package com.uit.party.ui.signin.register

import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewAnimationUtils
import android.view.ViewGroup
import android.view.animation.AccelerateInterpolator
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.navArgs
import com.uit.party.R
import com.uit.party.databinding.FragmentRegisterBinding
import com.uit.party.ui.signin.SignInActivity


class RegisterFragment : Fragment(), RegisterCallback {
    private lateinit var binding: FragmentRegisterBinding
    private lateinit var viewModel: RegisterViewModel
    private var cX = 0
    private var cY = 0
    private val myArgs : RegisterFragmentArgs by navArgs()


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        setupBinding(container)
        return binding.root
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        cX = myArgs.cXFAB
        cY = myArgs.cYFAB
        animateRevealShow()
    }

    private fun setupBinding(container: ViewGroup?) {
        binding = DataBindingUtil.inflate(
            LayoutInflater.from(context),
            R.layout.fragment_register,
            container,
            false
        )
        viewModel = RegisterViewModel(this)
        binding.viewModel = viewModel
        viewModel.init(this)
    }

    override fun onBackLogin() {
        animateRevealClose()
    }

    private fun animateRevealShow() {
        val mAnimator = ViewAnimationUtils.createCircularReveal(
            binding.cvAdd,
            cX,
            cY,
            binding.cvAdd.height.toFloat(),
            cY.toFloat()
        )
        mAnimator.duration = 300
        mAnimator.interpolator = AccelerateInterpolator()
        mAnimator.start()
    }

    private fun animateRevealClose() {
        val mAnimator = ViewAnimationUtils.createCircularReveal(
            binding.cvAdd,
            cX,
            cY,
            binding.cvAdd.height.toFloat(),
            cY.toFloat()
        )
        mAnimator.duration = 300
        mAnimator.interpolator = AccelerateInterpolator()
        mAnimator.addListener(object : AnimatorListenerAdapter() {
            override fun onAnimationEnd(animation: Animator) {
                super.onAnimationEnd(animation)
                (context as SignInActivity).onBackPressed()
            }
        })
        mAnimator.start()
    }
}