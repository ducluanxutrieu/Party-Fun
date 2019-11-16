package com.uit.party.ui.profile.change_password

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.uit.party.R
import com.uit.party.databinding.FragmentChangePasswordBinding

class ChangePasswordFragment : Fragment(){
    private lateinit var binding: FragmentChangePasswordBinding
    private val viewModel = ChangePasswordViewModel()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_change_password, container, false)
        binding.viewModel = viewModel
        return binding.root
    }

/*
    @SuppressLint("NewApi")
    private fun setupActionBar() {
        binding.toolbarChangePassword.setNavigationIcon(R.drawable.ic_arrow_back_green_24dp)
        binding.toolbarChangePassword.setNavigationOnClickListener{
            (context as MainActivity).onBackPressed()
        }
        binding.toolbarChangePassword.title = getString(R.string.toolbar_change_password)
        binding.toolbarChangePassword.setTitleTextColor(resources.getColor(R.color.colorWhile, context?.theme))
    }
*/
}
