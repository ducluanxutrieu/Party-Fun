package com.uit.party.util.rxbus

import android.view.View
import com.uit.party.model.DishModel

class RxEvent {
    //   class ChangeInfo(var user: LoginModel?)
    class AddToCart(val dishModel: DishModel, val cardDish: View?)

    class AddDish(val dishModel: DishModel?, val dishType: String, val position: Int)
}