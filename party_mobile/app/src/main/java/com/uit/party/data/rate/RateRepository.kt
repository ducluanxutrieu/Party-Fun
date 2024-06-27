package com.uit.party.data.rate

import androidx.paging.Pager
import androidx.paging.PagingConfig
import androidx.paging.PagingData
import com.uit.party.data.CusResult
import com.uit.party.data.PartyBookingDatabase
import com.uit.party.data.getToken
import com.uit.party.model.RateModel
import com.uit.party.model.RequestRatingModel
import com.uit.party.model.SingleRateResponseModel
import com.uit.party.util.Constants.Companion.NETWORK_PAGE_SIZE
import com.uit.party.util.ServiceRetrofit
import kotlinx.coroutines.flow.Flow

class RateRepository (private val networkService: ServiceRetrofit,
                      private val database: PartyBookingDatabase
){
    fun getDishRating(dishId: String): Flow<PagingData<RateModel>> {
        val pagingSourceFactory = { database.rateDao.getRateByDishId(dishId) }
        return Pager(
            config = PagingConfig(pageSize = NETWORK_PAGE_SIZE, enablePlaceholders = false),
            pagingSourceFactory = pagingSourceFactory,
            remoteMediator = RateRemoteMediator(
                dishId,
                networkService,
                database
            )
        ).flow
    }

    suspend fun requestRatingDish(requestModel: RequestRatingModel): CusResult<SingleRateResponseModel> {
        return try {
            val result = networkService.ratingDish(getToken(), requestModel)
            if (result.rateModel != null) {
                database.rateDao.insertItemRating(result.rateModel)
            }
            CusResult.Success(result)
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }

    //Rating

    /*private suspend fun insertDishRating(dishRating: ItemDishRateModelResponse, dishId: String) {
        try {
            dishRating.dishId = dishId
            val temp = ItemDishRateModel(
                dishId = dishRating.dishId,
                count_rate = dishRating.count_rate,
                avg_rate = dishRating.avg_rate,
                total_page = dishRating.total_page,
                start = dishRating.start,
                end = dishRating.end
            )
            database.rateDao.insertDishRating(temp)
            database.rateDao.insertListRating(dishRating.listRatings)
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }*/
}