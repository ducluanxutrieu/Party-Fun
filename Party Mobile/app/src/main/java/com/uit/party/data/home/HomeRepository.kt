package com.uit.party.data.home

import androidx.lifecycle.LiveData
import com.uit.party.data.CusResult
import com.uit.party.data.PartyBookingDatabase
import com.uit.party.data.getToken
import com.uit.party.model.Account
import com.uit.party.model.BaseResponse
import com.uit.party.model.DishModel
import com.uit.party.model.UserRole
import com.uit.party.util.Constants.Companion.USER_INFO_KEY
import com.uit.party.util.GlobalApplication
import com.uit.party.util.ServiceRetrofit
import com.uit.party.util.SharedPrefs
import java.util.*
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class HomeRepository @Inject constructor (
    private val networkService: ServiceRetrofit,
    database: PartyBookingDatabase
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

    fun checkAdmin(): Boolean {
        val role =
            SharedPrefs(GlobalApplication.appContext!!).getData(USER_INFO_KEY, Account::class.java)?.role
        return (role == UserRole.Admin.ordinal || role == UserRole.Staff.ordinal)
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
            val result: BaseResponse = networkService.deleteDish(getToken(), map)
            homeDao.deleteDish(id)
            CusResult.Success(result)
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }
}