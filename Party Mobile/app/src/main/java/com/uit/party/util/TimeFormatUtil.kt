package com.uit.party.util

import java.text.SimpleDateFormat
import java.util.*

object TimeFormatUtil {
    private const val formatServer = "MM/dd/yyyy"
    private const val formatClient = "dd-MM-yyyy"
    private val sdfServer = SimpleDateFormat(formatServer, Locale.US)
    private val sdfClient = SimpleDateFormat(formatClient, Locale.US)

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
}