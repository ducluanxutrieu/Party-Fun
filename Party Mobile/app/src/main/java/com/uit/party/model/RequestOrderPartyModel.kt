package com.uit.party.model

import com.google.gson.annotations.SerializedName

class RequestOrderPartyModel (
    @SerializedName("dateParty")
    val dateParty: String,

    @SerializedName("numbertable")
    val numbertable: String,

    @SerializedName("lishDishs")
    val lishDishs: ArrayList<ListDishes>
)

class ListDishes(
    @SerializedName("numberDish")
    val numberDish: String,

    @SerializedName("_id")
    val _id: String
)