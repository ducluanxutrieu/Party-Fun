package com.uit.party.util

import com.uit.party.BuildConfig

data class Change<out T>(
        val oldData: T,
        val newData: T
)

fun <T> createCombinedPayload(payloads: List<Change<T>>): Change<T> {
    if (BuildConfig.DEBUG && payloads.isEmpty()) {
        error("Assertion failed")
    }
    val firstChange = payloads.first()
    val lastChange = payloads.last()

    return Change(firstChange.oldData, lastChange.newData)
}
