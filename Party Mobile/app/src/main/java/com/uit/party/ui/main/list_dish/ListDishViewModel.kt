package com.uit.party.ui.main.list_dish

import android.util.Log
import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import androidx.databinding.library.baseAdapters.BR
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.uit.party.R
import com.uit.party.model.BaseResponse
import com.uit.party.ui.main.MainActivity
import com.uit.party.ui.main.MainActivity.Companion.serviceRetrofit
import com.uit.party.ui.signin.login.LoginViewModel.Companion.TOKEN_ACCESS
import com.uit.party.util.GlobalApplication
import com.uit.party.util.ToastUtil
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.BufferedReader
import java.io.IOException
import java.io.InputStreamReader
import java.io.StringWriter

class ListDishViewModel : BaseObservable(){
    @get: Bindable
    var dishList = ArrayList<DishModel>()
        private set(value) {
            field = value
            notifyPropertyChanged(BR.dishList)
        }

    fun init() {
        initProductEntryList()
    }

    private fun initProductEntryList() {
        val inputStream = GlobalApplication.appContext!!.resources.openRawResource(R.raw.products)
        val writer = StringWriter()
        val buffer = CharArray(1024)
        try {
            val reader = BufferedReader(InputStreamReader(inputStream, "UTF-8"))
            var pointer: Int
            do {
                pointer = reader.read(buffer)
                if (pointer != -1){
                    writer.write(buffer, 0, pointer)
                }else {
                    break
                }
            }
            while (true)
        } catch (exception: IOException) {
            Log.e(MainActivity.TAG, "Error writing/reading from the JSON file.", exception)
        } finally {
            try {
                inputStream.close()
            } catch (exception: IOException) {
                Log.e(MainActivity.TAG, "Error closing the input stream.", exception)
            }

        }
        val jsonProductsString = writer.toString()
        val gson = Gson()
        val productListType =
            object : TypeToken<ArrayList<DishModel>>() {

            }.type
        this.dishList = gson.fromJson<ArrayList<DishModel>>(
            jsonProductsString,
            productListType
        )
    }

    fun logout(onSuccess : (Boolean) -> Unit) {
        serviceRetrofit.logout(TOKEN_ACCESS)
            .enqueue(object : Callback<BaseResponse>{
                override fun onFailure(call: Call<BaseResponse>, t: Throwable) {
                    t.message?.let { ToastUtil().showToast(it) }
                    onSuccess(false)
                }

                override fun onResponse(
                    call: Call<BaseResponse>,
                    response: Response<BaseResponse>
                ) {
                    val repo = response.body()
                    if (repo != null && response.code() == 200){
                        onSuccess(true)
                    }else{
                        onSuccess(false)
                    }
                }
            })
    }
}