package com.uit.party.ui.signin

import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import com.uit.party.R
import com.uit.party.databinding.ActivitySignInBinding
import com.uit.party.ui.RegisterFragment
import com.uit.party.ui.signin.login.LoginFragment
import com.uit.party.util.AddNewFragment

class SignInActivity : AppCompatActivity(), SignInCallback {
    private lateinit var binding : ActivitySignInBinding
    private val viewModel = SignInViewModel()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setupBinding()
        showFragment()
    }

    private fun showFragment() {
        AddNewFragment().addFragment(R.id.container, LoginFragment(), true, this)
    }

    private fun setupBinding() {
        binding = DataBindingUtil.setContentView(this, R.layout.activity_sign_in)
        binding.viewModel = viewModel
    }
    override fun onRegister(cX: Float, cY: Float, sharedElement: View) {
        val fragment = RegisterFragment.newInstance(cX, cY)
        AddNewFragment().addFragment(R.id.container, fragment, true, this)
    }
}
