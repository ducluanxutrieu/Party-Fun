package com.uit.party.data.history_order

import androidx.room.Dao


@Dao
interface HistoryOrderDao {
    suspend fun getHistoryOrder() {

    }

}