package com.uit.party.data.cart

import androidx.lifecycle.LiveData
import com.google.gson.Gson
import com.uit.party.data.CusResult
import com.uit.party.data.getToken
import com.uit.party.model.*
import com.uit.party.util.ServiceRetrofit
import retrofit2.HttpException
import java.io.IOException

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

    private suspend fun <T : Any> handleRequest(requestFunc: suspend () -> T): CusResult<T> {
        return try {
            CusResult.Success(requestFunc.invoke())
        } catch (httpException: HttpException) {
            val errorMessage = getErrorMessageFromGenericResponse(httpException)
            if (errorMessage.isNullOrBlank()) {
                CusResult.Error(httpException)
            } else {
                CusResult.Error(java.lang.Exception(errorMessage))
            }
        }
    }

    private fun getErrorMessageFromGenericResponse(httpException: HttpException): String? {
        var errorMessage: String? = null
        try {
            val body = httpException.response()?.errorBody()
            val adapter = Gson().getAdapter(BaseResponse::class.java)
            val errorParser = adapter.fromJson(body?.string())
            errorMessage = errorParser.message
        } catch (e: IOException) {
            e.printStackTrace()
        } finally {
            return errorMessage
        }
    }
}