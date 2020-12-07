package com.uit.party.ui.signin.reset_password

import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableField
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.uit.party.R
import com.uit.party.data.CusResult
import com.uit.party.user.UserManager
import com.uit.party.util.UiUtil
import kotlinx.coroutines.launch
import javax.inject.Inject

class ResetPasswordViewModel @Inject constructor(private val userManager: UserManager) :ViewModel(){
    var errorUsername: ObservableField<String> = ObservableField()
    private var usernameText = ""
    val mShowLoading = ObservableBoolean(false)
    val mNextButtonEnabled: ObservableBoolean = ObservableBoolean()

    private val _resetState = MutableLiveData<Boolean>()
    val resetPassState: LiveData<Boolean>
        get() = _resetState


    fun checkUsernameValid(text: CharSequence?) {
        when {
            text.isNullOrEmpty() -> {
                errorUsername.set(UiUtil.getString(R.string.this_field_required))
                mNextButtonEnabled.set(false)
            }
            text.contains(" ") -> {
                errorUsername.set(UiUtil.getString(R.string.this_field_cannot_contain_space))
                mNextButtonEnabled.set(false)
            }
            else -> {
                errorUsername.set("")
                usernameText = text.toString()
                mNextButtonEnabled.set(true)
            }
        }
    }

    fun onSendClicked(){
        mShowLoading.set(true)

        viewModelScope.launch {
            try {
                val result = userManager.resetPassword(usernameText)
                if (result is CusResult.Success){
                    UiUtil.showToast(result.data.message)
                    _resetState.postValue(true)
                }
            }catch (ex: Exception){
                ex.message?.let { UiUtil.showToast(it) }
            }finally {
                mShowLoading.set(false)
            }
        }
    }
}