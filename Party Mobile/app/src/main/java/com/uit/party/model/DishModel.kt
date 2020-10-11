package com.uit.party.model

import androidx.room.Entity
import androidx.room.PrimaryKey
import com.google.gson.annotations.SerializedName
import java.io.Serializable

class AddDishRequest(
    val name: String? = null,
    val description: String? = null,
    val price: Float? = 0f,
    val type: String? = null
)

class AddDishResponse : BaseResponse() {
    @SerializedName("dish")
    val dish: DishModel? = null
}

@Entity(tableName = "dish_table")
data class DishModel(
    @PrimaryKey(autoGenerate = true)
    @SerializedName("_id") val _id: String,
    @SerializedName("name") val name: String? = null,
    @SerializedName("price") val price: String? = null,
    @SerializedName("price_new") val newPrice: String? = null,
    @SerializedName("discount") val discount: Int? = 0,
    @SerializedName("description") val description: String? = null,
    @SerializedName("categories") val categories: ArrayList<String>? = null,
    @SerializedName("image") val image: ArrayList<String>? = null,
    @SerializedName("updateAt") val updateAt: String? = null,
    @SerializedName("createAt") val createAt: String? = null
) : Serializable

data class RateModel(
    @SerializedName("average") val average: Float? = 5f,
    @SerializedName("lishRate") val listRates: ArrayList<ListRate>,
    @SerializedName("totalpeople") val totalPeople: Int? = 0
) : Serializable

data class ListRate(
    @SerializedName("username") val username: String? = null,
    @SerializedName("_iddish") val _iddish: String? = null,
    @SerializedName("scorerate") val scorerate: Float? = 5f,
    @SerializedName("content") val content: String? = null,
    @SerializedName("updateAt") val createAt: String? = null
) : Serializable