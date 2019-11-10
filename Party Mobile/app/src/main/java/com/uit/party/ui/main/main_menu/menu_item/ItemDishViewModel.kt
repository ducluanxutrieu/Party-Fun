package com.uit.party.ui.main.main_menu.menu_item

import android.widget.Toast
import androidx.databinding.BaseObservable
import androidx.databinding.ObservableField
import com.uit.party.model.DishModel
import com.uit.party.util.GlobalApplication
import com.uit.party.util.rxbus.RxBus
import com.uit.party.util.rxbus.RxEvent

class ItemDishViewModel : BaseObservable(){
    var imageDish = ObservableField<String>()
    var priceDish = ObservableField<String>()
    var nameDish = ObservableField<String>()
    private lateinit var mDishModel: DishModel

    fun init(dishModel: DishModel){
        imageDish.set(dishModel.image?.get(0))
        priceDish.set(dishModel.price.toString())
        nameDish.set(dishModel.name)
        mDishModel = dishModel
    }

    fun onAddCartClicked(){
        RxBus.publish(RxEvent.AddToCart(mDishModel))
    }
}