/*
 * Copyright (C) 2020 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.uit.party.data.rate

import androidx.paging.ExperimentalPagingApi
import androidx.paging.LoadType
import androidx.paging.PagingState
import androidx.paging.RemoteMediator
import androidx.room.withTransaction
import com.uit.party.data.PartyBookingDatabase
import com.uit.party.model.ItemDishRateModel
import com.uit.party.model.RateModel
import com.uit.party.util.ServiceRetrofit
import com.uit.party.util.UiUtil
import retrofit2.HttpException
import java.io.IOException

// GitHub page API is 1 based: https://developer.github.com/v3/#pagination
private const val GITHUB_STARTING_PAGE_INDEX = 1

@OptIn(ExperimentalPagingApi::class)
class RateRemoteMediator(
    private val dishID: String,
    private val service: ServiceRetrofit,
    private val repoDatabase: PartyBookingDatabase
) : RemoteMediator<Int, RateModel>() {

    override suspend fun load(
        loadType: LoadType,
        state: PagingState<Int, RateModel>
    ): MediatorResult {

        val page = when (loadType) {
            LoadType.REFRESH -> {
                val remoteKeys = getRemoteKeyClosestToCurrentPosition(state)
                remoteKeys?.nextKey?.minus(1) ?: GITHUB_STARTING_PAGE_INDEX
            }
            LoadType.PREPEND -> {
                val remoteKeys = getRemoteKeyForFirstItem(state)
//                    ?: // The LoadType is PREPEND so some data was loaded before,
                    // so we should have been able to get remote keys
                    // If the remoteKeys are null, then we're an invalid state and we have a bug
//                    throw InvalidObjectException("Remote key and the prevKey should not be null")
                // If the previous key is null, then we can't request more data
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
            val apiResponse = service.getDishRates(dishID, page)

            val repos = apiResponse.itemDishRateModel
            val endOfPaginationReached: Boolean = repos?.listRatings.isNullOrEmpty() || (page == repos?.total_page)

            repoDatabase.withTransaction {
                // clear all tables in the database
                if (loadType == LoadType.REFRESH) {
                    repoDatabase.rateDao.clearRateDish(dishID)
                    repoDatabase.rateDao.clearRateDishList(dishID)
                }
                val prevKey = if (page == GITHUB_STARTING_PAGE_INDEX) null else page - 1
                val nextKey = if (endOfPaginationReached) null else page + 1
                val dishRateModel = ItemDishRateModel(
                    dishID,
                    count_rate = repos?.count_rate ?: 0,
                    total_page = repos?.total_page ?: 0,
                    avg_rate = repos?.avg_rate ?: 0.0,
                    start = repos?.start ?: 0,
                    end = repos?.end ?: 0,
                    prevKey = prevKey,
                    nextKey = nextKey
                )
                repoDatabase.rateDao.insertListRating(rateModel = repos?.listRatings ?: emptyList())
                repoDatabase.rateDao.insertDishRating(dishRateModel)
            }
            return MediatorResult.Success(endOfPaginationReached = endOfPaginationReached)
        } catch (exception: IOException) {
            return MediatorResult.Error(exception)
        } catch (exception: HttpException) {
            return MediatorResult.Error(exception)
        }
    }

    private suspend fun getRemoteKeyForLastItem(state: PagingState<Int, RateModel>): ItemDishRateModel? {
        // Get the last page that was retrieved, that contained items.
        // From that last page, get the last item
        return state.pages.lastOrNull() { it.data.isNotEmpty() }?.data?.lastOrNull()
            ?.let { repo ->
                // Get the remote keys of the last item retrieved
                repoDatabase.rateDao.getDishRating(repo.id_dish)
            }
    }

    private suspend fun getRemoteKeyForFirstItem(state: PagingState<Int, RateModel>): ItemDishRateModel? {
        // Get the first page that was retrieved, that contained items.
        // From that first page, get the first item
        return state.pages.firstOrNull { it.data.isNotEmpty() }?.data?.firstOrNull()
            ?.let { repo ->
                // Get the remote keys of the first items retrieved
                repoDatabase.rateDao.getDishRating(repo.id_dish)
            }
    }

    private suspend fun getRemoteKeyClosestToCurrentPosition(
        state: PagingState<Int, RateModel>
    ): ItemDishRateModel? {
        // The paging library is trying to load data after the anchor position
        // Get the item closest to the anchor position
        return state.anchorPosition?.let { position ->
            state.closestItemToPosition(position)?.id?.let { repoId ->
                repoDatabase.rateDao.getDishRating(repoId)
            }
        }
    }

}