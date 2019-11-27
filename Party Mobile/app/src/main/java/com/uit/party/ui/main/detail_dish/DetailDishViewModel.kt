package com.uit.party.ui.main.detail_dish

import android.content.DialogInterface
import android.view.View
import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import androidx.databinding.ObservableField
import androidx.databinding.library.baseAdapters.BR
import androidx.navigation.findNavController
import com.uit.party.R
import com.uit.party.model.BaseResponse
import com.uit.party.model.DishModel
import com.uit.party.ui.main.MainActivity.Companion.TOKEN_ACCESS
import com.uit.party.ui.main.MainActivity.Companion.serviceRetrofit
import com.uit.party.util.StringUtil
import com.uit.party.util.ToastUtil
import com.uit.party.util.rxbus.RxBus
import com.uit.party.util.rxbus.RxEvent
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class DetailDishViewModel : BaseObservable(){
    var imageDish = ObservableField<String>()
    var priceDish = ObservableField<String>()
    var nameDish = ObservableField<String>()
    var descriptionDish = ObservableField<String>()
    val mAdapter = DishDetailAdapter()
    var mDishModel: DishModel? = null

    @get: Bindable
    var listImages = ArrayList<String>()
        private set(value) {
            field = value
            notifyPropertyChanged(BR.listImages)
        }

    fun init(dishModel: DishModel){
        imageDish.set(dishModel.image?.get(0))
        priceDish.set(dishModel.price.toString())
        nameDish.set(dishModel.name)
        descriptionDish.set(dishModel.description)
        if (dishModel.image != null)  listImages = dishModel.image
        mDishModel = dishModel
    }

    fun addToCartClicked(){
        RxBus.publish(RxEvent.AddToCart(mDishModel!!, null))
    }

    fun deleteDish(view: View, dialog: DialogInterface) {
        val map = HashMap<String, String>()
        map["_id"] = mDishModel?._id.toString()
        serviceRetrofit.deleteDish(TOKEN_ACCESS, map)
            .enqueue(object : Callback<BaseResponse>{
                override fun onFailure(call: Call<BaseResponse>, t: Throwable) {
                    t.message?.let { ToastUtil.showToast(it) }
                    dialog.dismiss()
                }

                override fun onResponse(
                    call: Call<BaseResponse>,
                    response: Response<BaseResponse>
                ) {
                    if (response.code() == 200){
                        response.body()?.message?.let { ToastUtil.showToast(it) }
                        view.findNavController().popBackStack()
                        dialog.dismiss()
                    }else{
                        ToastUtil.showToast(StringUtil.getString(R.string.delete_dish))
                        dialog.dismiss()
                    }
                }
            })
    }
}