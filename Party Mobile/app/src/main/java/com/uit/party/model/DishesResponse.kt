package com.uit.party.model

import com.google.gson.annotations.SerializedName

class DishesResponse : BaseResponse(){
    @SerializedName("lishDishs")
    val lishDishs: ArrayList<DishModel>? = null
}