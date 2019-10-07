package com.uit.party.ui.profile

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.uit.party.R
import com.uit.party.databinding.FragmentProfileBindingImpl

class ProfileFragment : Fragment(){
    private lateinit var binding : FragmentProfileBindingImpl
    private val mViewModel = ProfileFragmentViewModel()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        setUpBinding(inflater, container)

        return binding.root
    }

    private fun setUpBinding(inflater: LayoutInflater, container: ViewGroup?) {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_profile , container, false)
        binding.viewModel = mViewModel
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
    }

    companion object{
        fun newInstance() : ProfileFragment {
            return ProfileFragment()
        }
    }
}