package com.uit.party.ui.signin

import android.view.View

interface SignInCallback {
    fun onRegister(cX: Float, cY: Float, sharedElement: View)
}