package com.uit.party.data.history_order

import androidx.paging.ExperimentalPagingApi
import androidx.paging.LoadType
import androidx.paging.PagingState
import androidx.paging.RemoteMediator

@OptIn(ExperimentalPagingApi::class)
class HistoryOrderRemoteMediator (private val historyDao: HistoryOrderDao): RemoteMediator<Int, CartItem>(){
    override suspend fun load(
        loadType: LoadType,
        state: PagingState<Int, CartItem>
    ): MediatorResult {
        val page = when(loadType){
            LoadType.REFRESH -> {
                val remoteKeys = getRemoteKeyClosestToCurrentPosition(state)
            }

            LoadType.PREPEND -> {

            }

            LoadType.APPEND ->{

            }
        }
    }

    private fun getRemoteKeyClosestToCurrentPosition(state: PagingState<Int, CartItem>): HistoryCartModel? {
        return state.anchorPosition?.let { position->
            state.closestItemToPosition(position)?.id?.let {
                repoId ->
                historyDao.getHistoryOrder()
            }
        }
    }

}