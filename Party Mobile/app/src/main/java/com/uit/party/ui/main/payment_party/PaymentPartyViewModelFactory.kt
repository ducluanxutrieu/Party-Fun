package com.uit.party.ui.main.payment_party

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.uit.party.data.PartyBookingDatabase
import com.uit.party.data.cart.CartDao
import com.uit.party.data.cart.CartRepository
import com.uit.party.util.getNetworkService

/**
 * ViewModel provider factory to instantiate LoginViewModel.
 * Required given LoginViewModel has a non-empty constructor
 */
class PaymentPartyViewModelFactory(private val database: PartyBookingDatabase) : ViewModelProvider.Factory {

    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(PaymentPartyViewModel::class.java)) {
            return PaymentPartyViewModel(
                    CartRepository(getNetworkService(), database)
            ) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}