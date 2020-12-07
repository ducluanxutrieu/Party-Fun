package com.uit.party.ui.signin.reset_password

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.widget.doOnTextChanged
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import com.uit.party.R
import com.uit.party.databinding.FragmentResetPasswordBinding
import com.uit.party.ui.signin.SignInActivity
import javax.inject.Inject

class ResetPasswordFragment : Fragment() {

    @Inject
    lateinit var viewModel: ResetPasswordViewModel

    private lateinit var binding: FragmentResetPasswordBinding

    override fun onAttach(context: Context) {
        super.onAttach(context)

        val activity = requireActivity()
        if (activity is SignInActivity){
            activity.signInComponent.inject(this)
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {

        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_reset_password, container, false)
        binding.viewModel = viewModel
        setupListener()
        return binding.root
    }

    private fun setupListener(){
        binding.etUsername.doOnTextChanged { text, _, _, _ ->
            viewModel.checkUsernameValid(text)
        }

        viewModel.resetPassState.observe(viewLifecycleOwner, {
            if (it){
                val action = ResetPasswordFragmentDirections.actionResetPasswordFragmentToChangePasswordFragment("RESET")
                this.findNavController().navigate(action)
            }
        })
    }
}