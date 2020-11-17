package com.uit.party.ui.main.history_book

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import com.uit.party.data.PartyBookingDatabase
import com.uit.party.data.history_order.HistoryOrderRepository
import com.uit.party.util.getNetworkService

/**
 * ViewModel provider factory to instantiate LoginViewModel.
 * Required given LoginViewModel has a non-empty constructor
 */
class HistoryBookingViewModelFactory(private val database: PartyBookingDatabase) : ViewModelProvider.Factory {

    @Suppress("UNCHECKED_CAST")
    override fun <T : ViewModel> create(modelClass: Class<T>): T {
        if (modelClass.isAssignableFrom(HistoryBookingViewModel::class.java)) {
            val network = getNetworkService()
            return HistoryBookingViewModel(
                    HistoryOrderRepository(network, database)
            ) as T
        }
        throw IllegalArgumentException("Unknown ViewModel class")
    }
}