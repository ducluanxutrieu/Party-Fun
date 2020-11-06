package com.uit.party.model

import com.google.gson.annotations.SerializedName
import java.io.Serializable

class BillResponseModel : BaseResponse() {
    @SerializedName("bill")
    val billModel: BillModel? = null
}


data class BillModel(
    @SerializedName("_id")
    val _id: String? = null,

    @SerializedName("lishDishs")
    val listDishes: ArrayList<ListDishes>? = null,

    @SerializedName("dateParty")
    val dateParty: String? = null,

    @SerializedName("numbertable")
    val numberTable: Int? = 1,

    @SerializedName("username")
    val username: String? = null,

    @SerializedName("createAt")
    val createAt: String? = null,

    @SerializedName("paymentstatus")
    val paymentStatus: Boolean? = false,

    @SerializedName("totalMoney")
    val totalMoney: Int? = 0,

    @SerializedName("userpayment")
    val userPayment: String? = null,

    @SerializedName("paymentAt")
    val paymentAt: String? = null
): Serializable