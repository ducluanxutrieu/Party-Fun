package com.uit.party.ui

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.transition.Explode
import android.util.Log
import android.widget.Toast
import androidx.core.app.ActivityOptionsCompat
import androidx.databinding.DataBindingUtil
import androidx.lifecycle.ViewModelProviders
import com.uit.party.R
import com.uit.party.view_model.login.LoginResultCallback
import com.uit.party.view_model.login.LoginViewModel
import com.uit.party.view_model.login.LoginViewModelFactory
import com.uit.party.databinding.ActivityLoginBinding
import com.uit.party.model.LoginModel

class LoginActivity : AppCompatActivity(), LoginResultCallback {
    private lateinit var shareReference: SharedPreferences

    private lateinit var binding: ActivityLoginBinding

    private var viewModel = LoginViewModel(this)

    companion object{
        const val SHARE_REFERENCE_NAME = "com.uit.party"
        const val SHARE_REFERENCE_MODE = Context.MODE_PRIVATE
        const val TAG = "TAGMain"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setupBinding()
        setupAnimationActivity()
        shareReference = this.getSharedPreferences(SHARE_REFERENCE_NAME, SHARE_REFERENCE_MODE)
    }

    private fun setupAnimationActivity() {
        val explode = Explode()
        explode.duration = 500
        window.exitTransition = explode
        window.enterTransition = explode
    }

    private fun setupBinding() {
        binding = DataBindingUtil.setContentView(this, R.layout.activity_login)
        viewModel = ViewModelProviders.of(this,
            LoginViewModelFactory(this)
        ).get(LoginViewModel::class.java)

        binding.viewModel = viewModel
    }

    private fun updateUiWithUser(model: LoginModel) {
        Toast.makeText(applicationContext, "Login successful - Welcome ${model.fullname}", Toast.LENGTH_LONG).show()
        Log.i(TAG, model.toString())
        viewModel.saveToMemory(model)

        val intent = Intent(applicationContext, MainActivity::class.java)
        intent.putExtra("userInfo", model)
        startActivity(intent)
        finish()
    }

    override fun onSuccess(success: String) {
        Toast.makeText(applicationContext, "Login Success", Toast.LENGTH_LONG).show()
    }

    override fun onError(error: String) {
        Toast.makeText(applicationContext, "Login Error", Toast.LENGTH_LONG).show()
    }

    override fun onRepos(loginModel: LoginModel) {
        updateUiWithUser(loginModel)
    }

    override fun onRegister() {
        window.exitTransition = null
        window.enterTransition = null
        val option = ActivityOptionsCompat.makeSceneTransitionAnimation(this, binding.fab, binding.fab.transitionName)
        val intent = Intent(this, RegisterActivity::class.java)
        startActivity(intent, option.toBundle())
    }


}
