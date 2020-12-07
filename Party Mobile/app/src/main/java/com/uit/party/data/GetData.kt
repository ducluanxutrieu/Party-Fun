package com.uit.party.data

import com.uit.party.util.Constants
import com.uit.party.util.GlobalApplication
import com.uit.party.util.SharedPrefs


fun getToken(): String {

    val token = SharedPrefs(GlobalApplication.appContext!!).getData(Constants.TOKEN_ACCESS_KEY, String::class.java)
    return token ?: ""
}