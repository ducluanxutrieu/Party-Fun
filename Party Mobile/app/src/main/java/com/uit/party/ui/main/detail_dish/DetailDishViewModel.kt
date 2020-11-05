package com.uit.party.ui.main.detail_dish

import android.content.DialogInterface
import android.view.View
import androidx.databinding.ObservableField
import androidx.databinding.ObservableFloat
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.findNavController
import androidx.paging.PagingData
import androidx.paging.cachedIn
import com.uit.party.data.CusResult
import com.uit.party.data.home.HomeRepository
import com.uit.party.model.CartModel
import com.uit.party.model.DishModel
import com.uit.party.model.RateModel
import com.uit.party.model.RequestRatingModel
import com.uit.party.util.UiUtil
import com.uit.party.util.UiUtil.toVNCurrency
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.launch

class DetailDishViewModel(private val repository: HomeRepository) : ViewModel() {
    var imageDish = ObservableField<String>()
    var priceDish = ObservableField<String>()
    var nameDish = ObservableField<String>()
    var descriptionDish = ObservableField<String>()
    val mRatingShow = ObservableFloat(5f)
    val mPrice = ObservableField("")
    val mAdapter = DishDetailAdapter()
    var mDishModel: DishModel? = null
    var mPosition: Int = 0
    lateinit var mDishType: String

    private var listImages = ArrayList<String>()
    private var currentListDishRateResult: Flow<PagingData<RateModel>>? = null


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

    fun onSubmitClicked(content: String, score: Float) {
        val requestModel =
            RequestRatingModel(mDishModel?.id, score.toDouble(), content)
        viewModelScope.launch {
            try {
                val result = repository.requestRatingDish(requestModel)
                if (result is CusResult.Success){
                    result.data.message?.let { UiUtil.showToast(it) }
                }else {
                    UiUtil.showToast ((result as CusResult.Error).exception.toString())
                }
            }catch (ex: Exception){
                ex.message?.let { UiUtil.showToast(it) }
            }
        }
    }

    fun getListRating(dishId: String): Flow<PagingData<RateModel>>{
        val newResult: Flow<PagingData<RateModel>> = repository.getDishRating(dishId)
            .cachedIn(viewModelScope)
        currentListDishRateResult = newResult
        return newResult
    }

/*    fun getItemDish() {
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
    }*/

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