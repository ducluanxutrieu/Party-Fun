package com.uit.party.ui.signin.login

import android.view.View
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableField
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.findNavController
import com.uit.party.R
import com.uit.party.data.CusResult
import com.uit.party.model.LoginModel
import com.uit.party.ui.signin.LoginError
import com.uit.party.ui.signin.LoginSuccess
import com.uit.party.ui.signin.LoginViewState
import com.uit.party.user.UserManager
import com.uit.party.util.UiUtil
import kotlinx.coroutines.launch
import javax.inject.Inject


class LoginViewModel @Inject constructor(private val userManager: UserManager) : ViewModel() {
    private val _loginState = MutableLiveData<LoginViewState>()
    val loginState: LiveData<LoginViewState>
        get() = _loginState

    val loginEnabled: ObservableBoolean = ObservableBoolean()

    var errorUsername: ObservableField<String> = ObservableField()
    var errorPassword: ObservableField<String> = ObservableField()

    private var usernameValid = false
    private var passwordValid = false

    private var usernameText = ""
    private var passwordText = ""

    val mShowLoading = ObservableBoolean(false)

    fun onLoginClicked() {
        mShowLoading.set(true)
        val loginModel = LoginModel(usernameText, passwordText)

        viewModelScope.launch {
            try {
                val result = userManager.loginUser(loginModel)
                if (result is CusResult.Success) {
                    _loginState.postValue(LoginSuccess)
                } else
                    _loginState.postValue(LoginError)
            } catch (ex: Exception) {
                ex.message?.let { UiUtil.showToast(it) }
            } finally {
                mShowLoading.set(false)
            }
        }
    }

    fun onRegisterClicked(view: View) {
        val action = LoginFragmentDirections.actionLoginFragmentToRegisterFragment(
            view.width / 2 + view.x.toInt(),
            view.height / 2 + view.y.toInt()
        )
        view.findNavController().navigate(action)
    }

    fun checkUsernameValid(text: CharSequence?) {
        when {
            text.isNullOrEmpty() -> {
                errorUsername.set(UiUtil.getString(R.string.this_field_required))
                usernameValid = false
                checkShowButtonLogin()
            }
            text.contains(" ") -> {
                errorUsername.set(UiUtil.getString(R.string.this_field_cannot_contain_space))
                usernameValid = false
                checkShowButtonLogin()
            }
            else -> {
                usernameValid = true
                errorUsername.set("")
                usernameText = text.toString()
                checkShowButtonLogin()
            }
        }
    }

    private fun checkShowButtonLogin() {
        if (usernameValid && passwordValid) {
            loginEnabled.set(true)
        } else loginEnabled.set(false)
    }

    fun checkPasswordValid(text: CharSequence?) {
        when {
            text.isNullOrEmpty() -> {
                errorPassword.set(UiUtil.getString(R.string.this_field_required))
                passwordValid = false
                checkShowButtonLogin()
            }
            text.contains(" ") -> {
                errorPassword.set(UiUtil.getString(R.string.this_field_cannot_contain_space))
                passwordValid = false
                checkShowButtonLogin()
            }
            text.length < 6 -> {
                errorPassword.set(UiUtil.getString(R.string.password_too_short))
                passwordValid = false
                checkShowButtonLogin()
            }
            else -> {
                passwordValid = true
                errorPassword.set("")
                passwordText = text.toString()
                checkShowButtonLogin()
            }
        }
    }

    fun onForgotPasswordClicked(view: View) {
        view.findNavController().navigate(R.id.action_LoginFragment_to_ResetPasswordFragment)
    }
}