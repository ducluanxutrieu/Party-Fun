package com.uit.party.data

import com.uit.party.model.Account
import com.uit.party.model.AccountResponse
import com.uit.party.model.GetHistoryCartResponse
import com.uit.party.model.HistoryCartModel
import com.uit.party.ui.main.MainActivity
import com.uit.party.ui.signin.login.LoginViewModel
import com.uit.party.util.SharedPrefs
import com.uit.party.util.ToastUtil
import com.uit.party.util.getNetworkService
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

object GetData {
    fun getUserProfile(onComplete: (Account?) -> Unit) {
        getNetworkService().getProfile(MainActivity.TOKEN_ACCESS)
            .enqueue(object : Callback<AccountResponse> {
                override fun onFailure(call: Call<AccountResponse>, t: Throwable) {
                    t.message?.let { ToastUtil.showToast(it) }
                }

                override fun onResponse(
                    call: Call<AccountResponse>,
                    response: Response<AccountResponse>
                ) {
                    if (response.code() == 200){
                        val repo = response.body()
                        onComplete(repo?.account)
                        SharedPrefs().getInstance().put(LoginViewModel.USER_INFO_KEY, repo?.account)
                    }else onComplete(null)
                }
            })
    }

    fun getHistoryBooking(onComplete: (HistoryCartModel?) -> Unit) {
        getNetworkService().getHistoryBooking(MainActivity.TOKEN_ACCESS)
            .enqueue(object : Callback<GetHistoryCartResponse> {
                override fun onFailure(call: Call<GetHistoryCartResponse>, t: Throwable) {
                    t.message?.let { ToastUtil.showToast(it) }
                }

                override fun onResponse(
                    call: Call<GetHistoryCartResponse>,
                    model: Response<GetHistoryCartResponse>
                ) {
                    if (model.code() == 200){
                        val repo = model.body()
                        onComplete(repo?.historyCartModel)
                    }else onComplete(null)
                }
            })
    }
}