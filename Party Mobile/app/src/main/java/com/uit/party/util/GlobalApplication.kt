package com.uit.party.util

import android.app.Application
import android.content.Context
import com.google.gson.Gson
import androidx.core.content.ContextCompat.getSystemService
import android.icu.lang.UCharacter.GraphemeClusterBreak.T
import androidx.core.content.ContextCompat.getSystemService
import android.icu.lang.UCharacter.GraphemeClusterBreak.T





class GlobalApplication : Application(){
    private val mGSon = Gson()
    override fun onCreate() {
        super.onCreate()
        appContext = applicationContext
    }

    companion object{
        var appContext: Context? = null
            private set
    }

    fun getGSon(): Gson {
        return mGSon
    }
}