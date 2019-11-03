package com.uit.party.ui.main.main_menu

import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import androidx.databinding.ObservableField
import androidx.databinding.library.baseAdapters.BR
import com.uit.party.model.DishModel
import com.uit.party.model.MenuModel
import com.uit.party.ui.main.main_menu.menu_item.DishesAdapter
import com.uit.party.util.ToastUtil

class ItemMenuViewModel : BaseObservable(), DishesAdapter.DishItemOnClicked{
    lateinit var mDishesAdapter: DishesAdapter
    val mTypeMenuField = ObservableField("")

    @get: Bindable
    var dishList = ArrayList<DishModel>()
        private set(value) {
            field = value
            notifyPropertyChanged(BR.dishList)
        }

    fun init(menuModel: MenuModel) {
        mDishesAdapter = DishesAdapter(this)
        mDishesAdapter.setDishesType(menuModel.menuName)
        dishList = menuModel.listDish
        mTypeMenuField.set(menuModel.menuName)
    }

    override fun onItemDishClicked(dishType: String ,position: Int, item: DishModel) {
        item.name?.let { ToastUtil().showToast(it) }
    }
}