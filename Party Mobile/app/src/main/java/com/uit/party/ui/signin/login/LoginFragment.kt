package com.uit.party.ui.signin.login

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.uit.party.R
import com.uit.party.databinding.FragmentLoginBinding
import com.uit.party.model.LoginModel
import com.uit.party.ui.main.MainActivity
import com.uit.party.ui.main.MainActivity.Companion.TAG
import com.uit.party.ui.signin.SignInActivity
import com.uit.party.ui.signin.SignInCallback
import com.uit.party.util.ToastUtil

class LoginFragment : Fragment(), LoginCallback {
    private lateinit var binding: FragmentLoginBinding

    private var viewModel = LoginViewModel(this)

    private lateinit var signInCallback : SignInCallback

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        setupBinding(container = container)
        return binding.root

    }

    private fun setupBinding(container: ViewGroup?) {
        binding = DataBindingUtil.inflate(LayoutInflater.from(context), R.layout.fragment_login, container, false)
        binding.viewModel = viewModel
    }

    private fun updateUiWithUser(model: LoginModel) {
        Log.i(TAG, model.toString())
        val intent = Intent(context, MainActivity::class.java)
        intent.putExtra("userInfo", model)
        startActivity(intent)
    }

    override fun onSuccess(success: String) {
        ToastUtil().showToast("Login Success")
        gotoMainActivity()
    }

    private fun gotoMainActivity() {
        val context = context as SignInActivity
        val intent = Intent(context, MainActivity::class.java)
        startActivity(intent)
        context.finish()
    }

    override fun onError(error: String) {
        ToastUtil().showToast("Login Error")
    }

    override fun onRepos(loginModel: LoginModel) {
        updateUiWithUser(loginModel)
    }

    override fun onRegister() {
        signInCallback.onRegister(binding.tvRegister.width/2 + binding.tvRegister.x, binding.tvRegister.height/2 + binding.tvRegister.y, binding.tvRegister)
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        if (context is SignInActivity){
            signInCallback = context
        }
    }
}
