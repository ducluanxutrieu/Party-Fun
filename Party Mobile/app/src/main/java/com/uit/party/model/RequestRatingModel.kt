package com.uit.party.model

import com.google.gson.annotations.SerializedName

class RequestRatingModel(
    @SerializedName("_id")
    val _id: String? = null,

    @SerializedName("scorerate")
    val scorerate: Double? = 0.0,

    @SerializedName("content")
    val content: String? = null
)