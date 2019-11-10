package com.uit.party.ui.main.main_menu

import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import androidx.databinding.ObservableField
import androidx.databinding.library.baseAdapters.BR
import com.uit.party.model.DishModel
import com.uit.party.model.MenuModel
import com.uit.party.ui.main.main_menu.menu_item.DishesAdapter

class ItemMenuViewModel : BaseObservable(){
    lateinit var mDishesAdapter: DishesAdapter
    val mTypeMenuField = ObservableField("")

    @get: Bindable
    var dishList = ArrayList<DishModel>()
        private set(value) {
            field = value
            notifyPropertyChanged(BR.dishList)
        }

    fun init(menuModel: MenuModel) {
        mDishesAdapter = DishesAdapter()
        mDishesAdapter.setDishesType(menuModel.menuName)
        dishList = menuModel.listDish
        mTypeMenuField.set(menuModel.menuName)
    }
}