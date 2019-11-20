package com.uit.party.util

import android.app.Application
import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import com.google.gson.Gson
import android.util.Log
import android.view.View


class GlobalApplication : Application(){
    private val mGSon = Gson()
    override fun onCreate() {
        super.onCreate()
        appContext = applicationContext
    }

    companion object{
        var appContext: Context? = null
            private set
    }

    fun getGSon(): Gson {
        return mGSon
    }

    fun loadBitmapFromView(view: View, width: Int, height: Int): Bitmap {
        val returnedBitmap = Bitmap.createBitmap(view.width, view.height, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(returnedBitmap)
        val bgDrawable = view.background
        if (bgDrawable != null)
            bgDrawable.draw(canvas)
        else
            canvas.drawColor(Color.WHITE)
        view.draw(canvas)

        Log.e("width", "=$width")
        Log.e("height", "=$height")
        return returnedBitmap
    }
}