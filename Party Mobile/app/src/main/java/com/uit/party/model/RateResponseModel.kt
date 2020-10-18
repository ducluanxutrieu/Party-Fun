package com.uit.party.model

import androidx.room.*
import com.google.gson.annotations.SerializedName


class RateResponseModel : BaseResponse() {
    @SerializedName("data")
    val itemDishRateModel: ItemDishRateModelResponse? = null
}

data class ItemDishRateWithListRates(
    @Embedded
    @SerializedName("data")
    val itemDishRateModel: ItemDishRateModel,
    @Relation(
        parentColumn = "dishId",
        entityColumn = "id_dish"
    )
    @SerializedName("list_rate")
    val listRatings: List<RateModel>
)

@Entity
data class ItemDishRateModel(
    @PrimaryKey
    @SerializedName("dishId") var dishId: String = "",
    @SerializedName("count_rate") val count_rate: Int,
    @SerializedName("avg_rate") val avg_rate: Double,
    @SerializedName("total_page") val total_page: Int,
    @SerializedName("start") val start: Int,
    @SerializedName("end") val end: Int,
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