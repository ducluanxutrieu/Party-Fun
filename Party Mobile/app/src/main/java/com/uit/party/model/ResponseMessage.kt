package com.uit.party.model

class ResponseMessage {
    var message: String? = null
    var success = false
    override fun toString(): String {
        return "ResponseMessage(message=$message, success=$success)"
    }
}