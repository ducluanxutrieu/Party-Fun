package com.uit.party.data.history_order

import androidx.paging.Pager
import androidx.paging.PagingConfig
import androidx.paging.PagingData
import com.uit.party.data.PartyBookingDatabase
import com.uit.party.util.Constants.Companion.NETWORK_PAGE_SIZE
import com.uit.party.util.ServiceRetrofit
import kotlinx.coroutines.flow.Flow

class HistoryOrderRepository(
    private val networkService: ServiceRetrofit,
    private val database: PartyBookingDatabase
) {

    fun getListOrdered(): Flow<PagingData<CartItem>>{
        val pagingSourceFactory = {database.historyOrderDao.pagingSource()}

        return Pager(
            config = PagingConfig(pageSize = NETWORK_PAGE_SIZE, enablePlaceholders = false),
            pagingSourceFactory = pagingSourceFactory,
            remoteMediator = HistoryOrderRemoteMediator(
                networkService, database
            )
        ).flow
    }
}