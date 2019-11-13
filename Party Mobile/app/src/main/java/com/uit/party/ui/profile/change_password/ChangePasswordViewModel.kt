package com.uit.party.ui.profile.change_password

import android.text.Editable
import android.text.TextWatcher
import android.view.View
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableField
import androidx.databinding.ObservableInt
import androidx.lifecycle.ViewModel
import com.uit.party.R
import com.uit.party.model.BaseResponse
import com.uit.party.ui.main.MainActivity
import com.uit.party.ui.main.MainActivity.Companion.TOKEN_ACCESS
import com.uit.party.util.StringUtil
import com.uit.party.util.ToastUtil
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class ChangePasswordViewModel(private val mActivity: MainActivity) : ViewModel() {
    val sendButtonEnabled = ObservableBoolean(false)

    var errorCurrentPassword = ObservableField("")
    var errorNewPassword = ObservableField("")
    var errorConfirmPassword = ObservableField("")

    private var currentPasswordValid = false
    private var newPasswordValid = false
    private var confirmPasswordValid = false

    private var currentPasswordText = ""
    private var newPasswordText = ""

    var showLoading = ObservableInt(View.GONE)

    private fun sendChangePassword(onComplete: (Boolean) -> Unit) {
        MainActivity.serviceRetrofit.changePassword(
            TOKEN_ACCESS,
            currentPasswordText,
            newPasswordText
        )
            .enqueue(object : Callback<BaseResponse> {
                override fun onFailure(call: Call<BaseResponse>, t: Throwable) {
                    onComplete(false)
                    if (t.message != null) {
                        ToastUtil().showToast(t.message!!)
                    }
                }

                override fun onResponse(
                    call: Call<BaseResponse>,
                    model: Response<BaseResponse>
                ) {
                    if (model.code() == 200) {
                        onComplete(true)
                    } else {
                        onComplete(false)
                        val repos = model.body()
                        if (repos != null) {
                            ToastUtil().showToast(repos.message!!)
                            if (repos.message.equals("Wrong Password")){
                                errorCurrentPassword.set(StringUtil.getString(R.string.wrong_password))
                            }
                        }
                    }

//                     else {
//                        try {
//                            val jObjError = JSONObject(model.errorBody()!!.string())
//                            onComplete(jObjError.getString("message"))
//                        } catch (e: Exception) {
//                            onComplete(e.message)
//                        }
//                    }
                }
            })
    }

    fun onSendClicked() {
        sendChangePassword {success ->
            if (success){
                mActivity.onBackPressed()
            }
        }
    }

    fun getCurrentPasswordTextChanged(): TextWatcher {
        return object : TextWatcher {
            override fun afterTextChanged(editable: Editable?) {
                checkCurrentPasswordValid(editable)
            }

            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {
//                TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
            }

            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {
//                TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
            }
        }
    }

    fun checkCurrentPasswordValid(editable: Editable?) {
        when {
            editable.isNullOrEmpty() -> {
                errorCurrentPassword.set(StringUtil.getString(R.string.this_field_required))
                currentPasswordValid = false
                checkShowSendButton()
            }
            editable.contains(" ") -> {
                errorCurrentPassword.set(StringUtil.getString(R.string.this_field_cannot_contain_space))
                currentPasswordValid = false
                checkShowSendButton()
            }
            else -> {
                currentPasswordValid = true
                errorCurrentPassword.set("")
                currentPasswordText = editable.toString()
                checkShowSendButton()
            }
        }
    }

    private fun checkShowSendButton() {
        if (currentPasswordValid && newPasswordValid) {
            sendButtonEnabled.set(true)
        } else sendButtonEnabled.set(false)
    }

    fun getNewPasswordTextChanged(): TextWatcher {
        return object : TextWatcher {
            override fun afterTextChanged(editable: Editable?) {
                checkNewPasswordValid(editable)
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

        }
    }

    private fun checkNewPasswordValid(editable: Editable?) {
        when {
            editable.isNullOrEmpty() -> {
                errorNewPassword.set(StringUtil.getString(R.string.this_field_required))
                newPasswordValid = false
                checkShowSendButton()
            }
            editable.contains(" ") -> {
                errorNewPassword.set(StringUtil.getString(R.string.this_field_cannot_contain_space))
                newPasswordValid = false
                checkShowSendButton()
            }
            editable.length < 6 -> {
                errorNewPassword.set(StringUtil.getString(R.string.password_too_short))
                newPasswordValid = false
                checkShowSendButton()
            }
            else -> {
                newPasswordValid = true
                errorNewPassword.set("")
                newPasswordText = editable.toString()
                checkShowSendButton()
            }
        }
    }

    fun getConfirmPasswordTextChanged(): TextWatcher {
        return object : TextWatcher {
            override fun afterTextChanged(editable: Editable?) {
                checkConfirmPasswordValid(editable)
            }

            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {
//                TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
            }

            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {
//                TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
            }

        }
    }

    private fun checkConfirmPasswordValid(editable: Editable?) {
        when {
            editable.isNullOrEmpty() -> {
                errorConfirmPassword.set(StringUtil.getString(R.string.this_field_required))
                confirmPasswordValid = false
                checkShowSendButton()
            }
            newPasswordText != editable.toString() -> {
                errorConfirmPassword.set(StringUtil.getString(R.string.not_matched_with_password))
                confirmPasswordValid = false
                checkShowSendButton()
            }
            else -> {
                confirmPasswordValid = true
                errorConfirmPassword.set("")
                checkShowSendButton()
            }
        }
    }

}