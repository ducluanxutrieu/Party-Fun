package com.uit.party.ui.main.list_dish

import android.widget.Toast
import androidx.databinding.BaseObservable
import androidx.databinding.ObservableField
import com.uit.party.ui.main.list_dish.DishModel
import com.uit.party.util.GlobalApplication

class ItemDishViewModel : BaseObservable(){
    var imageDish = ObservableField<String>()
    var priceDish = ObservableField<String>()
    var nameDish = ObservableField<String>()

    fun init(dishModel: DishModel){
        imageDish.set(dishModel.url)
        priceDish.set(dishModel.price)
        nameDish.set(dishModel.title)
    }

    fun onAddCartClicked(){
        Toast.makeText(GlobalApplication.appContext, "Add to cart clicked", Toast.LENGTH_SHORT).show()
    }
}