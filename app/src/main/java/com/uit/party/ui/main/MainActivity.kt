package com.uit.party.ui.main

import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.ListFragment
import com.uit.party.R
import com.uit.party.databinding.ActivityMainBinding
import com.uit.party.ui.main.detail_dish.DetailDishFragment
import com.uit.party.ui.main.list_dish.DishModel
import com.uit.party.ui.main.list_dish.ListDishFragment
import com.uit.party.ui.signin.SignInActivity
import com.uit.party.ui.signin.login.LoginFragment
import com.uit.party.util.AddNewFragment
import com.uit.party.util.SetupConnectToServer

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
        val shareReference = getSharedPreferences(SHARE_REFERENCE_NAME, SHARE_REFERENCE_MODE)
        val token =  shareReference.getString("token", null)
        if (token == null){
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
        val fragment = ListDishFragment.newInstance()
        AddNewFragment().addFragment(R.id.main_container, fragment, true, this)
    }

    private fun setupBinding() {
        binding = DataBindingUtil.setContentView(this, R.layout.activity_main)
        binding.viewModel = viewModel

    }
}