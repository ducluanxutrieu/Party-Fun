package com.uit.party.ui.main.main_menu.menu_item

import android.widget.Toast
import androidx.databinding.BaseObservable
import androidx.databinding.ObservableField
import com.uit.party.model.DishModel
import com.uit.party.util.GlobalApplication

class ItemDishViewModel : BaseObservable(){
    var imageDish = ObservableField<String>()
    var priceDish = ObservableField<String>()
    var nameDish = ObservableField<String>()

    fun init(dishModel: DishModel){
        imageDish.set(dishModel.image?.get(0))
        priceDish.set(dishModel.price.toString())
        nameDish.set(dishModel.name)
    }

    fun onAddCartClicked(){
        Toast.makeText(GlobalApplication.appContext, "Add to cart clicked", Toast.LENGTH_SHORT).show()
    }
}