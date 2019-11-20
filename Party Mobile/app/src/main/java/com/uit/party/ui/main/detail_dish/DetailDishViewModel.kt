package com.uit.party.ui.main.detail_dish

import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel
import com.uit.party.model.DishModel

class DetailDishViewModel : ViewModel(){
    var imageDish = ObservableField<String>()
    var priceDish = ObservableField<String>()
    var nameDish = ObservableField<String>()
    var descriptionDish = ObservableField<String>()

    fun init(dishModel: DishModel){
        imageDish.set(dishModel.image?.get(0))
        priceDish.set(dishModel.price.toString())
        nameDish.set(dishModel.name)
        descriptionDish.set(dishModel.description)
    }

    fun addToCartClicked(){

    }
}