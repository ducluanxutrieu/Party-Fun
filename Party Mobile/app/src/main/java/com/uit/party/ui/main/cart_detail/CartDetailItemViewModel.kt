package com.uit.party.ui.main.cart_detail

import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel
import com.uit.party.model.CartModel

class CartDetailItemViewModel : ViewModel(){
    val mAvatarDish = ObservableField("")
    val mNameDish = ObservableField("")
    val mNumberDishInType = ObservableField("1")

    fun initItemData(cartModel: CartModel) {
        mNumberDishInType.set(cartModel.numberDish.toString())
        mNameDish.set(cartModel.dishModel.name)
        mAvatarDish.set(cartModel.dishModel.image?.get(0))
    }
}