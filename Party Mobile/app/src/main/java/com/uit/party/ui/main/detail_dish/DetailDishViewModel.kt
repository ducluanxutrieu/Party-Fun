package com.uit.party.ui.main.detail_dish

import android.content.DialogInterface
import android.view.View
import androidx.databinding.ObservableField
import androidx.databinding.ObservableFloat
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.findNavController
import com.uit.party.data.CusResult
import com.uit.party.data.home.HomeRepository
import com.uit.party.model.*
import com.uit.party.ui.main.MainActivity.Companion.TOKEN_ACCESS
import com.uit.party.util.UiUtil
import com.uit.party.util.UiUtil.toVNCurrency
import com.uit.party.util.getNetworkService
import kotlinx.coroutines.launch
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class DetailDishViewModel(private val repository: HomeRepository) : ViewModel() {
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

    var mListRates = ArrayList<ListRate>()

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
        mPrice.set(mDishModel?.price.toVNCurrency())
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
                    t.message?.let { UiUtil.showToast(it) }
                }

                override fun onResponse(
                    call: Call<BaseResponse>,
                    response: Response<BaseResponse>
                ) {
                    if (response.code() == 200) {
                        response.body()?.message?.let { UiUtil.showToast(it) }
                        getItemDish()
                    } else {
                        UiUtil.showToast(response.message())
                    }
                }
            })
    }

    fun getItemDish() {
        val id = mDishModel?.id ?: ""
        if (id.isNotEmpty())
        viewModelScope.launch {
            try {
                val result = repository.getItemDish(id)
                if (result is CusResult.Success){
                    mDishModel = result.data
                }else {
                    UiUtil.showToast((result as? CusResult.Error).toString())
                }
            }catch (ex: Exception){
                ex.message?.let { UiUtil.showToast(it) }
            }
        }
    }

    fun deleteDish(view: View, dialog: DialogInterface) {
       val id = mDishModel?.id ?: ""
        if (id.isNotEmpty())
        viewModelScope.launch {
             try {
                 val result = repository.deleteDish(id)
                 if (result is CusResult.Success){
                     result.data.message?.let { UiUtil.showToast(it) }
                     view.findNavController().popBackStack()
                     dialog.dismiss()
                 }
             }catch (ex: Exception){
                 ex.message?.let { UiUtil.showToast(it) }
                 dialog.dismiss()
             }
        }
    }

    fun addToCart() {
        val dishModel = mDishModel
        if (dishModel != null)
            viewModelScope.launch {
                repository.insertCart(
                    CartModel(
                        id = dishModel.id,
                        name = dishModel.name,
                        featureImage = dishModel.featureImage,
                        quantity = 1,
                        newPrice = dishModel.newPrice,
                        price = dishModel.price
                    )
                )
            }
    }
}