package com.uit.party.user

import com.uit.party.data.CusResult
import com.uit.party.data.PartyBookingDatabase
import com.uit.party.data.getToken
import com.uit.party.model.BaseResponse
import com.uit.party.util.ServiceRetrofit
import com.uit.party.util.SharedPrefs
import com.uit.party.util.handleRequest
import javax.inject.Inject


class UserDataRepository @Inject constructor (private val networkService: ServiceRetrofit, private val sharedPrefs: SharedPrefs, private val database: PartyBookingDatabase) {

    suspend fun logout(): CusResult<BaseResponse> {
        return handleRequest {
            networkService.logout(getToken())
        }
    }

    fun clearData() {
        sharedPrefs.clear()
        database.clearAllTables()
    }
}
