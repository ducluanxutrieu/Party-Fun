package com.uit.party.ui.main.cart_detail

import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import androidx.databinding.ObservableField
import androidx.databinding.library.baseAdapters.BR
import com.uit.party.model.CartModel
import com.uit.party.model.DishModel

class CartDetailViewModel : BaseObservable(), OnCartDetailListener {
    val mCartAdapter = CartDetailAdapter(this)
    val mTotalPrice = ObservableField("")

    @get: Bindable
    var mListCart = ArrayList<CartModel>()
        private set(value) {
            field = value
            notifyPropertyChanged(BR.mListCart)
        }

    override fun onChangeNumberDish(position: Int, cartModel: CartModel, isIncrease: Boolean) {
        mListCart[position] = cartModel
        mTotalPrice.set(calculateTotalPrice().toString() + "Đ")
    }

    override fun onDeleteDish(position: Int) {
        mListCart.removeAt(position)
        mTotalPrice.set(calculateTotalPrice().toString() + "Đ")
        mCartAdapter.notifyItemRemoved(position)
    }

    private fun calculateTotalPrice(): Int{
        var totalPrice = 0
        for (row in mListCart){
            totalPrice += (row.numberDish * (row.dishModel.price?.toInt() ?: 0))
        }
        return totalPrice
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

        mTotalPrice.set(calculateTotalPrice().toString() + "Đ")
    }
}