package com.uit.party.data.history_order

import android.util.Log
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
import java.io.InvalidObjectException

@OptIn(ExperimentalPagingApi::class)
class HistoryOrderRemoteMediator(
    private val service: ServiceRetrofit,
    private val database: PartyBookingDatabase
) :
    RemoteMediator<Int, CartItem>() {

    private val historyDao: HistoryOrderDao = database.historyOrderDao
    private var prevKey: Int? = 0
    private var nextKey: Int? = 2

    override suspend fun load(
        loadType: LoadType,
        state: PagingState<Int, CartItem>
    ): MediatorResult {
        val page: Int? = when (loadType) {
            LoadType.REFRESH -> {
                Log.i("HistoryOrderRemote", "REFRESH")
                STARTING_PAGE_INDEX
            }

            LoadType.PREPEND -> {
                Log.i("HistoryOrderRemote", "PREPEND")
                return MediatorResult.Success(endOfPaginationReached = true)
            }

            LoadType.APPEND -> {
                Log.i("HistoryOrderRemote", "APPEND")
//                getRemoteKeyForLastItem(state)
//                    ?: throw InvalidObjectException("Remote key should not be null for $loadType")
                state.lastItemOrNull()
                    ?: return MediatorResult.Success(
                        endOfPaginationReached = true
                    )

                // You must explicitly check if the last item is null when
                // appending, since passing null to networkService is only
                // valid for initial load. If lastItem is null it means no
                // items were loaded after the initial REFRESH and there are
                // no more items to load.

                nextKey ?: return MediatorResult.Success(
                    endOfPaginationReached = true
                )
            }
        }

        Log.i("HistoryOrderRemote", page.toString())

        try {
            val apiResponse = service.getHistoryBooking(getToken(), page ?: 1)

            val repos = apiResponse?.historyCartModel
            val endOfPaginationReached: Boolean =
                repos?.cartItems.isNullOrEmpty() || (page == repos?.totalPage)
            database.withTransaction {
                // clear all tables in the database
                if (loadType == LoadType.REFRESH) {
                    historyDao.clearAllOrdered()
                }
                prevKey = if (page == STARTING_PAGE_INDEX) null else page?.minus(1)
                nextKey = if (endOfPaginationReached) null else page?.plus(1)

                historyDao.insertListHistoryOrder(repos?.cartItems ?: emptyList())
            }
            return MediatorResult.Success(endOfPaginationReached = endOfPaginationReached)
        } catch (exception: IOException) {
            return MediatorResult.Error(exception)
        } catch (exception: HttpException) {
            return MediatorResult.Error(exception)
        }
    }

    private fun getRemoteKeyForFirstItem(state: PagingState<Int, CartItem>): Int? {
        // Get the first page that was retrieved, that contained items.
        // From that first page, get the first item
        return state.pages.firstOrNull { it.data.isNotEmpty() }?.data?.firstOrNull()
            ?.let {
                // Get the remote keys of the first items retrieved
                prevKey
            }
    }

    private fun getRemoteKeyForLastItem(state: PagingState<Int, CartItem>): Int? {
        // Get the last page that was retrieved, that contained items.
        // From that last page, get the last item
        return state.pages.lastOrNull { it.data.isNotEmpty() }?.data?.lastOrNull()
            ?.let {
                // Get the remote keys of the last item retrieved
                nextKey
            }
    }
}