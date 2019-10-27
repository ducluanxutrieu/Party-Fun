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
        var imageUrl = dishModel.image?.get(0)
        if (!imageUrl.isNullOrEmpty())
            imageUrl = imageUrl.replace("\\", "/", true)
        imageDish.set(imageUrl)
        priceDish.set(dishModel.price.toString())
        nameDish.set(dishModel.name)
        descriptionDish.set(dishModel.description)
    }

    fun addToCartClicked(){

    }
}