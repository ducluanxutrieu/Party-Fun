package com.uit.party.ui.main

import android.content.Intent
import android.os.Bundle
import android.view.LayoutInflater
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.GravityCompat
import androidx.databinding.DataBindingUtil
import androidx.navigation.findNavController
import androidx.navigation.ui.AppBarConfiguration
import androidx.navigation.ui.NavigationUI
import androidx.navigation.ui.navigateUp
import com.bumptech.glide.Glide
import com.bumptech.glide.request.RequestOptions
import com.uit.party.R
import com.uit.party.data.getToken
import com.uit.party.databinding.ActivityMainBinding
import com.uit.party.databinding.NavHeaderMainBinding
import com.uit.party.model.Account
import com.uit.party.ui.signin.SignInActivity
import com.uit.party.util.Constants.Companion.USER_INFO_KEY
import com.uit.party.util.SharedPrefs
import kotlinx.android.synthetic.main.activity_main.*


class MainActivity : AppCompatActivity(){
    lateinit var binding: ActivityMainBinding
    private lateinit var headerBinding: NavHeaderMainBinding

    private val mViewModel = MainViewModel()
    private lateinit var appBarConfiguration: AppBarConfiguration

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setupBinding()
        checkLogin()
        setSupportActionBar(binding.appBar)
        setupNavigationDrawer()
        setNavHeader()
    }

    private fun setupNavigationDrawer() {
        headerBinding =
            DataBindingUtil.inflate(
                LayoutInflater.from(this),
                R.layout.nav_header_main,
                drawer_layout,
                false
            )

        val navigationView = binding.navView
        navigationView.addHeaderView(headerBinding.root)

        val navController = findNavController(R.id.nav_host_fragment)
        appBarConfiguration = AppBarConfiguration.Builder(
            R.id.nav_user_home,
            R.id.nav_user_profile,
            R.id.nav_restaurant_address,
            R.id.nav_about_us,
            R.id.naw_user_order
        )
            .setOpenableLayout(binding.drawerLayout)
            .build()
        NavigationUI.setupActionBarWithNavController(this, navController, appBarConfiguration)
        NavigationUI.setupWithNavController(navigationView, navController)
        binding.drawerLayout.isDrawerOpen(GravityCompat.START)
    }

    private fun setNavHeader(){
        val account = SharedPrefs().getInstance()[USER_INFO_KEY, Account::class.java]
        if (!account?.avatar.isNullOrEmpty()) {
            Glide.with(applicationContext).load(account?.avatar).apply { RequestOptions.circleCropTransform() }
                .into(headerBinding.ivAvatar)
        }

        if (!account?.username.isNullOrEmpty()) {
            headerBinding.tvUsername.text = account?.username
        }
        if (!account?.fullName.isNullOrEmpty()) {
            headerBinding.tvFullName.text = account?.fullName
        }
    }

    override fun onSupportNavigateUp(): Boolean {
        val navController = findNavController(R.id.nav_host_fragment)
        return navController.navigateUp(appBarConfiguration) || super.onSupportNavigateUp()
    }

    private fun checkLogin() {
        if (getToken().isEmpty()) {
            goToSignIn()
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
}