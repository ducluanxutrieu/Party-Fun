package com.uit.party.ui.signin.register

import android.view.View
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.findNavController
import com.uit.party.R
import com.uit.party.data.CusResult
import com.uit.party.model.RegisterModel
import com.uit.party.user.UserManager
import com.uit.party.util.UiUtil
import kotlinx.coroutines.launch
import javax.inject.Inject


class RegisterViewModel @Inject constructor (private val userManager: UserManager ) : ViewModel() {
    private var fullNameValid = false
    private var usernameValid = false
    private var emailValid = false
    private var phoneNumberValid = false
    private var passwordValid = false
    private var confirmPasswordValid = false

    var btnRegisterEnabled: ObservableBoolean = ObservableBoolean()
    val mShowLoading = ObservableBoolean(false)

    var errorFullName = ObservableField<String>()
    var errorUserName = ObservableField<String>()
    var errorEmail = ObservableField<String>()
    var errorPassword = ObservableField<String>()
    var errorConfirmPassword = ObservableField<String>()
    var errorPhoneNumber = ObservableField<String>()

    var fullName: ObservableField<String> = ObservableField()
    var username: ObservableField<String> = ObservableField()
    var email: ObservableField<String> = ObservableField()
    var phoneNumber: ObservableField<String> = ObservableField()
    var password: ObservableField<String> = ObservableField()
    var confirmPassword: ObservableField<String> = ObservableField()


    private var fullNameText: String = ""
    private var usernameText: String = ""
    private var emailText: String = ""
    private var phoneNumberText: String = ""
    private var passwordText: String = ""

    private fun checkShowButtonRegister() {
        if (fullNameValid && usernameValid && emailValid && phoneNumberValid && passwordValid && confirmPasswordValid) {
            btnRegisterEnabled.set(true)
        } else btnRegisterEnabled.set(false)
    }

    fun checkFullNameValid(text: CharSequence?) {
        when {
            text.isNullOrEmpty() -> {
                errorFullName.set(UiUtil.getString(R.string.this_field_required))
                fullNameValid = false
                checkShowButtonRegister()
            }
            text.trim().length < 6 -> {
                errorFullName.set(UiUtil.getString(R.string.full_name_too_short))
                fullNameValid = false
                checkShowButtonRegister()

            }
            else -> {
                fullNameValid = true
                errorFullName.set("")
                fullNameText = text.toString()
                checkShowButtonRegister()
            }
        }
    }

    fun checkUsernameValid(text: CharSequence?) {
        when {
            text.isNullOrEmpty() -> {
                errorUserName.set(UiUtil.getString(R.string.this_field_required))
                usernameValid = false
                checkShowButtonRegister()
            }
            text.contains(" ") -> {
                errorUserName.set(UiUtil.getString(R.string.this_field_cannot_contain_space))
                usernameValid = false
                checkShowButtonRegister()
            }
            text.trim().length < 6 -> {
                errorUserName.set(UiUtil.getString(R.string.user_name_too_short))
                usernameValid = false
                checkShowButtonRegister()
            }
            else -> {
                usernameValid = true
                errorUserName.set("")
                usernameText = text.toString()
                checkShowButtonRegister()
            }
        }
    }

    fun checkPhoneNumberValid(text: CharSequence?) {
        when {
            text.isNullOrEmpty() -> {
                errorPhoneNumber.set(UiUtil.getString(R.string.this_field_required))
                phoneNumberValid = false
                checkShowButtonRegister()
            }
            !android.util.Patterns.PHONE.matcher(text).matches() -> {
                errorPhoneNumber.set(UiUtil.getString(R.string.phone_not_valid))
                phoneNumberValid = false
                checkShowButtonRegister()
            }

            text.trim().length < 9 -> {
                errorPhoneNumber.set(UiUtil.getString(R.string.phone_number_too_short))
                phoneNumberValid = false
                checkShowButtonRegister()
            }

            else -> {
                phoneNumberValid = true
                errorPhoneNumber.set("")
                phoneNumberText = text.toString()
                checkShowButtonRegister()
            }
        }
    }

    fun checkEmailValid(text: CharSequence?) {
        when {
            text.isNullOrEmpty() -> {
                errorEmail.set(UiUtil.getString(R.string.this_field_required))
                emailValid = false
                checkShowButtonRegister()
            }
            !android.util.Patterns.EMAIL_ADDRESS.matcher(text).matches() -> {
                errorEmail.set(UiUtil.getString(R.string.email_not_valid))
                emailValid = false
                checkShowButtonRegister()
            }
            else -> {
                emailValid = true
                errorEmail.set("")
                emailText = text.toString()
                checkShowButtonRegister()
            }
        }
    }

    fun checkPasswordValid(text: CharSequence?) {
        when {
            text.isNullOrEmpty() -> {
                errorPassword.set(UiUtil.getString(R.string.this_field_required))
                passwordValid = false
                checkShowButtonRegister()
            }
            text.contains(" ") -> {
                errorPassword.set(UiUtil.getString(R.string.this_field_cannot_contain_space))
                passwordValid = false
                checkShowButtonRegister()
            }
            text.length < 6 -> {
                errorPassword.set(UiUtil.getString(R.string.password_too_short))
                passwordValid = false
                checkShowButtonRegister()
            }
            else -> {
                passwordValid = true
                errorPassword.set("")
                passwordText = text.toString()
                checkShowButtonRegister()
            }
        }
    }

    fun checkConfirmPasswordValid(text: CharSequence?) {
        when {
            text.isNullOrEmpty() -> {
                errorConfirmPassword.set(UiUtil.getString(R.string.this_field_required))
                confirmPasswordValid = false
                checkShowButtonRegister()
            }
            passwordText != text.toString() -> {
                errorConfirmPassword.set(UiUtil.getString(R.string.not_matched_with_password))
                confirmPasswordValid = false
                checkShowButtonRegister()
            }
            else -> {
                confirmPasswordValid = true
                errorConfirmPassword.set("")
                checkShowButtonRegister()
            }
        }
    }

    fun onRegisterClicked(view: View) {
        val model =
            RegisterModel(fullNameText, usernameText, emailText, phoneNumberText, passwordText)
        mShowLoading.set(true)
        viewModelScope.launch {
            try {
                val result = userManager.registerUser(model)
                if (result is CusResult.Success){
                    result.data.message?.let { UiUtil.showToast(it) }
                    view.findNavController().popBackStack()
                }
            }catch (ex: Exception){
                ex.message?.let { UiUtil.showToast(it) }
            }finally {
                mShowLoading.set(false)
            }
        }
    }

    fun onCardClicked() {
        //Nothing
    }
}