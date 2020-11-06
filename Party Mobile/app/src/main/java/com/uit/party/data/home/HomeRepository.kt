package com.uit.party.data.home

import androidx.lifecycle.LiveData
import androidx.paging.Pager
import androidx.paging.PagingConfig
import androidx.paging.PagingData
import com.uit.party.data.CusResult
import com.uit.party.data.PartyBookingDatabase
import com.uit.party.data.RateRemoteMediator
import com.uit.party.data.getToken
import com.uit.party.model.*
import com.uit.party.util.Constants.Companion.USER_INFO_KEY
import com.uit.party.util.ServiceRetrofit
import com.uit.party.util.SharedPrefs
import kotlinx.coroutines.flow.Flow
import java.util.*

class HomeRepository(
    private val networkService: ServiceRetrofit,
    val database: PartyBookingDatabase
) {

    private val homeDao = database.homeDao
    val listMenu: LiveData<List<DishModel>> = homeDao.allDish

    suspend fun getListDishes() {
        try {
            val result = networkService.getListDishes(getToken())
            val dishes = result.listDishes
            if (dishes != null) {
                homeDao.deleteMenu()
                homeDao.insertAllDish(dishes)
            }
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }

    suspend fun logout() {
        try {
            networkService.logout(getToken())
            SharedPrefs().getInstance().clear()
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }

    fun checkAdmin(): Boolean {
        val role =
            SharedPrefs().getInstance()[USER_INFO_KEY, Account::class.java]?.role
        return (role == UserRole.Admin.ordinal || role == UserRole.Staff.ordinal)
    }

/*    suspend fun updateDish(dishModel: DishModel) {
        homeDao.updateDish(dishModel)
    }*/


    suspend fun insertDish(dishModel: DishModel) {
        try {
            homeDao.insertDish(dishModel)
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

    suspend fun deleteDish(id: String): CusResult<BaseResponse> {
        return try {
            val map = HashMap<String, String>()
            map["_id"] = id
            val result: BaseResponse = networkService.deleteDish(getToken(), map)
            homeDao.deleteDish(id)
            CusResult.Success(result)
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }

    /*suspend fun getItemDish(id: String): CusResult<DishModel> {
        val hashMap = HashMap<String, String?>()
        hashMap["_id"] = id
        return try {
            val result = networkService.getItemDish(hashMap)
            if (result.dish != null) {
                insertDish(result.dish)
                CusResult.Success(result.dish)
            } else {
                CusResult.Error(Exception())
            }
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }*/

    fun getDishRating(dishId: String): Flow<PagingData<RateModel>> {
        val pagingSourceFactory = { database.rateDao.getSingleDishRating(dishId) }
        return Pager(
            config = PagingConfig(pageSize = NETWORK_PAGE_SIZE),
            pagingSourceFactory = pagingSourceFactory,
            remoteMediator = RateRemoteMediator(
                dishId,
                networkService,
                database
            )
        ).flow

        /*return try {
            val result = networkService.getDishRates(dishId, 0)

            if (result.itemDishRateModel != null)
                insertDishRating(result.itemDishRateModel, dishId)
            CusResult.Success(result)
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }*/
    }

    companion object {
        private const val NETWORK_PAGE_SIZE = 10
    }
}