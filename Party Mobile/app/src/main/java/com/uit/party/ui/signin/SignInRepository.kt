package com.uit.party.ui.signin

import com.uit.party.data.CusResult
import com.uit.party.model.*
import com.uit.party.util.Constants
import com.uit.party.util.ServiceRetrofit
import com.uit.party.util.Storage
import com.uit.party.util.handleRequest
import dagger.Provides
import javax.inject.Inject


@SignInScope
class SignInRepository @Inject constructor(
    private val networkService: ServiceRetrofit,
    private val storage: Storage
) {

    suspend fun register(registerModel: RegisterModel): CusResult<AccountResponse> {
        return handleRequest {
            networkService.register(registerModel)
        }
    }

    suspend fun login(model: LoginModel): CusResult<AccountResponse> {
        return handleRequest {
            networkService.login(model)
        }
    }

    fun saveToMemory(model: Account?, token: String? = null) {
        storage.setData(Constants.USER_INFO_KEY, model)
        if (!token.isNullOrEmpty())
            storage.setData(Constants.TOKEN_ACCESS_KEY, model?.token)
    }

    suspend fun resetPassword(username: String): CusResult<BaseResponse> {
        return handleRequest {
            networkService.resetPassword(username)
        }
    }
}