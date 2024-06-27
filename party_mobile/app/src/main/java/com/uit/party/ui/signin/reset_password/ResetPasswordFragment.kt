package com.uit.party.ui.signin.reset_password

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.uit.party.R
import com.uit.party.databinding.FragmentResetPasswordBinding

class ResetPasswordFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        val binding: FragmentResetPasswordBinding = DataBindingUtil.inflate(inflater, R.layout.fragment_reset_password, container, false)
        binding.viewModel = ResetPasswordViewModel()
        return binding.root
    }
}