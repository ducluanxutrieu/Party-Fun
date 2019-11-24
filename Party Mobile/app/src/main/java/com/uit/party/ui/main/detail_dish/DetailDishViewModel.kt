package com.uit.party.ui.main.detail_dish

import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import androidx.databinding.ObservableField
import androidx.databinding.library.baseAdapters.BR
import com.uit.party.model.DishModel
import com.uit.party.util.rxbus.RxBus
import com.uit.party.util.rxbus.RxEvent

class DetailDishViewModel : BaseObservable(){
    var imageDish = ObservableField<String>()
    var priceDish = ObservableField<String>()
    var nameDish = ObservableField<String>()
    var descriptionDish = ObservableField<String>()
    val mAdapter = DishDetailAdapter()
    private lateinit var mDishModel: DishModel

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
        RxBus.publish(RxEvent.AddToCart(mDishModel, null))
    }
}