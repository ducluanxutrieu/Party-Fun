package com.uit.party.model

import com.google.gson.annotations.SerializedName
import retrofit2.http.Multipart
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

data class DishModel(
    @SerializedName("_id") val _id : String? = null,
    @SerializedName("name") val name : String? = null,
    @SerializedName("price") val price : String? = null,
    @SerializedName("description") val description : String? = null,
    @SerializedName("type") val type : String? = null,
    @SerializedName("image") val image : ArrayList<String>? = null,
    @SerializedName("updateAt") val updateAt : String? = null,
    @SerializedName("createAt") val createAt : String? = null
): Serializable