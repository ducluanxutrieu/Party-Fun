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
import com.uit.party.ui.signin.login.LoginViewModel.Companion.TOKEN_ACCESS
import com.uit.party.ui.signin.login.LoginViewModel.Companion.USER_INFO_KEY
import com.uit.party.util.AddNewFragment
import com.uit.party.util.SetupConnectToServer
import com.uit.party.util.SharedPrefs

class MainActivity : AppCompatActivity() {
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
        val account = createAccount()
        SharedPrefs().getInstance().put(USER_INFO_KEY, account)
        TOKEN_ACCESS = account.token!!
        checkLogin()
    }

    private fun createAccount(): Account {
        val account = Account()
        account._id = "1221"
        account.email = "ducluanxutrieu@gmail.com"
        account.fullName = "Trần Đức Luân"
        account.phoneNumber = "012345678"
        account.username = "ducluanxutrieu"
        account.birthday = "01/01/1997"
        account.sex = "Male"
        account.token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6Imx1YW4iLCJpYXQiOjE1NzA5ODQzMjAsImV4cCI6MTU3MTE1NzEyMH0.gvdiBYHiaAw8vtw10b0l_n3NmalwAWfc42gyX5l9Rg0"
        account.role = "Staff"
        account.imageurl =
            "https://t.a4vn.com/2019/03/10/bo-anh-girl-xinh-hai-phong-don-tim-cong-dong-mang-52a.jpg"
        return account
    }

    private fun checkLogin() {
        val account = SharedPrefs().getInstance()[USER_INFO_KEY, Account::class.java]
        if (account?.token.isNullOrEmpty()) {
            goToSignIn()
        } else {
            showFragment()
        }
    }

    private fun goToSignIn() {
        val intent = Intent(this, SignInActivity::class.java)
        startActivity(intent)
        finish()
    }

    private fun showFragment() {
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