package com.uit.party.ui.profile.editprofile

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.uit.party.R
import com.uit.party.databinding.FragmentEditProfileBinding
import com.uit.party.ui.profile.ProfileActivity
import com.uit.party.util.StringUtil

class EditProfileFragment : Fragment(){

    private lateinit var binding: FragmentEditProfileBinding
    private val viewModel = EditProfileFragmentViewModel()


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_edit_profile, container, false)
        binding.viewModel = viewModel
        return binding.root
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        setupActionBar()
    }

    private fun setupActionBar() {
        binding.toolbarEditProfile.setNavigationIcon(R.drawable.ic_arrow_back_green_24dp)
        binding.toolbarEditProfile.setNavigationOnClickListener{
            (context as ProfileActivity).onBackPressed()
        }
        binding.toolbarEditProfile.title = StringUtil.getString(R.string.edit_profile)
    }

    companion object{
        fun newInstance(): EditProfileFragment{
            return EditProfileFragment()
        }
    }
}