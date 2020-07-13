package com.uit.party.util

import java.text.SimpleDateFormat
import java.util.*

object TimeFormatUtil {
    private const val formatServer = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    private const val formatClient = "dd-MM-yyyy"
    private const val formatTimeClient12h = "dd/MM/yyyy HH:mm"
    private val sdfServer = SimpleDateFormat(formatServer, Locale.US)
    private val sdfClient = SimpleDateFormat(formatClient, Locale.US)
    private val sdfTimeClient12h = SimpleDateFormat(formatTimeClient12h, Locale.US)

    fun formatDateToServer(date: String?): String? {
        if (date != null) {
            val dateOrigin = sdfClient.parse(date)
            return sdfServer.format(dateOrigin!!)
        }
        return null
    }

    fun formatDateToClient(date: String?): String? {
        if (date != null) {
            val dateOrigin = sdfServer.parse(date)
            return sdfClient.format(dateOrigin!!)
        }
        return null
    }

    fun formatTimeToServer(calPicker : Calendar): String {
        val myFormat = "MM/dd/yyyy HH:mm"
        val sdf = SimpleDateFormat(myFormat, Locale.US)
        return sdf.format(calPicker.time)
    }

    fun formatTimeToClient(calPicker : Calendar): String {
        val sdf = SimpleDateFormat(formatTimeClient12h, Locale.US)
        return sdf.format(calPicker.time)
    }

    fun formatTime12hToClient(date : String?): String? {
        if (date != null) {
            val dateOrigin = sdfServer.parse(date)
            return sdfTimeClient12h.format(dateOrigin!!)
        }
        return null
    }
}