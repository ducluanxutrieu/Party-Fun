package com.uit.party.ui.main

import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import com.uit.party.R
import com.uit.party.databinding.ActivityMainBinding
import com.uit.party.model.Account
import com.uit.party.ui.main.list_dish.ListDishFragment
import com.uit.party.ui.signin.SignInActivity
import com.uit.party.ui.signin.login.LoginViewModel.Companion.USER_INFO_KEY
import com.uit.party.util.AddNewFragment
import com.uit.party.util.SetupConnectToServer
import com.uit.party.util.SharedPrefs

class MainActivity : AppCompatActivity(){
    lateinit var binding: ActivityMainBinding
    private val viewModel = MainViewModel()

    companion object {
        const val SHARE_REFERENCE_NAME = "com.uit.party.ui"
        const val SHARE_REFERENCE_MODE = Context.MODE_PRIVATE
        const val TAG = "TAGMain"
        val serviceRetrofit = SetupConnectToServer().setupConnect()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setupBinding()

        //goToSignIn()
        checkLogin()
    }

    private fun checkLogin(){
//        val shareReference = getSharedPreferences(SHARE_REFERENCE_NAME, SHARE_REFERENCE_MODE)
        val account = SharedPrefs().getInstance()[USER_INFO_KEY, Account::class.java]
        if (account?.token.isNullOrEmpty()){
            goToSignIn()
        }else{
            showFragment()
        }
    }

    private fun goToSignIn() {
        val intent = Intent(this, SignInActivity::class.java)
        startActivity(intent)
        finish()
    }

    private fun showFragment() {
        val shareReference = getSharedPreferences(
            SHARE_REFERENCE_NAME,
            SHARE_REFERENCE_MODE
        )
//        val avatarUrl = shareReference.getString(LoginViewModel.AVATAR_KEY, "").toString()
//        val username = shareReference.getString(LoginViewModel.USERNAME_KEY, "").toString()
//        val fullName = shareReference.getString(LoginViewModel.FULL_NAME_KEY, "").toString()
        val account = SharedPrefs().getInstance()[USER_INFO_KEY, Account::class.java]

        if (account != null) {
            val fragment = ListDishFragment.newInstance(account)
            AddNewFragment().addFragment(R.id.main_container, fragment, true, this)
        }
    }

    private fun setupBinding() {
        binding = DataBindingUtil.setContentView(this, R.layout.activity_main)
        binding.viewModel = viewModel

    }
}