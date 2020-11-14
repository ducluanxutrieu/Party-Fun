package com.uit.party.data.history_order

import com.uit.party.util.ServiceRetrofit

class HistoryOrderRepository(
    private val networkService: ServiceRetrofit,
    private val historyOrderDao: HistoryOrderDao
) {

}