package com.uit.party.ui.profile.editprofile

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.uit.party.R
import com.uit.party.databinding.FragmentEditProfileBinding
import com.uit.party.ui.main.MainActivity

@Suppress("DEPRECATION")
class EditProfileFragment : Fragment(){
    private lateinit var binding: FragmentEditProfileBinding
    private lateinit var viewModel: EditProfileFragmentViewModel
    private lateinit var activity: MainActivity


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_edit_profile, container, false)
        viewModel = EditProfileFragmentViewModel(activity)
        binding.viewModel = viewModel
        return binding.root
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        setupActionBar()
        setupRadioButton()
    }

    private fun setupActionBar() {
        binding.toolbarEditProfile.setNavigationIcon(R.drawable.ic_arrow_back_green_24dp)
        binding.toolbarEditProfile.setNavigationOnClickListener{
            (context as MainActivity).onBackPressed()
        }
        binding.toolbarEditProfile.title = getString(R.string.toolbar_edit_profile)
        binding.toolbarEditProfile.setTitleTextColor(resources.getColor(R.color.colorWhile))
    }

    private fun setupRadioButton(){
        binding.rgSex.setOnCheckedChangeListener { _, checkedId ->
            when(checkedId){
                R.id.rb_male -> viewModel.mSex = getString(R.string.sex_male)
                R.id.rb_female -> viewModel.mSex = getString(R.string.sex_female)
            }
        }
        binding.rgSex.check(R.id.rb_male)
    }

    companion object{
        fun newInstance(activity: MainActivity): EditProfileFragment{
            return EditProfileFragment().apply {
                this.activity = activity
            }
        }
    }
}