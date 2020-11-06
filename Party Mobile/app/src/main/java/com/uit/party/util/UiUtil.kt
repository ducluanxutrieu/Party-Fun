package com.uit.party.util

import android.text.Editable
import android.text.TextWatcher
import android.widget.Toast
import androidx.appcompat.widget.AppCompatEditText
import java.text.NumberFormat
import java.util.*

object UiUtil {
    fun showToast(toast: String){
        val context =  GlobalApplication.appContext
        Toast.makeText(context, toast, Toast.LENGTH_SHORT).show()
    }

    fun getString(stringId: Int): String {
        val context =  GlobalApplication.appContext
        return context?.getString(stringId) ?: ""
    }

    fun String?.toVNCurrency(): String{
        val formatter = NumberFormat.getNumberInstance(Locale("vi"))
        return formatter.format(this?.toDouble()) + " ₫"
    }

    fun AppCompatEditText.afterTextChanged(afterTextChanged: (String) -> Unit) {
        this.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {
            }

            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {
            }

            override fun afterTextChanged(editable: Editable?) {
                afterTextChanged.invoke(editable.toString())
            }
        })
    }

    fun String?.getNumber(): Int {
        return when {
            isNullOrEmpty() -> {
                1
            }
            toInt() < 1 -> {
                1
            }
            else -> {
                toInt()
            }
        }
    }
}