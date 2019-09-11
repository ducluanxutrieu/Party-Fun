package com.uit.party.view_model.register

interface RegisterCallback {
    fun onBackLogin()
    fun onRegister()
    fun onFail(message: String)
}