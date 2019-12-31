package com.uit.party.ui.main.main_menu.menu_item

import androidx.databinding.BaseObservable
import androidx.databinding.ObservableField
import com.uit.party.model.DishModel
import java.text.NumberFormat
import java.util.*

class ItemDishViewModel : BaseObservable(){
    var imageDish = ObservableField<String>()
    var priceDish = ObservableField<String>()
    var nameDish = ObservableField<String>()
    private lateinit var mDishModel: DishModel

    fun init(dishModel: DishModel){
        val formatter = NumberFormat.getNumberInstance(Locale("vi"))
//        formatter.maximumFractionDigits = 0
//        formatter.currency = Currency.getInstance("VND")
        imageDish.set(dishModel.image?.get(0))
        priceDish.set(formatter.format(dishModel.price?.toDouble()) + " Đ")
        nameDish.set(dishModel.name)
        mDishModel = dishModel
    }
}