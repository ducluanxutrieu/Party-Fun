package com.uit.party.util.rxbus

import com.uit.party.model.DishModel

class RxEvent {
//   class ChangeInfo(var user: LoginModel?)
    class ShowItemDishDetail(val dishType: String ,val position: Int,val  dishModel: DishModel)
    class AddToCart(val dishModel: DishModel)
}