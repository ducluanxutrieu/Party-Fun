package com.uit.party.data

import com.uit.party.util.Constants
import com.uit.party.util.SharedPrefs


fun getToken(): String {
    val sharedPrefs: SharedPrefs = SharedPrefs().getInstance()
    val token = sharedPrefs[Constants.TOKEN_ACCESS_KEY, String::class.java]
    return token ?: ""
}