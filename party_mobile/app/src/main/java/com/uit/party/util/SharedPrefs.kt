package com.uit.party.util

import android.content.Context.MODE_PRIVATE
import android.content.SharedPreferences
import com.google.gson.Gson


@Suppress("UNCHECKED_CAST")
class SharedPrefs {
    private val PREFS_NAME = "share_prefs"
    private var mInstance: SharedPrefs? = null
    private var mSharedPreferences: SharedPreferences

    init {
        mSharedPreferences = GlobalApplication.appContext!!.getSharedPreferences(PREFS_NAME, MODE_PRIVATE)
    }

    fun getInstance(): SharedPrefs {
        if (mInstance == null) {
            mInstance = SharedPrefs()
        }
        return mInstance!!
    }

    operator fun <T> get(key: String, anonymousClass: Class<T>): T? {
        return when (anonymousClass) {
            String::class.java -> mSharedPreferences.getString(key, "") as T
            Boolean::class.java -> java.lang.Boolean.valueOf(mSharedPreferences.getBoolean(key, false)) as T
            Float::class.java -> java.lang.Float.valueOf(mSharedPreferences.getFloat(key, 0f)) as T
            Int::class.java -> Integer.valueOf(mSharedPreferences.getInt(key, 0)) as T
            Long::class.java -> java.lang.Long.valueOf(mSharedPreferences.getLong(key, 0)) as T
            else -> Gson().fromJson(mSharedPreferences.getString(key, ""), anonymousClass)
        }
    }

    fun <T> put(key: String, data: T) {
        val editor = mSharedPreferences.edit()
        when (data) {
            is String -> editor.putString(key, data as String)
            is Boolean -> editor.putBoolean(key, data as Boolean)
            is Float -> editor.putFloat(key, data as Float)
            is Int -> editor.putInt(key, data as Int)
            is Long -> editor.putLong(key, data as Long)
            else -> {
            editor.putString(key, Gson().toJson(data))
        }
        }
        editor.apply()
    }

    fun clear() {
        mSharedPreferences.edit().clear().apply()
    }
}
