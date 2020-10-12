package com.uit.party.data.home

import androidx.lifecycle.LiveData
import com.uit.party.data.CusResult
import com.uit.party.model.*
import com.uit.party.model.UserRole
import com.uit.party.ui.main.MainActivity
import com.uit.party.ui.signin.login.LoginViewModel
import com.uit.party.util.ServiceRetrofit
import com.uit.party.util.SharedPrefs
import java.util.HashMap

class HomeRepository(
    private val networkService: ServiceRetrofit,
    private val homeDao: HomeDao
) {

    val listMenu: LiveData<List<DishModel>> = homeDao.allDish
    val listCart: LiveData<List<CartModel>> = homeDao.getCart

    suspend fun getListDishes() {
        try {
            val result = networkService.getListDishes(MainActivity.TOKEN_ACCESS)
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

    suspend fun insertCart(cartModel: CartModel) {
        try {
            val list: List<CartModel> = homeDao.getCartItem(cartModel.id)
            var existed = false
            list.forEach {
                if(it.id == cartModel.id){
                    homeDao.updateQuantityCart(++it.quantity, it.id)
                    existed = true
                    return@forEach
                }
            }

            if (!existed){
                homeDao.insertCart(cartModel)
            }
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }

    suspend fun updateCart(cartModel: CartModel) {
        try {
            homeDao.updateQuantityCart(cartModel.quantity, cartModel.id)
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }

    suspend fun deleteCart(cartModel: CartModel) {
        try {
            homeDao.deleteCart(cartModel)
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
            val result: BaseResponse = networkService.deleteDish(MainActivity.TOKEN_ACCESS, map)
            homeDao.deleteDish(id)
            CusResult.Success(result)
        }catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }

    suspend fun getItemDish(id: String): CusResult<DishModel> {
        val hashMap = HashMap<String, String?>()
        hashMap["_id"] = id
        return try {
            val result = networkService.getItemDish(hashMap)
            if (result.dish != null) {
                insertDish(result.dish)
                CusResult.Success(result.dish)
            }else{
                CusResult.Error(Exception())
            }
        }catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }
}