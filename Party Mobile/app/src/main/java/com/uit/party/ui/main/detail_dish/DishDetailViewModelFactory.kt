package com.uit.party.ui.main.detail_dish

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.uit.party.data.home.HomeRepository
import com.uit.party.data.PartyBookingDatabase
import com.uit.party.data.cart.CartRepository
import com.uit.party.data.rate.RateRepository
import com.uit.party.util.getNetworkService

/**
 * ViewModel provider factory to instantiate LoginViewModel.
 * Required given LoginViewModel has a non-empty constructor
 */
class DishDetailViewModelFactory(private val database: PartyBookingDatabase) : ViewModelProvider.Factory {

    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(DetailDishViewModel::class.java)) {
            val network = getNetworkService()
            return DetailDishViewModel(
                    HomeRepository(network, database), RateRepository(network, database), CartRepository(network, database)
            ) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}