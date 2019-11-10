package com.uit.party.ui.main.cart_detail

import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import androidx.databinding.library.baseAdapters.BR
import com.uit.party.model.CartModel
import com.uit.party.model.DishModel

class CartDetailViewModel : BaseObservable(){
    @get: Bindable
    var mListCart = ArrayList<CartModel>()
        private set(value) {
            field = value
            notifyPropertyChanged(BR.mListCart)
        }

    fun initData(listDishModel: ArrayList<DishModel>){
        for (dish in listDishModel) {
            var doubleCart = false
            for (cart in mListCart) {
                if (cart.dishModel._id == dish._id){
                    cart.numberDish ++
                    doubleCart = true
                    break
                }
            }

            if (!doubleCart){
                mListCart.add(CartModel(1, dish))
            }
        }
    }
}