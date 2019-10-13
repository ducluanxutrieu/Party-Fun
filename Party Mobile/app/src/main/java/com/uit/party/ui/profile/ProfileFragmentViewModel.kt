package com.uit.party.ui.profile

import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel
import com.uit.party.R
import com.uit.party.model.Account
import com.uit.party.ui.profile.editprofile.EditProfileFragment
import com.uit.party.ui.signin.login.LoginViewModel.Companion.USER_INFO_KEY
import com.uit.party.util.AddNewFragment
import com.uit.party.util.SharedPrefs

class ProfileFragmentViewModel(val context: ProfileActivity) : ViewModel(){
    val mName = ObservableField("")
    val mEmail = ObservableField("")
    val mMobile = ObservableField("")
    val mSex = ObservableField("")
    val mBirthDay = ObservableField("")
    val mAvatar = ObservableField("")
    val mRole = ObservableField("")

    private val mAccount = SharedPrefs().getInstance()[USER_INFO_KEY, Account::class.java]

    init {
        mName.set(mAccount?.username)
        mEmail.set(mAccount?.email)
        mSex.set(mAccount?.sex)
        mBirthDay.set(mAccount?.birthday)
        mAvatar.set(mAccount?.imageurl)
        mMobile.set(mAccount?.phoneNumber)
    }

    fun editProfile(){
        val fragment = EditProfileFragment.newInstance()
        AddNewFragment().addNewSlideUp(R.id.profile_container, fragment, true, context)
    }

    fun changePassword(){

    }
}