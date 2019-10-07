package com.uit.party.model

import com.google.gson.annotations.SerializedName
import java.io.Serializable

class LoginModel(
    @SerializedName("username") var username: String,
    @SerializedName("password") var password: String
) : Serializable

class RegisterModel(
    @SerializedName("fullName") var fullName: String,
    @SerializedName("username")var username: String,
    @SerializedName("email")var email: String,
    @SerializedName("phoneNumber")var phoneNumber: String,
    @SerializedName("password")var password: String
) : Serializable

class AccountResponse: BaseResponse() {
    @SerializedName("account")
    val account: Account? = null
}

class Account {
    @SerializedName("_id")
    val id: String? = null
    @SerializedName("token")
    val token: String ?= null
    @SerializedName("fullName")
    val fullName: String? = null
    @SerializedName("username")
    val username: String? = null
    @SerializedName("email")
    val email: String? = null
    @SerializedName("role")
    val role: String? = null
    @SerializedName("activeStatus")
    val activeStatus: Boolean? = false
    @SerializedName("imageurl")
    val image: String? = null
    @SerializedName("phoneNumber")
    val phoneNumber: String? = null
    @SerializedName("updatedAt")
    val updatedAt: String? = null
    @SerializedName("userCart")
    val userCart: UserCart? = null
}

class UserCart {
    //make for future
}