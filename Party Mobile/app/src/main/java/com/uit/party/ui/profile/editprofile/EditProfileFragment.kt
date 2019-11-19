package com.uit.party.ui.profile.editprofile

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.uit.party.R
import com.uit.party.databinding.FragmentEditProfileBinding

@Suppress("DEPRECATION")
class EditProfileFragment : Fragment(){
    private lateinit var binding: FragmentEditProfileBinding
    private lateinit var viewModel: EditProfileFragmentViewModel


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_edit_profile, container, false)
        viewModel = EditProfileFragmentViewModel()
        binding.viewModel = viewModel
        return binding.root
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        setupRadioButton()
    }

    private fun setupRadioButton(){
        binding.rgSex.setOnCheckedChangeListener { _, checkedId ->
            when(checkedId){
                R.id.rb_male -> viewModel.mSex = getString(R.string.sex_male)
                R.id.rb_female -> viewModel.mSex = getString(R.string.sex_female)
            }
        }
    }
}