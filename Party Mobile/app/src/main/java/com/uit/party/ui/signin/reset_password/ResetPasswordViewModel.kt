package com.uit.party.ui.signin.reset_password

import android.text.Editable
import android.text.TextWatcher
import android.view.View
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel
import androidx.navigation.findNavController
import com.uit.party.R
import com.uit.party.model.BaseResponse
import com.uit.party.util.StringUtil
import com.uit.party.util.ToastUtil
import com.uit.party.util.getNetworkService
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class ResetPasswordViewModel :ViewModel(){
    var errorUsername: ObservableField<String> = ObservableField()
    private var usernameText = ""
    val mShowLoading = ObservableBoolean(false)
    val mNextButtonEnabled: ObservableBoolean = ObservableBoolean()


    fun getUsernameTextChanged(): TextWatcher {
        return object : TextWatcher {
            override fun afterTextChanged(editable: Editable?) {
                checkUsernameValid(editable)
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

        }
    }

    fun checkUsernameValid(editable: Editable?) {
        when {
            editable.isNullOrEmpty() -> {
                errorUsername.set(StringUtil.getString(R.string.this_field_required))
                mNextButtonEnabled.set(false)
            }
            editable.contains(" ") -> {
                errorUsername.set(StringUtil.getString(R.string.this_field_cannot_contain_space))
                mNextButtonEnabled.set(false)
            }
            else -> {
                errorUsername.set("")
                usernameText = editable.toString()
                mNextButtonEnabled.set(true)
            }
        }
    }

    fun onSendClicked(view: View){
        mShowLoading.set(true)
        resetPassword(usernameText){
            mShowLoading.set(false)
            if (it) {
                val action = ResetPasswordFragmentDirections.actionResetPasswordFragmentToChangePasswordFragment("RESET")
                view.findNavController().navigate(action)
            }
        }
    }

    private fun resetPassword(s: String, onComplete: (Boolean) -> Unit) {
        getNetworkService().resetPassword(s)
            .enqueue(object : Callback<BaseResponse> {
                override fun onFailure(call: Call<BaseResponse>, t: Throwable) {
                    t.message?.let { ToastUtil.showToast(it) }
                    onComplete(false)
                }

                override fun onResponse(
                    call: Call<BaseResponse>,
                    response: Response<BaseResponse>
                ) {
                    if (response.code() == 200){
                        response.body()?.message?.let { ToastUtil.showToast(it) }
                        onComplete(true)
                    }else{
                        onComplete(false)
                    }
                }
            })
    }
}