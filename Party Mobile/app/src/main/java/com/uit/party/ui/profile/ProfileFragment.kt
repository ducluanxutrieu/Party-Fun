package com.uit.party.ui.profile

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.uit.party.R
import com.uit.party.databinding.FragmentProfileBindingImpl

class ProfileFragment : Fragment(){
    private lateinit var binding : FragmentProfileBindingImpl
    private val mViewModel = ProfileFragmentViewModel(context as ProfileActivity)

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_profile , container, false)
        binding.viewModel = mViewModel

        return binding.root
    }


    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        setupAppBar()
    }

    private fun setupAppBar(){
        binding.profileToolBar.setNavigationIcon(R.drawable.ic_arrow_back_green_24dp)
        binding.profileToolBar.title = getString(R.string.profile_detail)
        binding.profileToolBar.setTitleTextColor(resources.getColor(R.color.colorWhile))
        binding.profileToolBar.setNavigationOnClickListener {
            (context as ProfileActivity).finish()
        }
    }

    companion object{
        fun newInstance() : ProfileFragment {
            return ProfileFragment()
        }
    }
}