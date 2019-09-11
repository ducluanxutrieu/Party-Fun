package com.uit.party.view_model.register

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider

class RegisterViewModelFactory (private val registerCallback: RegisterCallback): ViewModelProvider.Factory{
    @Suppress ("UNCHECKED_CAST")
    override fun <T : ViewModel?> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(RegisterViewModel::class.java)){
            return RegisterViewModel(registerCallback) as T
        }
        throw IllegalAccessException("Unknown ViewModel class")
    }
}