package com.uit.party.data

import com.uit.party.data.history_order.GetHistoryCartResponse
import com.uit.party.data.history_order.HistoryCartModel
import com.uit.party.util.Constants
import com.uit.party.util.SharedPrefs
import com.uit.party.util.UiUtil
import com.uit.party.util.getNetworkService
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

object GetData {
    fun getHistoryBooking(onComplete: (HistoryCartModel?) -> Unit) {
        getNetworkService().getHistoryBooking(getToken())
            .enqueue(object : Callback<GetHistoryCartResponse> {
                override fun onFailure(call: Call<GetHistoryCartResponse>, t: Throwable) {
                    t.message?.let { UiUtil.showToast(it) }
                }

                override fun onResponse(
                    call: Call<GetHistoryCartResponse>,
                    model: Response<GetHistoryCartResponse>
                ) {
                    if (model.code() == 200) {
                        val repo = model.body()
                        onComplete(repo?.historyCartModel)
                    } else onComplete(null)
                }
            })
    }
}

fun getToken(): String {
    val sharedPrefs: SharedPrefs = SharedPrefs().getInstance()
    val token = sharedPrefs[Constants.TOKEN_ACCESS_KEY, String::class.java]
    return token ?: ""
}