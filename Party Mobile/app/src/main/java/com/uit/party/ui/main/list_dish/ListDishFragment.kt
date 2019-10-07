package com.uit.party.ui.main.list_dish

import android.content.Intent
import android.content.SharedPreferences
import android.os.Bundle
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.bumptech.glide.Glide
import com.bumptech.glide.request.RequestOptions
import com.uit.party.R
import com.uit.party.databinding.FragmentListDishBinding
import com.uit.party.databinding.NavHeaderMainBinding
import com.uit.party.ui.main.DishAdapter
import com.uit.party.ui.main.MainActivity
import com.uit.party.ui.main.detail_dish.DetailDishFragment
import com.uit.party.ui.signin.SignInActivity
import com.uit.party.ui.signin.change_password.ChangePasswordFragment
import com.uit.party.ui.signin.login.LoginViewModel.Companion.TOKEN_ACCESS
import com.uit.party.util.AddNewFragment
import com.uit.party.util.ToastUtil
import kotlinx.android.synthetic.main.nav_header_main.view.*

@Suppress("DEPRECATION")
class ListDishFragment : Fragment(), DishAdapter.DishItemOnClicked {
    private lateinit var shareReference: SharedPreferences

    private var avatarUrl: String = ""
    private var username: String = ""
    private var fullName: String = ""


    val mViewModel = ListDishViewModel()
    lateinit var binding: FragmentListDishBinding
    lateinit var headerBinding: NavHeaderMainBinding
    private val adapter = DishAdapter(this)

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        setupBinding(container, inflater)

        return binding.root
    }

    private fun setupBinding(container: ViewGroup?, inflater: LayoutInflater) {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_list_dish, container, false)

        headerBinding = DataBindingUtil.inflate(inflater, R.layout.nav_header_main, container, false)

        binding.navView.addHeaderView(headerBinding.root)

        binding.viewModel = mViewModel
        mViewModel.init()
        binding.recyclerView.adapter = adapter
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        setupDrawer()
        setupActionBar()
    }

    private fun setupDrawer(){
        if (avatarUrl.isNotEmpty()) {
            Glide.with(context!!).load(avatarUrl).apply { RequestOptions.circleCropTransform() }
                .into(binding.navView.iv_avatar)
        }

        if (username.isNotEmpty()) {
            headerBinding.tvUsername.text = username
        }
        if (fullName.isNotEmpty()) {
            headerBinding.tvFullName.text = fullName
        }
    }

    private fun setupActionBar() {
        binding.appBar.setNavigationIcon(R.drawable.ic_navigation_bar_while_24dp)
        binding.appBar.title = getString(R.string.uit_party)
        binding.appBar.setTitleTextColor(resources.getColor(R.color.colorWhile))
        binding.appBar.setNavigationOnClickListener {
            Toast.makeText(context, "Navigation bar Clicked", Toast.LENGTH_SHORT).show()
            binding.drawerLayout.openDrawer(Gravity.START)
        }

        binding.appBar.inflateMenu(R.menu.main_menu)
        binding.appBar.setOnMenuItemClickListener {
            when (it.itemId) {
                R.id.ToolbarFilterIcon -> {
                    Toast.makeText(context, "Filter Clicked", Toast.LENGTH_SHORT).show()
                    true
                }

                R.id.ToolbarSearchIcon -> {
                    Toast.makeText(context, "Search Clicked", Toast.LENGTH_SHORT).show()
                    true
                }

                R.id.ToolbarChangePassword -> {
                    changePassword()
                    true
                }

                R.id.ToolbarLogout -> {
                    logOut()
                    true
                }

                else -> super.onOptionsItemSelected(it)
            }
        }
    }

    private fun changePassword() {
        val fragment = ChangePasswordFragment.newInstance(TOKEN_ACCESS)
        AddNewFragment().addNewSlideUp(R.id.main_container, fragment, true, context as MainActivity)
    }

    private fun logOut() {
        shareReference.edit()?.clear()?.apply()
        mViewModel.logout {
            if (it){
                val intent = Intent(context, SignInActivity::class.java)
                startActivity(intent)
                (context as MainActivity).finish()
            }else{
                ToastUtil().showToast(getString(R.string.cannot_logout))
            }
        }
    }

    override fun onItemDishClicked(position: Int, item: DishModel) {
        val fragment = DetailDishFragment.newInstance(item, position)
        AddNewFragment().addNewSlideUp(R.id.main_container, fragment, true, context as MainActivity)
    }

    companion object {
        fun newInstance(sharedPreferences: SharedPreferences, avatar: String, username: String, fullName: String): ListDishFragment {
            return ListDishFragment().apply {
                this.shareReference = sharedPreferences
                this.avatarUrl = avatar
                this.username = username
                this.fullName = fullName
            }
        }
    }

}