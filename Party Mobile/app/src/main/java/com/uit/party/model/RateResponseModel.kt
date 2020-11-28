package com.uit.party.model

import androidx.room.*
import com.google.gson.annotations.SerializedName


class RateResponseModel : BaseResponse() {
    @SerializedName("data")
    val itemDishRateModel: ItemDishRateModelResponse? = null
}

@Entity
data class DishRateRemoteKeys(
    @PrimaryKey
    val commentID: String = "",
    val prevKey: Int?,
    val nextKey: Int?
)


data class ItemDishRateModelResponse(
    @SerializedName("dishId") var dishId: String = "",
    @SerializedName("count_rate") val count_rate: Int,
    @SerializedName("avg_rate") val avg_rate: Double,
    @SerializedName("total_page") val total_page: Int,
    @SerializedName("start") val start: Int,
    @SerializedName("end") val end: Int,
    @SerializedName("list_rate")
    val listRatings: List<RateModel>
)