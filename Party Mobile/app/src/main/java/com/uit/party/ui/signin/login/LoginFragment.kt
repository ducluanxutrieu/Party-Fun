package com.uit.party.ui.signin.login

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.uit.party.R
import com.uit.party.databinding.FragmentLoginBinding

class LoginFragment : Fragment() {
    private lateinit var binding: FragmentLoginBinding

    private var viewModel = LoginViewModel()


    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        setupBinding(container = container)
        return binding.root

    }

    private fun setupBinding(container: ViewGroup?) {
        binding = DataBindingUtil.inflate(LayoutInflater.from(context), R.layout.fragment_login, container, false)
        binding.viewModel = viewModel
    }
}
