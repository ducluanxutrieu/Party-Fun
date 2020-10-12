package com.uit.party.data.home

import androidx.lifecycle.LiveData
import com.uit.party.data.CusResult
import com.uit.party.model.Account
import com.uit.party.model.DishModel
import com.uit.party.model.UserRole
import com.uit.party.ui.main.MainActivity
import com.uit.party.ui.signin.login.LoginViewModel
import com.uit.party.util.ServiceRetrofit
import com.uit.party.util.SharedPrefs

class HomeRepository(
    private val networkService: ServiceRetrofit,
    private val homeDao: HomeDao
) {

    val listMenu: LiveData<List<DishModel>> = homeDao.allDish
    val listCart: LiveData<List<DishModel>> = homeDao.getCart

    suspend fun getListDishes() {
        try {
            val result = networkService.getListDishes(MainActivity.TOKEN_ACCESS)
            val dishes = result.listDishes
            if (dishes != null) {
                homeDao.insertAllDish(dishes)
            }
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }

    suspend fun logout() {
        try {
            networkService.logout(MainActivity.TOKEN_ACCESS)
            SharedPrefs().getInstance().clear()
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }

    fun checkAdmin(): Boolean {
        val role =
            SharedPrefs().getInstance()[LoginViewModel.USER_INFO_KEY, Account::class.java]?.role
        return (role == UserRole.Admin.ordinal || role == UserRole.Staff.ordinal)
    }

    suspend fun updateDish(dishModel: DishModel) {
        homeDao.updateDish(dishModel)
    }

    suspend fun insertCart(dishModel: DishModel) {
        try {
            homeDao.updateCart(1, dishModel.id)
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }

    suspend fun updateCart(dishModel: DishModel) {
        try {
            homeDao.updateCart(dishModel.quantity, dishModel.id)
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }

    suspend fun deleteCart(cartModel: DishModel) {
        try {
            homeDao.deleteCart(cartModel.id)
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }
}