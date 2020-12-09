package com.uit.party.data.home

import androidx.lifecycle.LiveData
import com.uit.party.data.CusResult
import com.uit.party.data.PartyBookingDatabase
import com.uit.party.model.BaseResponse
import com.uit.party.model.DishModel
import com.uit.party.model.UpdateDishRequestModel
import com.uit.party.model.UpdateDishResponse
import com.uit.party.util.ServiceRetrofit
import com.uit.party.util.SharedPrefs
import com.uit.party.util.handleRequest
import java.util.*
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class HomeRepository @Inject constructor(
    private val networkService: ServiceRetrofit,
    private val sharedPrefs: SharedPrefs,
    database: PartyBookingDatabase
) {

    private val homeDao = database.homeDao
    val listMenu: LiveData<List<DishModel>> = homeDao.allDish

    suspend fun updateDish(updateModel: UpdateDishRequestModel): CusResult<UpdateDishResponse> {
        val result = handleRequest {
            networkService.updateDish(sharedPrefs.token, updateModel)
        }
        if (result is CusResult.Success) {
            val dishModel = result.data.dish
            if (dishModel != null)
                homeDao.updateDish(result.data.dish)
        }
        return result
    }

    suspend fun getListDishes() {
        try {
            val result = networkService.getListDishes(sharedPrefs.token)
            val dishes = result.listDishes
            if (dishes != null) {
                homeDao.deleteMenu()
                homeDao.insertAllDish(dishes)
            }
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }

    suspend fun insertDish(dishModel: DishModel) {
        try {
            homeDao.insertDish(dishModel)
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }

    suspend fun deleteDish(id: String): CusResult<BaseResponse> {
        return try {
            val map = HashMap<String, String>()
            map["_id"] = id
            val result: BaseResponse = networkService.deleteDish(sharedPrefs.token, map)
            homeDao.deleteDish(id)
            CusResult.Success(result)
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }
}