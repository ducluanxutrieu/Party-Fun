package com.uit.party.ui.profile.change_password

import android.text.Editable
import android.text.TextWatcher
import android.view.View
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel
import androidx.navigation.findNavController
import com.uit.party.R
import com.uit.party.data.getToken
import com.uit.party.model.BaseResponse
import com.uit.party.util.UiUtil
import com.uit.party.util.getNetworkService
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class ChangePasswordViewModel : ViewModel() {
    val sendButtonEnabled = ObservableBoolean(false)

    var errorCurrentPassword = ObservableField("")
    var errorNewPassword = ObservableField("")
    var errorConfirmPassword = ObservableField("")
    val mTitleActionPassword = ObservableField(UiUtil.getString(R.string.change_password))
    val mHintCodeOrPassword = ObservableField(UiUtil.getString(R.string.action_current_password))

    private var currentPasswordValid = false
    private var newPasswordValid = false
    private var confirmPasswordValid = false

    private var currentPasswordText = ""
    private var newPasswordText = ""

    val mShowLoading = ObservableBoolean(false)
    private var mOrderCode = "CHANGE"

    fun init(orderCode: String) {
        mOrderCode = orderCode
        if (orderCode == "CHANGE"){
            mTitleActionPassword.set(UiUtil.getString(R.string.change_password))
            mHintCodeOrPassword.set(UiUtil.getString(R.string.action_current_password))
        }else{
            mTitleActionPassword.set(UiUtil.getString(R.string.reset_password))
            mHintCodeOrPassword.set(UiUtil.getString(R.string.code_from_your_email))
        }
    }

    private fun sendChangePassword(onComplete: (Boolean) -> Unit) {
        getNetworkService().changePassword(
            getToken(),
            currentPasswordText,
            newPasswordText
        )
            .enqueue(object : Callback<BaseResponse> {
                override fun onFailure(call: Call<BaseResponse>, t: Throwable) {
                    onComplete(false)
                    if (t.message != null) {
                        UiUtil.showToast(t.message!!)
                    }
                }

                override fun onResponse(
                    call: Call<BaseResponse>,
                    model: Response<BaseResponse>
                ) {
                    if (model.code() == 200) {
                        onComplete(true)
                        model.body()?.message?.let { UiUtil.showToast(it) }
                    } else {
                        onComplete(false)
                        val repos = model.body()
                        if (repos != null) {
                            UiUtil.showToast(repos.message!!)
                            if (repos.message.equals("Wrong Password")){
                                errorCurrentPassword.set(UiUtil.getString(R.string.wrong_password))
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

    private fun sendConfirmPassword(onComplete: (Boolean) -> Unit) {
        getNetworkService().verifyPassword(currentPasswordText, newPasswordText)
            .enqueue(object : Callback<BaseResponse> {
                override fun onFailure(call: Call<BaseResponse>, t: Throwable) {
                    onComplete(false)
                    if (t.message != null) {
                        UiUtil.showToast(t.message!!)
                    }
                }

                override fun onResponse(
                    call: Call<BaseResponse>,
                    model: Response<BaseResponse>
                ) {
                    if (model.code() == 200) {
                        onComplete(true)
                        model.body()?.message?.let { UiUtil.showToast(it) }
                    } else {
                        onComplete(false)
                        val repos = model.body()
                        if (repos != null) {
                            UiUtil.showToast(repos.message!!)
                        }
                    }
                }
            })
    }

    fun onSendClicked(view: View) {
        mShowLoading.set(true)
        if (mOrderCode == "CHANGE"){
            sendChangePassword {success ->
                mShowLoading.set(false)
                if (success){
                    view.findNavController().popBackStack()
                }
            }
        }else{
            sendConfirmPassword{ success ->
                mShowLoading.set(false)
                if (success){
                    view.findNavController().navigate(R.id.action_ResetPasswordFragment_back_LoginFragment)
                }
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
                errorCurrentPassword.set(UiUtil.getString(R.string.this_field_required))
                currentPasswordValid = false
                checkShowSendButton()
            }
            editable.contains(" ") -> {
                errorCurrentPassword.set(UiUtil.getString(R.string.this_field_cannot_contain_space))
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
                errorNewPassword.set(UiUtil.getString(R.string.this_field_required))
                newPasswordValid = false
                checkShowSendButton()
            }
            editable.contains(" ") -> {
                errorNewPassword.set(UiUtil.getString(R.string.this_field_cannot_contain_space))
                newPasswordValid = false
                checkShowSendButton()
            }
            editable.length < 6 -> {
                errorNewPassword.set(UiUtil.getString(R.string.password_too_short))
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
                errorConfirmPassword.set(UiUtil.getString(R.string.this_field_required))
                confirmPasswordValid = false
                checkShowSendButton()
            }
            newPasswordText != editable.toString() -> {
                errorConfirmPassword.set(UiUtil.getString(R.string.not_matched_with_password))
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