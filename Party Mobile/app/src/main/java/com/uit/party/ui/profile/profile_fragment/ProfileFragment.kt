package com.uit.party.ui.profile.profile_fragment

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.uit.party.R
import com.uit.party.databinding.FragmentProfileBindingImpl
import com.uit.party.ui.profile.ProfileActivity

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
            ProfileFragmentViewModel(context as ProfileActivity)
        binding.viewModel = mViewModel
        return binding.root
    }


    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        setupAppBar()
    }

    @SuppressLint("NewApi")
    private fun setupAppBar(){
        binding.toolBarProfile.setNavigationIcon(R.drawable.ic_arrow_back_green_24dp)
        binding.toolBarProfile.title = getString(R.string.profile_detail)
        binding.toolBarProfile.setTitleTextColor(resources.getColor(R.color.colorWhile, context?.theme))
        binding.toolBarProfile.setNavigationOnClickListener {
            (context as ProfileActivity).finish()
        }
    }

    companion object{
        fun newInstance() : ProfileFragment {
            return ProfileFragment()
        }
    }
}