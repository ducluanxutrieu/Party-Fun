package com.uit.party.view_model.login

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider

class LoginViewModelFactory (private val loginResultCallback: LoginResultCallback): ViewModelProvider.Factory{
    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel?> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(LoginViewModel::class.java)){
            return LoginViewModel(loginResultCallback) as T
        }
        throw IllegalAccessException("Unknown ViewModel class")
    }
}