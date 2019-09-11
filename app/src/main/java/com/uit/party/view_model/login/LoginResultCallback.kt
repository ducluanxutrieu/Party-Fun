package com.uit.party.view_model.login

import com.uit.party.model.LoginModel


interface LoginResultCallback {
    fun onSuccess(success: String)
    fun onError(error: String)
    fun onRepos(loginModel: LoginModel)
    fun onRegister()
}
