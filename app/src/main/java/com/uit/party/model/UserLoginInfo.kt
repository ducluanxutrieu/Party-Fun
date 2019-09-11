package com.uit.party.model

class UserLoginInfo{
    lateinit var username: String
    lateinit var password: String

    override fun toString(): String {
        return "UserLoginInfo(email='$username', password='$password')"
    }
}