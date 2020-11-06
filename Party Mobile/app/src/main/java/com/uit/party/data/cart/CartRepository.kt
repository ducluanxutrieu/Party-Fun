package com.uit.party.data.cart

import androidx.lifecycle.LiveData
import com.uit.party.data.CusResult
import com.uit.party.data.getToken
import com.uit.party.model.BillModel
import com.uit.party.model.CartModel
import com.uit.party.model.RequestOrderPartyModel
import com.uit.party.util.ServiceRetrofit

class CartRepository(
    private val networkService: ServiceRetrofit,
    private val cartDao: CartDao
) {
    val listCart: LiveData<List<CartModel>> = cartDao.getCart

    suspend fun orderParty(bookModel: RequestOrderPartyModel): BillModel {
        val result = networkService.orderParty(getToken(), bookModel)
        if (result.billModel != null) {
            return result.billModel
        }

        throw Exception(result.message)
    }


    suspend fun insertCart(cartModel: CartModel) {
        try {
            val list: List<CartModel> = cartDao.getCartItem(cartModel.id)
            var existed = false
            list.forEach {
                if (it.id == cartModel.id) {
                    cartDao.updateQuantityCart(++it.quantity, it.id)
                    existed = true
                    return@forEach
                }
            }

            if (!existed) {
                cartDao.insertCart(cartModel)
            }
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }

    suspend fun updateCart(cartModel: CartModel) {
        try {
            cartDao.updateQuantityCart(cartModel.quantity, cartModel.id)
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }

    suspend fun deleteCart(cartModel: CartModel) {
        try {
            cartDao.deleteCart(cartModel)
        } catch (cause: Throwable) {
            CusResult.Error(Exception(cause))
        }
    }
}