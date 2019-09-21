package com.uit.party.ui.main

import androidx.databinding.BaseObservable
import androidx.databinding.ObservableField

class ItemDishViewModel : BaseObservable(){
    var imageDish = ObservableField<String>()
    var priceDish = ObservableField<String>()
    var nameDish = ObservableField<String>()

    fun init(dishModel: DishModel){
        imageDish.set(dishModel.url)
        priceDish.set(dishModel.price)
        nameDish.set(dishModel.title)
    }
}