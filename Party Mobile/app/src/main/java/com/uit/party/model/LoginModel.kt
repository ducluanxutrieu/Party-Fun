package com.uit.party.model

import com.google.gson.annotations.SerializedName
import java.io.Serializable

class LoginModel(
    @SerializedName("username") var username: String,
    @SerializedName("password") var password: String
) : Serializable

class RegisterModel(
    @SerializedName("fullName") var fullName: String,
    @SerializedName("username") var username: String,
    @SerializedName("email") var email: String,
    @SerializedName("phoneNumber") var phoneNumber: String,
    @SerializedName("password") var password: String
) : Serializable

class AccountResponse(
    @SerializedName("account") val account: Account? = null
):BaseResponse()

class Account {
    @SerializedName("_id")
    val _id: String? = null
    @SerializedName("email")
    val email: String? = null
    @SerializedName("fullName")
    val fullName: String? = null
    @SerializedName("phoneNumber")
    val phoneNumber: String? = null
    @SerializedName("username")
    val username: String? = null
    @SerializedName("birthday")
    val birthday: String? = null
    @SerializedName("sex")
    val sex: String? = null
    @SerializedName("token")
    val token: String? = null
    @SerializedName("role")
    val role: String? = null
    @SerializedName("imageurl")
    val imageurl: String? = null
    @SerializedName("date")
    val date: String? = null
}

class UserCart {
    //make for future
}