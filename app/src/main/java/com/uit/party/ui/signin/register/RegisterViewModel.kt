package com.uit.party.ui.signin.register

import android.text.Editable
import android.text.TextWatcher
import android.widget.Toast
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel
import com.uit.party.R
import com.uit.party.model.ResponseMessage
import com.uit.party.util.GlobalApplication
import com.uit.party.util.StringUtil


class RegisterViewModel(private val registerCallback: RegisterCallback) : ViewModel() {
    var fullNameValid = false
    var usernameValid = false
    var emailValid = false
    var phoneNumberValid = false
    var passwordValid = false
    var confirmPasswordValid = false
    private val TAG = "RegisterTag"

    var btnRegisterEnabled: ObservableBoolean = ObservableBoolean()

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

    private val content = GlobalApplication.appContext

    var fullNameText: String = ""
    var usernameText: String = ""
    var emailText: String = ""
    var phoneNumberText: String = ""
    var passwordText: String = ""
    private lateinit var activity: RegisterFragment

    fun init(activity: RegisterFragment) {
        this.activity = activity
    }

    private fun checkShowButtonRegister() {
        if (fullNameValid && usernameValid && emailValid && phoneNumberValid && passwordValid && confirmPasswordValid) {
            btnRegisterEnabled.set(true)
        } else btnRegisterEnabled.set(false)
    }

    fun getFullNameTextChanged(): TextWatcher {
        return object : TextWatcher {
            override fun afterTextChanged(editable: Editable?) {
                checkFullNameValid(editable)
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }
        }
    }

    private fun checkFullNameValid(editable: Editable?) {
        when {
            editable.isNullOrEmpty() -> {
                errorFullName.set(StringUtil.getString(R.string.this_field_required))
                fullNameValid = false
                checkShowButtonRegister()
            }
            else -> {
                fullNameValid = true
                errorFullName.set("")
                fullNameText = editable.toString()
                checkShowButtonRegister()
            }
        }
    }

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
                errorUserName.set(StringUtil.getString(R.string.this_field_required))
                usernameValid = false
                checkShowButtonRegister()
            }
            editable.contains(" ") -> {
                errorUserName.set(StringUtil.getString(R.string.this_field_cannot_contain_space))
                usernameValid = false
                checkShowButtonRegister()
            }
            else -> {
                usernameValid = true
                errorUserName.set("")
                usernameText = editable.toString()
                checkShowButtonRegister()
            }
        }
    }

    fun getEmailTextChanged(): TextWatcher {
        return object : TextWatcher {
            override fun afterTextChanged(editable: Editable?) {
                checkEmailValid(editable)
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

        }
    }

    fun getPhoneNumberTextChanged(): TextWatcher {
        return object : TextWatcher {
            override fun afterTextChanged(editable: Editable?) {
                checkPhoneNumberValid(editable)
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

        }
    }

    private fun checkPhoneNumberValid(editable: Editable?) {
        when {
            editable.isNullOrEmpty() -> {
                errorPhoneNumber.set(StringUtil.getString(R.string.this_field_required))
                phoneNumberValid = false
                checkShowButtonRegister()
            }
            !android.util.Patterns.PHONE.matcher(editable).matches() -> {
                errorPhoneNumber.set(StringUtil.getString(R.string.phone_not_valid))
                phoneNumberValid = false
                checkShowButtonRegister()
            }
            else -> {
                phoneNumberValid = true
                errorPhoneNumber.set("")
                phoneNumberText = editable.toString()
                checkShowButtonRegister()
            }
        }
    }

    private fun checkEmailValid(editable: Editable?) {
        when {
            editable.isNullOrEmpty() -> {
                errorEmail.set(StringUtil.getString(R.string.this_field_required))
                emailValid = false
                checkShowButtonRegister()
            }
            !android.util.Patterns.EMAIL_ADDRESS.matcher(editable).matches() -> {
                errorEmail.set(StringUtil.getString(R.string.email_not_valid))
                emailValid = false
                checkShowButtonRegister()
            }
            else -> {
                emailValid = true
                errorEmail.set("")
                emailText = editable.toString()
                checkShowButtonRegister()
            }
        }
    }

    fun getPasswordTextChanged(): TextWatcher {
        return object : TextWatcher {
            override fun afterTextChanged(editable: Editable?) {
                checkPasswordValid(editable)
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

        }
    }

    private fun checkPasswordValid(editable: Editable?) {
        when {
            editable.isNullOrEmpty() -> {
                errorPassword.set(StringUtil.getString(R.string.this_field_required))
                passwordValid = false
                checkShowButtonRegister()
            }
            editable.contains(" ") -> {
                errorPassword.set(StringUtil.getString(R.string.this_field_cannot_contain_space))
                passwordValid = false
                checkShowButtonRegister()
            }
            editable.length < 6 -> {
                errorPassword.set(StringUtil.getString(R.string.password_too_short))
                passwordValid = false
                checkShowButtonRegister()
            }
            else -> {
                passwordValid = true
                errorPassword.set("")
                passwordText = editable.toString()
                checkShowButtonRegister()
            }
        }
    }

    fun getConfirmPasswordTextChanged(): TextWatcher {
        return object : TextWatcher {
            override fun afterTextChanged(editable: Editable?) {
                checkConfirmPasswordValid(editable)
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }
        }
    }

    private fun checkConfirmPasswordValid(editable: Editable?) {
        when {
            editable.isNullOrEmpty() -> {
                errorConfirmPassword.set(StringUtil.getString(R.string.this_field_required))
                confirmPasswordValid = false
                checkShowButtonRegister()
            }
            !passwordText.equals(editable.toString()) -> {
                errorConfirmPassword.set(StringUtil.getString(R.string.not_matched_with_password))
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

    fun onRegisterClicked() {
        register(
            fullNameText,
            usernameText,
            emailText,
            passwordText,
            activity
        ) { registerResponse ->
            when (registerResponse?.message) {
                "Create successed" -> {
                    Toast.makeText(content, "Register successful", Toast.LENGTH_LONG).show()
                    registerCallback.onBackLogin()
                }
                "Create failed" -> registerCallback.onFail("Register Failed - Please try again")
                "Username existed" -> registerCallback.onFail("Username existed - Please try another")
            }
        }
    }

    private fun register(
        fullName: String,
        username: String,
        email: String,
        password: String,
        activity: RegisterFragment,
        onComplete: (ResponseMessage?) -> Unit
    ) {

//        serviceRetrofit.register(fullName, username, email, password)
//                .enqueue(object : Callback<ResponseMessage> {
//                    override fun onFailure(call: Call<ResponseMessage>, t: Throwable) {
//
//                    }
//
//                    override fun onResponse(call: Call<ResponseMessage>, responseMessage: Response<ResponseMessage>) {
//                        val repo = responseMessage.body()
//                        onComplete(repo)
//                        Log.i(LoginFragment.TAG, repo.toString())
//                    }
//                })
    }


    fun onBackLogin() {
        registerCallback.onBackLogin()
    }

    fun onCardClicked() {

    }
}