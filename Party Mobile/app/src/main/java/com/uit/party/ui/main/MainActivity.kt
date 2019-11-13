package com.uit.party.ui.main

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.Gravity
import android.view.LayoutInflater
import android.view.Menu
import android.view.MenuItem
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.GravityCompat
import androidx.databinding.DataBindingUtil
import androidx.drawerlayout.widget.DrawerLayout
import androidx.navigation.findNavController
import androidx.navigation.ui.AppBarConfiguration
import androidx.navigation.ui.navigateUp
import androidx.navigation.ui.setupActionBarWithNavController
import androidx.navigation.ui.setupWithNavController
import com.bumptech.glide.Glide
import com.bumptech.glide.request.RequestOptions
import com.uit.party.R
import com.uit.party.databinding.ActivityMainBinding
import com.uit.party.databinding.NavHeaderMainBinding
import com.uit.party.model.Account
import com.uit.party.ui.main.detail_dish.DetailDishFragment
import com.uit.party.ui.main.main_menu.MenuFragment
import com.uit.party.ui.signin.SignInActivity
import com.uit.party.ui.signin.login.LoginViewModel.Companion.USER_INFO_KEY
import com.uit.party.util.SetupConnectToServer
import com.uit.party.util.SharedPrefs
import com.uit.party.util.rxbus.RxBus
import com.uit.party.util.rxbus.RxEvent
import io.reactivex.disposables.Disposable
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity(){
    lateinit var binding: ActivityMainBinding
    private lateinit var headerBinding: NavHeaderMainBinding

    private val mViewModel = MainViewModel()
    private lateinit var mDisposableItemDish: Disposable

    private lateinit var appBarConfiguration: AppBarConfiguration


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

        setSupportActionBar(binding.appBar)
        headerBinding =
            DataBindingUtil.inflate(LayoutInflater.from(this), R.layout.nav_header_main, drawer_layout, false)

        binding.navView.addHeaderView(headerBinding.root)

        val navController = findNavController(R.id.nav_host_fragment)
        appBarConfiguration = AppBarConfiguration(setOf(
            R.id.nav_user_home, R.id.nav_user_profile), binding.drawerLayout)
        setupActionBarWithNavController(navController, appBarConfiguration)
        binding.navView.setupWithNavController(navController)
        binding.drawerLayout.isDrawerOpen(GravityCompat.START)
//        binding.drawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED)
        setNavHeader()
    }

    private fun setNavHeader(){
        val account = SharedPrefs().getInstance()[USER_INFO_KEY, Account::class.java]
        if (!account?.imageurl.isNullOrEmpty()) {
            Glide.with(applicationContext).load(account?.imageurl).apply { RequestOptions.circleCropTransform() }
                .into(headerBinding.ivAvatar)
        }

        if (!account?.username.isNullOrEmpty()) {
            headerBinding.tvUsername.text = account?.username
        }
        if (!account?.fullName.isNullOrEmpty()) {
            headerBinding.tvFullName.text = account?.fullName
        }
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        // Inflate the menu; this adds items to the action bar if it is present.
        menuInflater.inflate(R.menu.main_menu, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return when (item.itemId) {
            R.id.toolbar_filter -> {
                Toast.makeText(applicationContext, "Filter Clicked", Toast.LENGTH_SHORT).show()
                true
            }

            R.id.toolbar_search -> {
                Toast.makeText(applicationContext, "Search Clicked", Toast.LENGTH_SHORT).show()
                true
            }

            else -> super.onOptionsItemSelected(item)
        }
    }

    override fun onSupportNavigateUp(): Boolean {
        val navController = findNavController(R.id.nav_host_fragment)
        return navController.navigateUp(appBarConfiguration) || super.onSupportNavigateUp()
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

    private fun setupBinding() {
        binding = DataBindingUtil.setContentView(this, R.layout.activity_main)
        binding.viewModel = mViewModel
    }

    private fun listenRxBus() {
        mDisposableItemDish = RxBus.listen(RxEvent.ShowItemDishDetail::class.java).subscribe { model ->
            val fragment = DetailDishFragment.newInstance(model = model.dishModel, position = model.position, dishType = model.dishType)
//            AddNewFragment().addNewSlideUp(R.id.main_container, fragment, true,  this)
        }
    }

    override fun onResume() {
        super.onResume()
        listenRxBus()
    }

    override fun onStop() {
        super.onStop()
        if (!mDisposableItemDish.isDisposed) mDisposableItemDish.dispose()
    }
}