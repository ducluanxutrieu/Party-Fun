package com.uit.party.data

/**
 * A generic class that holds a value with its loading status.
 * @param <T>
 */
sealed class CusResult<out T : Any> {

    data class Success<out T : Any>(val data: T) : CusResult<T>()
    data class Error(val exception: Exception) : CusResult<Nothing>()

    override fun toString(): String {
        return when (this) {
            is Success<*> -> "Success[data=$data]"
            is Error -> "Error[exception=$exception]"
        }
    }
}