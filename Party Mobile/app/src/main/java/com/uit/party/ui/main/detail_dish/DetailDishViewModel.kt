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
import com.uit.party.util.StringUtil
import com.uit.party.util.ToastUtil
import com.uit.party.util.getNetworkService
import com.uit.party.util.rxbus.RxBus
import com.uit.party.util.rxbus.RxEvent
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class DetailDishViewModel : BaseObservable() {
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
    var mPosition: Int = 0
    lateinit var mDishType: String

    private var listImages = ArrayList<String>()

    @get: Bindable
    var mListRates = ArrayList<ListRate>()
        private set(value) {
            field = value
            notifyPropertyChanged(BR.mListRates)
        }

    fun init() {
        imageDish.set(mDishModel?.image?.get(0))
        priceDish.set(mDishModel?.price.toString())
        nameDish.set(mDishModel?.name)
        descriptionDish.set(mDishModel?.description)
        if (mDishModel?.image != null) {
            listImages.clear()
            listImages.addAll(mDishModel?.image!!)
        }
        mAdapter.setData(listImages)
        mPrice.set("Price: ${mDishModel?.price} VND")
        //TODO change rating
//        setRatingContent()
    }

    /*private fun setRatingContent() {
        mDishModel?.rate?.average?.let { mRatingShow.set(it) }
        mListRates = mDishModel?.rate?.listRates ?: ArrayList()
        val account = SharedPrefs()[USER_INFO_KEY, Account::class.java]
        for (row in mListRates) {
            if (row.username == account?.username) {
                row.scorerate?.let { mRating.set(it) }
                mCommentRating.set(row.content)
                break
            }
        }
    }*/

    fun onSubmitClicked() {
        val requestModel =
            RequestRatingModel(mDishModel?.id, mRating.get().toDouble(), mCommentRating.get())
        getNetworkService().ratingDish(TOKEN_ACCESS, requestModel)
            .enqueue(object : Callback<BaseResponse> {
                override fun onFailure(call: Call<BaseResponse>, t: Throwable) {
                    t.message?.let { ToastUtil.showToast(it) }
                }

                override fun onResponse(
                    call: Call<BaseResponse>,
                    response: Response<BaseResponse>
                ) {
                    if (response.code() == 200) {
                        response.body()?.message?.let { ToastUtil.showToast(it) }
                        getItemDish()
                    } else {
                        ToastUtil.showToast(response.message())
                    }
                }
            })
    }

    fun getItemDish() {
        val hashMap = HashMap<String, String?>()
        hashMap["_id"] = mDishModel?.id
        getNetworkService().getItemDish(hashMap)
            .enqueue(object : Callback<DishItemResponse> {
                override fun onFailure(call: Call<DishItemResponse>, t: Throwable) {
                    t.message?.let { ToastUtil.showToast(it) }
                }

                override fun onResponse(
                    call: Call<DishItemResponse>,
                    response: Response<DishItemResponse>
                ) {
                    if (response.code() == 200) {
                        val repo = response.body()
                        if (repo != null) {
                            mDishModel = repo.dish
                            //TODO change rating
//                            setRatingContent()
                            RxBus.publish(
                                RxEvent.AddDish(
                                    repo.dish,
                                    dishType = mDishType,
                                    position = mPosition
                                )
                            )
                        }
                    }
                }
            })
    }

    fun deleteDish(view: View, dialog: DialogInterface) {
        val map = HashMap<String, String>()
        map["_id"] = mDishModel?.id.toString()
        getNetworkService().deleteDish(TOKEN_ACCESS, map)
            .enqueue(object : Callback<BaseResponse> {
                override fun onFailure(call: Call<BaseResponse>, t: Throwable) {
                    t.message?.let { ToastUtil.showToast(it) }
                    dialog.dismiss()
                }

                override fun onResponse(
                    call: Call<BaseResponse>,
                    response: Response<BaseResponse>
                ) {
                    if (response.code() == 200) {
                        response.body()?.message?.let { ToastUtil.showToast(it) }
                        view.findNavController().popBackStack()
                        dialog.dismiss()
                    } else {
                        ToastUtil.showToast(StringUtil.getString(R.string.delete_dish))
                        dialog.dismiss()
                    }
                }
            })
    }
}