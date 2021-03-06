package com.uit.party.ui.signin.login

import android.content.Intent
import android.text.Editable
import android.text.TextWatcher
import android.view.View
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel
import androidx.navigation.findNavController
import com.uit.party.R
import com.uit.party.model.AccountResponse
import com.uit.party.model.LoginModel
import com.uit.party.ui.main.MainActivity
import com.uit.party.ui.signin.SignInActivity
import com.uit.party.util.Constants
import com.uit.party.util.Constants.Companion.USER_INFO_KEY
import com.uit.party.util.SharedPrefs
import com.uit.party.util.UiUtil
import com.uit.party.util.getNetworkService
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response


class LoginViewModel : ViewModel() {
    val loginEnabled: ObservableBoolean = ObservableBoolean()

    var errorUsername: ObservableField<String> = ObservableField()
    var errorPassword: ObservableField<String> = ObservableField()

    private var usernameValid = false
    private var passwordValid = false

    private var usernameText = ""
    private var passwordText = ""

    val mShowLoading = ObservableBoolean(false)

    fun onLoginClicked(view: View) {
        mShowLoading.set(true)
        val loginModel = LoginModel(usernameText, passwordText)
        login(loginModel) { success ->
            mShowLoading.set(false)
            if (success != null) {
                when (success) {
                    "Success" -> {
                        UiUtil.showToast(UiUtil.getString(R.string.login_successful))
                        startMainActivity(view)

                    }
                    else -> UiUtil.showToast(success)
                }
            } else {
                UiUtil.showToast(UiUtil.getString(R.string.login_error))
            }
        }
    }

    private fun startMainActivity(view: View) {
        val context = view.context as SignInActivity
        val intent = Intent(context, MainActivity::class.java)
        context.startActivity(intent)
        context.finish()
    }

    private fun login(loginModel: LoginModel, onComplete: (String?) -> Unit) {
        getNetworkService().login(loginModel)
            .enqueue(object : Callback<AccountResponse> {
                override fun onFailure(call: Call<AccountResponse>, t: Throwable) {
                    onComplete(t.message)
                }

                override fun onResponse(
                    call: Call<AccountResponse>,
                    model: Response<AccountResponse>
                ) {
                    val repos = model.body()
                    if (repos != null && model.isSuccessful) {
                        saveToMemory(repos)
                        onComplete("Success")
                    } else {
                        try {
                            val jObjError = JSONObject(model.errorBody()!!.string())
                            onComplete(jObjError.getString("message"))
                        } catch (e: Exception) {
                            onComplete(e.message)
                        }
                    }
                }
            })
    }

    fun onRegisterClicked(view: View) {
        val action = LoginFragmentDirections.actionLoginFragmentToRegisterFragment(
            view.width / 2 + view.x.toInt(),
            view.height / 2 + view.y.toInt()
        )
        view.findNavController().navigate(action)
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
                errorUsername.set(UiUtil.getString(R.string.this_field_required))
                usernameValid = false
                checkShowButtonLogin()
            }
            editable.contains(" ") -> {
                errorUsername.set(UiUtil.getString(R.string.this_field_cannot_contain_space))
                usernameValid = false
                checkShowButtonLogin()
            }
            else -> {
                usernameValid = true
                errorUsername.set("")
                usernameText = editable.toString()
                checkShowButtonLogin()
            }
        }
    }

    private fun checkShowButtonLogin() {
        if (usernameValid && passwordValid) {
            loginEnabled.set(true)
        } else loginEnabled.set(false)
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
                errorPassword.set(UiUtil.getString(R.string.this_field_required))
                passwordValid = false
                checkShowButtonLogin()
            }
            editable.contains(" ") -> {
                errorPassword.set(UiUtil.getString(R.string.this_field_cannot_contain_space))
                passwordValid = false
                checkShowButtonLogin()
            }
            editable.length < 6 -> {
                errorPassword.set(UiUtil.getString(R.string.password_too_short))
                passwordValid = false
                checkShowButtonLogin()
            }
            else -> {
                passwordValid = true
                errorPassword.set("")
                passwordText = editable.toString()
                checkShowButtonLogin()
            }
        }
    }

    fun onForgotPasswordClicked(view: View) {
        view.findNavController().navigate(R.id.action_LoginFragment_to_ResetPasswordFragment)
    }

    private fun saveToMemory(model: AccountResponse) {
        SharedPrefs().getInstance().put(USER_INFO_KEY, model.account)
        SharedPrefs().getInstance().put(Constants.TOKEN_ACCESS_KEY, model.account?.token)
    }
}