package com.uit.party.ui.signin.login

import com.uit.party.model.LoginModel

interface LoginCallback {
    fun onSuccess(success : String)
    fun onRepos(loginModel: LoginModel)
    fun onError(error : String)
    fun onRegister()
}