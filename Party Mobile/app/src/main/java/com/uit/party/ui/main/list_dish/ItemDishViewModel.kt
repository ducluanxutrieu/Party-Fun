package com.uit.party.ui.main.list_dish

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
        var imageUrl = dishModel.image?.get(0)
        if (!imageUrl.isNullOrEmpty())
            imageUrl = imageUrl.replace("\\", "/", true)
        imageDish.set(imageUrl)
        priceDish.set(dishModel.price.toString())
        nameDish.set(dishModel.name)
    }

    fun onAddCartClicked(){
        Toast.makeText(GlobalApplication.appContext, "Add to cart clicked", Toast.LENGTH_SHORT).show()
    }
}