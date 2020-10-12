package com.uit.party.ui.main.cart_detail

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.uit.party.data.home.HomeRepository
import com.uit.party.data.home.PartyBookingDatabase
import com.uit.party.util.getNetworkService

/**
 * ViewModel provider factory to instantiate LoginViewModel.
 * Required given LoginViewModel has a non-empty constructor
 */
class CartDetailViewModelFactory(private val database: PartyBookingDatabase) : ViewModelProvider.Factory {

    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(CartDetailViewModel::class.java)) {
            return CartDetailViewModel(
                    HomeRepository(getNetworkService(), database.homeDao)
            ) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}