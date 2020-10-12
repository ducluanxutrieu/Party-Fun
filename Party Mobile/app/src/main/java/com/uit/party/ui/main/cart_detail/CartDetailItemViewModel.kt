package com.uit.party.ui.main.cart_detail

import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel
import com.uit.party.model.DishModel

class CartDetailItemViewModel : ViewModel(){
    val mAvatarDish = ObservableField("")
    val mNameDish = ObservableField("")
    val mNumberDishInType = ObservableField("1")
    val mDishPrice = ObservableField("0 Đ")

    fun initItemData(dishModel: DishModel) {
        mNumberDishInType.set(dishModel.quantity.toString())
        mNameDish.set(dishModel.name)
        mAvatarDish.set(dishModel.image[0])
        mDishPrice.set(dishModel.price + " Đ")
    }
}