package com.uit.party.ui.signin.login

import android.content.SharedPreferences
import android.text.Editable
import android.text.TextWatcher
import android.view.View
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableField
import androidx.databinding.ObservableInt
import androidx.lifecycle.ViewModel
import com.uit.party.R
import com.uit.party.model.LoginModel
import com.uit.party.model.UserLoginInfo
import com.uit.party.ui.MainActivity.Companion.SHARE_REFERENCE_MODE
import com.uit.party.ui.MainActivity.Companion.SHARE_REFERENCE_NAME
import com.uit.party.util.GlobalApplication
import com.uit.party.util.StringUtil

class LoginViewModel(private val loginResult : LoginCallback) : ViewModel(){
    private val user = UserLoginInfo()
    val loginEnabled: ObservableBoolean = ObservableBoolean()
    lateinit var loginModel: LoginModel

    private lateinit var shareReference: SharedPreferences

    val context = GlobalApplication.appContext!!

    var errorUsername: ObservableField<String> = ObservableField()
    var errorPassword: ObservableField<String> = ObservableField()

    private var usernameValid = false
    private var passwordValid = false

    private var usernameText = ""
    private var passwordText = ""

    var showLoading: ObservableInt = ObservableInt(View.GONE)

    fun onLoginClicked() {
        showLoading.set(View.VISIBLE)
        login(user.username, user.password) { success ->
            showLoading.set(View.GONE)
            if (success != null) {
                when(success) {
                    "Success" -> {
                        loginResult.onRepos(loginModel)
                        loginResult.onSuccess("Login Successful")
                    }
                    "User not found" -> {
                        loginResult.onError(success)
                    }
                    else -> loginResult.onError("Login Error")
                }
            } else {
                loginResult.onError("Login Error")
            }
        }
    }

    private fun login(username: String, password: String, onComplete: (String?) -> Unit) {
//        serviceRetrofit.login(username, password)
//            .enqueue(object : Callback<LoginModel> {
//                override fun onFailure(call: Call<LoginModel>, t: Throwable) {
//                    onComplete(t.message)
//                }
//
//                override fun onResponse(call: Call<LoginModel>, model: Response<LoginModel>) {
//                    val repos = model.body()
//                    if (repos != null) {
//                        try {
//                            loginModel = repos
//                            onComplete("Success")
//                        }catch (e: java.lang.Exception){
//                            onComplete(e.message)
//                        }
//
//                    } else {
//                        try {
//                            val jObjError = JSONObject(model.errorBody()!!.string())
//                            onComplete(jObjError.getString("message"))
//                        } catch (e: Exception) {
//                            onComplete(e.message)
//                        }
//                    }
//                }
//            })
    }

    fun onRegisterClicked() {
        loginResult.onRegister()
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
                errorUsername.set(StringUtil.getString(R.string.this_field_required))
                usernameValid = false
                checkShowButtonLogin()
            }
            editable.contains(" ") -> {
                errorUsername.set(StringUtil.getString(R.string.this_field_cannot_contain_space))
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
                errorPassword.set(StringUtil.getString(R.string.this_field_required))
                passwordValid = false
                checkShowButtonLogin()
            }
            editable.contains(" ") -> {
                errorPassword.set(StringUtil.getString(R.string.this_field_cannot_contain_space))
                passwordValid = false
                checkShowButtonLogin()
            }
            editable.length < 6 -> {
                errorPassword.set(StringUtil.getString(R.string.password_too_short))
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

    fun saveToMemory(model: LoginModel) {
        shareReference = context.getSharedPreferences(SHARE_REFERENCE_NAME, SHARE_REFERENCE_MODE)
        val editor = shareReference.edit()
        editor.putString("username", user.username)
        editor.putString("password", user.password)
        editor.putString("tokenAccess", model.token)
        editor.putString("avatar",model.avatar)
        editor.putString("fullname",model.fullname)
        editor.putInt("userID", model.id)
        editor.apply()
    }
}