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
    var _id: String? = null
    @SerializedName("email")
    var email: String? = null
    @SerializedName("fullName")
    var fullName: String? = null
    @SerializedName("phoneNumber")
    var phoneNumber: String? = null
    @SerializedName("username")
    var username: String? = null
    @SerializedName("birthday")
    var birthday: String? = null
    @SerializedName("sex")
    var sex: String? = null
    @SerializedName("token")
    var token: String? = null
    @SerializedName("role")
    var role: String? = null
    @SerializedName("imageurl")
    var imageurl: String? = null
    @SerializedName("createAt")
    val createAt: String? = null
    @SerializedName("userCart")
    var userCart: ArrayList<UserCart>? = null
}

class UserCart {
    //make for future
}