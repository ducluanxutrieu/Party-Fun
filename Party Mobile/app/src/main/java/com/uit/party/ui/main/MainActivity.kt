package com.uit.party.ui.main

import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import com.uit.party.R
import com.uit.party.databinding.ActivityMainBinding
import com.uit.party.model.Account
import com.uit.party.model.DishModel
import com.uit.party.ui.main.detail_dish.DetailDishFragment
import com.uit.party.ui.main.main_menu.MenuFragment
import com.uit.party.ui.signin.SignInActivity
import com.uit.party.ui.signin.login.LoginViewModel.Companion.USER_INFO_KEY
import com.uit.party.util.AddNewFragment
import com.uit.party.util.SetupConnectToServer
import com.uit.party.util.SharedPrefs
import com.uit.party.util.rxbus.RxBus
import com.uit.party.util.rxbus.RxEvent
import io.reactivex.disposables.Disposable

class MainActivity : AppCompatActivity(){
    lateinit var binding: ActivityMainBinding
    private val mViewModel = MainViewModel()
    private lateinit var mDisposableItemDish: Disposable


    companion object {
        const val SHARE_REFERENCE_NAME = "com.uit.party.ui"
        const val SHARE_REFERENCE_MODE = Context.MODE_PRIVATE
        internal var TOKEN_ACCESS: String = ""
        const val TAG = "TAGMain"
        val serviceRetrofit = SetupConnectToServer().setupConnect()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setupBinding()
        checkLogin()
        listenRxBus()
    }

    private fun checkLogin() {
        val account = SharedPrefs().getInstance()[USER_INFO_KEY, Account::class.java]
        if (account?.token.isNullOrEmpty()) {
            goToSignIn()
        } else {
            TOKEN_ACCESS = account?.token.toString()
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
            val fragment = MenuFragment.newInstance(account)
            AddNewFragment().addFragment(R.id.main_container, fragment, true, this)
        }
    }

    private fun setupBinding() {
        binding = DataBindingUtil.setContentView(this, R.layout.activity_main)
        binding.viewModel = mViewModel
        showFragment()
    }

    private fun listenRxBus() {
        mDisposableItemDish = RxBus.listen(RxEvent.ShowItemDishDetail::class.java).subscribe { model ->
            val fragment = DetailDishFragment.newInstance(model = model.dishModel, position = model.position, dishType = model.dishType)
            AddNewFragment().addNewSlideUp(R.id.main_container, fragment, true,  this)
        }
    }

    override fun onStop() {
        super.onStop()
        if (!mDisposableItemDish.isDisposed) mDisposableItemDish.dispose()
    }
}