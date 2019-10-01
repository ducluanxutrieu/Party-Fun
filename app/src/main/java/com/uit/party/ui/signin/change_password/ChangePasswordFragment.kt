package com.uit.party.ui.signin.change_password

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.uit.party.R
import com.uit.party.databinding.FragmentForgotPasswordBinding
import com.uit.party.ui.main.MainActivity

// TODO: Rename parameter arguments, choose names that match
// the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
private const val USERNAME_KEY = "username"

class ChangePasswordFragment : Fragment(), ChangePasswordCallback {
    private var param1: String? = null
    private lateinit var binding: FragmentForgotPasswordBinding
    private val viewModel = ChangePasswordViewModel(this)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        arguments?.let {
            param1 = it.getString(USERNAME_KEY)
        }
    }

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

    override fun onBackMain() {
        if (context is MainActivity){
            (context as MainActivity).supportFragmentManager.popBackStack()
        }
    }

    companion object {
        /**
         * Use this factory method to create a new instance of
         * this fragment using the provided parameters.
         *
         * @param username Parameter 1.
         * @return A new instance of fragment ForgetPasswordFragment.
         */
        // TODO: Rename and change types and number of parameters
        @JvmStatic
        fun newInstance(username: String) =
            ChangePasswordFragment().apply {
                arguments = Bundle().apply {
                    putString(USERNAME_KEY, username)
                }
            }
    }
}
