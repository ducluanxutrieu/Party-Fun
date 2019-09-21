package com.uit.party.ui.signin.login

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.uit.party.R
import com.uit.party.databinding.FragmentLoginBinding
import com.uit.party.model.LoginModel
import com.uit.party.ui.MainActivity
import com.uit.party.ui.MainActivity.Companion.SHARE_REFERENCE_MODE
import com.uit.party.ui.MainActivity.Companion.SHARE_REFERENCE_NAME
import com.uit.party.ui.MainActivity.Companion.TAG
import com.uit.party.ui.signin.SignInActivity
import com.uit.party.ui.signin.SignInCallback

class LoginFragment : Fragment(), LoginCallback {
    private lateinit var shareReference: SharedPreferences

    private lateinit var binding: FragmentLoginBinding

    private var viewModel = LoginViewModel(this)

    private lateinit var signInCallback : SignInCallback

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        setupBinding(container = container)
        shareReference = context!!.getSharedPreferences(
            SHARE_REFERENCE_NAME,
            SHARE_REFERENCE_MODE
        )
        return binding.root

    }

    private fun setupBinding(container: ViewGroup?) {
        binding = DataBindingUtil.inflate(LayoutInflater.from(context), R.layout.fragment_login, container, false)
        binding.viewModel = viewModel
    }

    private fun updateUiWithUser(model: LoginModel) {
        Toast.makeText(context, "Login successful - Welcome ${model.fullname}", Toast.LENGTH_LONG).show()
        Log.i(TAG, model.toString())
        viewModel.saveToMemory(model)

        val intent = Intent(context, MainActivity::class.java)
        intent.putExtra("userInfo", model)
        startActivity(intent)
    }

    override fun onSuccess(success: String) {
        Toast.makeText(context, "Login Success", Toast.LENGTH_LONG).show()
    }

    override fun onError(error: String) {
        Toast.makeText(context, "Login Error", Toast.LENGTH_LONG).show()
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
