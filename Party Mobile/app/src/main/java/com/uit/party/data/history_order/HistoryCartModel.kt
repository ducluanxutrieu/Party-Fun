package com.uit.party.data.history_order

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "history_order_table")
data class HistoryCartModel(
    @PrimaryKey
    var userToken: String = "",
    var nextKey: Int?,
    var prevKey: Int?
)