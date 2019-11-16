package com.uit.party.ui.profile.profile_fragment

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.uit.party.R
import com.uit.party.databinding.FragmentProfileBindingImpl
import com.uit.party.ui.main.MainActivity

class ProfileFragment : Fragment(){
    private lateinit var binding : FragmentProfileBindingImpl
    private lateinit var mViewModel: ProfileFragmentViewModel

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_profile , container, false)
        mViewModel =
            ProfileFragmentViewModel(context as MainActivity)
        binding.viewModel = mViewModel
        return binding.root
    }
}