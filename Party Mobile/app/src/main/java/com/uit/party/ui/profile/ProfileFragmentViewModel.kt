package com.uit.party.ui.profile

import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel
import com.uit.party.model.Account
import com.uit.party.ui.signin.login.LoginViewModel.Companion.USER_INFO_KEY
import com.uit.party.util.SharedPrefs

class ProfileFragmentViewModel : ViewModel(){
//    private val sharedPrefs: SharedPreferences = GlobalApplication.appContext!!.getSharedPreferences(
//        MainActivity.SHARE_REFERENCE_NAME,
//        MainActivity.SHARE_REFERENCE_MODE
//    )
    val mName = ObservableField("")
    val mEmail = ObservableField("")
    val mSex = ObservableField("")
    val mBirthDay = ObservableField("")
    val mAvatar = ObservableField("")
    val mRole = ObservableField("")

    private val mAccount = SharedPrefs().getInstance()[USER_INFO_KEY, Account::class.java]

    init {
        mName.set(mAccount?.username)
        mEmail.set(mAccount?.email)
//        mSex.set(mAccount)
//        mBirthDay.set(mAccount)
        mAvatar.set(mAccount?.imageurl)
    }

    fun editProfile(){

    }

    fun changePassword(){

    }
}