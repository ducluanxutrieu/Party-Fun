package com.uit.party.view_model.login

import android.content.SharedPreferences
import android.text.Editable
import android.text.TextWatcher
import android.util.Patterns
import android.view.View
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableInt
import androidx.lifecycle.ViewModel
import com.uit.party.ui.LoginActivity.Companion.SHARE_REFERENCE_MODE
import com.uit.party.ui.LoginActivity.Companion.SHARE_REFERENCE_NAME
import com.uit.party.model.LoginModel
import com.uit.party.model.UserLoginInfo
import com.uit.party.util.GlobalApplication

class LoginViewModel(private val loginResult: LoginResultCallback): ViewModel(){
        val user = UserLoginInfo()
    val loginEnabled: ObservableBoolean = ObservableBoolean()
    lateinit var loginModel: LoginModel

    private lateinit var shareReference: SharedPreferences

    val context = GlobalApplication.appContext

    var usernameValid = false
    var passwordValid = false

    var loading: ObservableInt = ObservableInt(View.GONE)

    fun onLoginClicked(){
        loading.set(View.VISIBLE)
        if (isEmailValid(user.username) && isPasswordValid(user.password)){
            loading.set(View.VISIBLE)
            login(user.username, user.password){success ->
                if (success){
                    loginResult.onRepos(loginModel)
                    loginResult.onSuccess("Login Successful")
                }else{
                    loginResult.onError("Login Error")
                }
                loading.set(View.GONE)
            }
        }
    }

    fun login(username: String, password: String, onComplete: (Boolean) -> Unit){
//        serviceRetrofit.login(username, password)
//                .enqueue(object : Callback<LoginModel> {
//                    override fun onFailure(call: Call<LoginModel>, t: Throwable) {
//                        onComplete(false)
//                    }
//
//                    override fun onResponse(call: Call<LoginModel>, model: Response<LoginModel>) {
//                        val repos = model.body()
//                        if (repos != null) {
//                            loginModel = repos
//                            onComplete(true)
//                        }else
//                        {
//                            onComplete(false)
//                        }
//                    }
//                })
    }



//    fun onForgotPasswordClicked(){
//
//    }

    fun onRegisterClicked(){
        loginResult.onRegister()
    }

    fun getUsernameTextChanged(): TextWatcher {
        return object: TextWatcher {
            override fun afterTextChanged(p0: Editable?) {
                user.username = p0.toString()
                if (p0 != null){
                    if (p0.toString().isNotEmpty()){
                        usernameValid = true
                        if (passwordValid) {
                            //_loginButton.value = true
                            loginEnabled.set(true)
                        }
                    }else{
                        usernameValid = false
                        loginEnabled.set(false)
                    }
                }
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {

            }

        }
    }

    fun getPasswordTextChanged(): TextWatcher {
        return object: TextWatcher {
            override fun afterTextChanged(p0: Editable?) {
                user.password = p0.toString()
                if (p0 != null) {
                    if (usernameValid && (p0.toString().trim().length > 5)){
                        //_loginButton.value = true
                        loginEnabled.set(true)
                        passwordValid = true
                    }else{
                        //_loginButton.value = false
                        loginEnabled.set(false)
                    }
                }else{
                    //_loginButton.value = false
                    loginEnabled.set(false)
                    passwordValid = false
                }
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {

            }

        }
    }

    // A placeholder username validation check
    private fun isEmailValid(username: String): Boolean {
        return if (username.contains('@')) {
            Patterns.EMAIL_ADDRESS.matcher(username).matches()
        } else {
            username.isNotBlank()
        }
    }


    fun saveToMemory(model: LoginModel) {
        if (context != null) {
            shareReference = context.getSharedPreferences(SHARE_REFERENCE_NAME, SHARE_REFERENCE_MODE)
            val editor = shareReference.edit()
            editor.putString("username", user.username)
            editor.putString("password", user.password)
            editor.putString("tokenAccess", model.token)
            editor.putInt("userID", model.id)
            editor.apply()
        }
    }
    // A placeholder password validation check
    private fun isPasswordValid(password: String): Boolean {
        return password.length > 5
    }


}