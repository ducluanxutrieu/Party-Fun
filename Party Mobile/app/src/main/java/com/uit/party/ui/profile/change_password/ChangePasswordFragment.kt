package com.uit.party.ui.profile.change_password

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.uit.party.R
import com.uit.party.databinding.FragmentForgotPasswordBinding
import com.uit.party.ui.profile.ProfileActivity

class ChangePasswordFragment(mActivity: ProfileActivity) : Fragment(){
    private lateinit var binding: FragmentForgotPasswordBinding
    private val viewModel = ChangePasswordViewModel(mActivity)

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        setupBinding(inflater, container)
        return binding.root
    }

    private fun setupBinding(inflater: LayoutInflater, container: ViewGroup?) {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_forgot_password, container, false)
        binding.viewModel = viewModel
    }

    companion object {
        fun newInstance( activity: ProfileActivity) : ChangePasswordFragment{
            return ChangePasswordFragment(activity)
        }
    }
}
