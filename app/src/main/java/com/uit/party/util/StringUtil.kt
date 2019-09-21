package com.uit.party.util


object StringUtil {

    fun capitalize(s: String?): String {
        if (s == null || s.isEmpty()) {
            return ""
        }
        val first = s[0]
        return if (Character.isUpperCase(first)) {
            s
        } else {
            Character.toUpperCase(first) + s.substring(1)
        }
    }

    fun getString(stringId: Int): String {
        val context =  GlobalApplication.appContext
        return context?.getString(stringId) ?: ""
    }

}// prevent init Util class
