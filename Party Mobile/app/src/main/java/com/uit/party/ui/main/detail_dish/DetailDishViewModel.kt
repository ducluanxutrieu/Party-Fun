package com.uit.party.ui.main.detail_dish

import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel
import com.uit.party.ui.main.list_dish.DishModel

class DetailDishViewModel : ViewModel(){
    var imageDish = ObservableField<String>()
    var priceDish = ObservableField<String>()
    var nameDish = ObservableField<String>()
    var descriptionDish = ObservableField<String>()

    fun init(dishModel: DishModel){
        imageDish.set(dishModel.url)
        priceDish.set(dishModel.price)
        nameDish.set(dishModel.title)
        descriptionDish.set(dishModel.description)
    }

    fun addToCartClicked(){

    }
}