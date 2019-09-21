package com.uit.party.ui.main

import android.util.Log
import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import androidx.databinding.library.baseAdapters.BR
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.uit.party.R
import com.uit.party.ui.main.MainActivity.Companion.TAG
import com.uit.party.util.GlobalApplication
import java.io.BufferedReader
import java.io.IOException
import java.io.InputStreamReader
import java.io.StringWriter

class MainViewModel : BaseObservable(){
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
            Log.e(TAG, "Error writing/reading from the JSON file.", exception)
        } finally {
            try {
                inputStream.close()
            } catch (exception: IOException) {
                Log.e(TAG, "Error closing the input stream.", exception)
            }

        }
        val jsonProductsString = writer.toString()
        val gson = Gson()
        val productListType =
            object : TypeToken<ArrayList<DishModel>>() {

            }.type
        this.dishList = gson.fromJson<ArrayList< DishModel>>(
            jsonProductsString,
            productListType
        )
    }
}