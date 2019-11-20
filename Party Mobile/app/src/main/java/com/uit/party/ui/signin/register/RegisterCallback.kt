package com.uit.party.ui.signin.register

interface RegisterCallback {
    fun onBackLogin()
    fun onRegister()
    fun onFail(message: String)
}