package com.uit.party.data.history_order

import androidx.paging.ExperimentalPagingApi
import androidx.paging.LoadType
import androidx.paging.PagingState
import androidx.paging.RemoteMediator
import androidx.room.withTransaction
import com.uit.party.data.PartyBookingDatabase
import com.uit.party.data.getToken
import com.uit.party.util.Constants.Companion.STARTING_PAGE_INDEX
import com.uit.party.util.ServiceRetrofit
import com.uit.party.util.UiUtil
import retrofit2.HttpException
import java.io.IOException

@OptIn(ExperimentalPagingApi::class)
class HistoryOrderRemoteMediator(private val service: ServiceRetrofit, private val database: PartyBookingDatabase) :
    RemoteMediator<Int, CartItem>() {

    private val historyDao: HistoryOrderDao = database.historyOrderDao

    override suspend fun load(
        loadType: LoadType,
        state: PagingState<Int, CartItem>
    ): MediatorResult {
        val page = when (loadType) {
            LoadType.REFRESH -> {
                val remoteKeys = getRemoteKeyClosestToCurrentPosition(state)
                remoteKeys?.nextKey?.minus(1) ?: STARTING_PAGE_INDEX
            }

            LoadType.PREPEND -> {
                val remoteKeys = getRemoteKeyForFirstItem(state)
                if (remoteKeys == null) UiUtil.showToast("Remote key and the prevKey should not be null")
                remoteKeys?.prevKey ?: return MediatorResult.Success(endOfPaginationReached = true)
            }

            LoadType.APPEND -> {
                val remoteKeys = getRemoteKeyForLastItem(state)
                if (remoteKeys?.nextKey == null) {
                    UiUtil.showToast("Remote key should not be null for $loadType")
                }
                remoteKeys?.nextKey ?: return MediatorResult.Success(endOfPaginationReached = true)
            }
        }

        try {
            val apiResponse = service.getHistoryBooking(getToken(), page)

            val repos = apiResponse?.historyCartModel
            val endOfPaginationReached: Boolean = repos?.cartItems.isNullOrEmpty() || (page == repos?.totalPage)

            database.withTransaction {
                // clear all tables in the database
                if (loadType == LoadType.REFRESH) {
//                    historyDao.clearHistoryOrder(orderId)
                    historyDao.clearAllHistoryOrder()
                }
                val prevKey = if (page == STARTING_PAGE_INDEX) null else page - 1
                val nextKey = if (endOfPaginationReached) null else page + 1
                val cartModel = HistoryCartModel(
                    totalPage = repos?.totalPage ?: 0,
                    start = repos?.start ?: 0,
                    end = repos?.end ?: 0,
                    prevKey = prevKey ?: 0,
                    nextKey = nextKey ?: 0
                )
                historyDao.insertHistoryCart(cartModel)
                historyDao.insertListHistoryOrder(repos?.cartItems ?: emptyList<CartItem>())
            }
            return MediatorResult.Success(endOfPaginationReached = endOfPaginationReached)
        } catch (exception: IOException) {
            return MediatorResult.Error(exception)
        } catch (exception: HttpException) {
            return MediatorResult.Error(exception)
        }
    }

    private suspend fun getRemoteKeyClosestToCurrentPosition(state: PagingState<Int, CartItem>): HistoryCartModel? {
        return state.anchorPosition?.let { position ->
            state.closestItemToPosition(position)?.id?.let {
                historyDao.getHistoryOrder()
            }
        }
    }

    private suspend fun getRemoteKeyForLastItem(state: PagingState<Int, CartItem>): HistoryCartModel? {
        // Get the last page that was retrieved, that contained items.
        // From that last page, get the last item
        return state.pages.lastOrNull() { it.data.isNotEmpty() }?.data?.lastOrNull()
            ?.let {
                // Get the remote keys of the last item retrieved
                historyDao.getHistoryOrder()
            }
    }

    private suspend fun getRemoteKeyForFirstItem(state: PagingState<Int, CartItem>): HistoryCartModel? {
        // Get the first page that was retrieved, that contained items.
        // From that first page, get the first item
        return state.pages.firstOrNull { it.data.isNotEmpty() }?.data?.firstOrNull()
            ?.let {
                // Get the remote keys of the first items retrieved
                historyDao.getHistoryOrder()
            }
    }
}