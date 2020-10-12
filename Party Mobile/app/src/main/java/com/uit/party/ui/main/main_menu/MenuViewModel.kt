package com.uit.party.ui.main.main_menu

import android.view.View
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableInt
import androidx.lifecycle.LiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.findNavController
import com.uit.party.data.CusResult
import com.uit.party.data.home.HomeRepository
import com.uit.party.model.DishModel
import com.uit.party.model.MenuModel
import com.uit.party.util.ToastUtil
import kotlinx.coroutines.launch

class MenuViewModel(private val repository: HomeRepository) : ViewModel(){
    val mShowFab = ObservableInt(View.GONE)
    val mShowLoading = ObservableBoolean(false)
    val mShowMenu = ObservableBoolean(false)

    val listMenu:LiveData<List<DishModel>> = repository.listMenu

    init {
        viewModelScope.launch {
            getListDishes()
        }
        setIsAdmin()
    }

    suspend fun getListDishes(){
        try {
            repository.getListDishes()
        }catch (error: Exception) {
            ToastUtil.showToast(error.message ?: "")
        }
    }

    suspend fun logout(){
        try {
            mShowLoading.set(true)
            repository.logout()
            mShowLoading.set(false)
        }catch (cause : Throwable){
            CusResult.Error(Exception(cause))
            mShowLoading.set(false)
        }
    }

    private fun setIsAdmin() {
        if (repository.checkAdmin()) {
            mShowFab.set(View.VISIBLE)
        }
    }

    fun onAddDishClicked(view: View){
        val action = MenuFragmentDirections.actionListDishToAddDish(0, "", null)
        view.findNavController().navigate(action)
    }

    fun menuAllocation(dishes: List<DishModel>): ArrayList<MenuModel> {
        val listMenu = ArrayList<MenuModel>()
        val listHolidayOffers = ArrayList<DishModel>()
        val listFirstDishes = ArrayList<DishModel>()
        val listMainDishes = ArrayList<DishModel>()
        val listSeafood = ArrayList<DishModel>()
        val listDrink = ArrayList<DishModel>()
        val listDessert = ArrayList<DishModel>()
        for (row in dishes) {
            when (row.categories[0]) {
                "Holiday Offers" -> listHolidayOffers.add(row)
                "First Dishes" -> listFirstDishes.add(row)
                "Main Dishes" -> listMainDishes.add(row)
                "Seafood" -> listSeafood.add(row)
                "Drinks" -> listDrink.add(row)
                "Dessert" -> listDessert.add(row)
            }
        }
        if (listHolidayOffers.size > 0) {
            listMenu.add(MenuModel("Holiday Offers", listHolidayOffers))
        }
        if (listFirstDishes.size > 0) {
            listMenu.add(MenuModel("First Dishes", listFirstDishes))
        }
        if (listMainDishes.size > 0) {
            listMenu.add(MenuModel("Main Dishes", listMainDishes))
        }
        if (listSeafood.size > 0) {
            listMenu.add(MenuModel("Seafood", listSeafood))
        }
        if (listDrink.size > 0) {
            listMenu.add(MenuModel("Drinks", listDrink))
        }

        if (listDessert.size > 0) {
            listMenu.add(MenuModel("Dessert", listDessert))
        }

        return listMenu
    }

    fun updateDish(dishModel: DishModel) {
        viewModelScope.launch {
            repository.updateDish(dishModel)
        }
    }
}