package com.uit.party.model

import com.google.gson.annotations.SerializedName

class MenuModel (
    @SerializedName("name")
    var menuName: String = "",

    @SerializedName("listDish")
    var listDish : ArrayList<DishModel>
)