package com.uit.party.data.cart

import androidx.lifecycle.LiveData
import com.uit.party.data.CusResult
import com.uit.party.data.getToken
import com.uit.party.model.BillResponseModel
import com.uit.party.model.CartModel
import com.uit.party.model.GetPaymentResponse
import com.uit.party.model.RequestOrderPartyModel
import com.uit.party.util.ServiceRetrofit
import com.uit.party.util.handleRequest

class CartRepository(
    private val networkService: ServiceRetrofit,
    private val cartDao: CartDao
) {
    val listCart: LiveData<List<CartModel>> = cartDao.getCart

    suspend fun deleteAllCart() {
        cartDao.deleteAllCart()
    }

    suspend fun orderParty(bookModel: RequestOrderPartyModel): CusResult<BillResponseModel> {
        try {
            return handleRequest {
                networkService.orderParty(getToken(), bookModel)
            }
        } catch (error: Throwable) {
            throw Throwable(error)
        }
    }

    suspend fun getPayment(id: String): CusResult<GetPaymentResponse> {
        return handleRequest {
            networkService.getPayment(getToken(), id)
        }
    }

    suspend fun insertCart(cartModel: CartModel) {
        try {
            val item: CartModel? = cartDao.getCartItem(cartModel.id)

            if (item != null) {
                val quantity = item.quantity + 1
                cartDao.updateQuantityCart(quantity, item.id)
            } else
                cartDao.insertCart(cartModel)
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