package com.uit.party.data

import com.uit.party.model.Account
import com.uit.party.model.AccountResponse
import com.uit.party.ui.main.MainActivity
import com.uit.party.ui.signin.login.LoginViewModel
import com.uit.party.util.SharedPrefs
import com.uit.party.util.ToastUtil
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

object GetData {
    fun getUserProfile(onComplete: (Account) -> Unit) {
        MainActivity.serviceRetrofit.getProfile(MainActivity.TOKEN_ACCESS)
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
                        repo?.account?.let { onComplete(it) }
                        SharedPrefs().getInstance().put(LoginViewModel.USER_INFO_KEY, repo?.account)
                    }
                }
            })
    }
}