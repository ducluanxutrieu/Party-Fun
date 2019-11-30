package com.uit.party.ui.main.detail_dish

import android.content.DialogInterface
import android.view.View
import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import androidx.databinding.ObservableField
import androidx.databinding.ObservableFloat
import androidx.databinding.library.baseAdapters.BR
import androidx.navigation.findNavController
import com.uit.party.R
import com.uit.party.model.*
import com.uit.party.ui.main.MainActivity.Companion.TOKEN_ACCESS
import com.uit.party.ui.main.MainActivity.Companion.serviceRetrofit
import com.uit.party.ui.signin.login.LoginViewModel.Companion.USER_INFO_KEY
import com.uit.party.util.SharedPrefs
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
    val mCommentRating = ObservableField("")
    val mRating = ObservableFloat(5f)
    val mRatingShow = ObservableFloat(5f)
    val mPrice = ObservableField("")
    val mAdapter = DishDetailAdapter()
    val mRatingAdapter = DishRatingAdapter()
    var mDishModel: DishModel? = null

    var listImages = ArrayList<String>()

    @get: Bindable
    var mListRates = ArrayList<ListRate>()
        private set(value) {
            field = value
            notifyPropertyChanged(BR.mListRates)
        }

    fun init(dishModel: DishModel){
        imageDish.set(dishModel.image?.get(0))
        priceDish.set(dishModel.price.toString())
        nameDish.set(dishModel.name)
        descriptionDish.set(dishModel.description)
        if (dishModel.image != null)  listImages = dishModel.image
        mAdapter.setData(listImages)
        mPrice.set("Price: ${dishModel.price} VND")
        dishModel.rate?.average?.let { mRatingShow.set(it) }
        mListRates = dishModel.rate?.listRates ?: ArrayList()
        setRatingContent()
        mDishModel = dishModel
    }

    private fun setRatingContent() {
        val account = SharedPrefs()[USER_INFO_KEY, Account::class.java]
        for (row in mListRates){
            if (row.username == account?.username){
                row.scorerate?.let { mRating.set(it) }
                mCommentRating.set(row.content)
                break
            }
        }
    }

    fun addToCartClicked(){
        RxBus.publish(RxEvent.AddToCart(mDishModel!!, null))
    }

    fun onSubmitClicked(){
        val requestModel = RequestRatingModel(mDishModel?._id, mRating.get().toDouble(), mCommentRating.get())
        serviceRetrofit.ratingDish(TOKEN_ACCESS, requestModel)
            .enqueue(object : Callback<BaseResponse>{
                override fun onFailure(call: Call<BaseResponse>, t: Throwable) {
                    t.message?.let { ToastUtil.showToast(it) }
                }

                override fun onResponse(
                    call: Call<BaseResponse>,
                    response: Response<BaseResponse>
                ) {
                    if (response.code() == 200){
                        response.body()?.message?.let { ToastUtil.showToast(it) }
                    }else{
                        ToastUtil.showToast(response.message())
                    }
                }
            })
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