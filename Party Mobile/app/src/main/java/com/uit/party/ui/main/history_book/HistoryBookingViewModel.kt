package com.uit.party.ui.main.history_book

import androidx.databinding.ObservableBoolean
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.paging.PagingData
import androidx.paging.cachedIn
import com.uit.party.data.history_order.CartItem
import com.uit.party.data.history_order.HistoryOrderRepository
import kotlinx.coroutines.flow.Flow

class HistoryBookingViewModel(private val repository: HistoryOrderRepository) : ViewModel(){
    val mShowLoading = ObservableBoolean(false)
    private var currentListOrderedResult: Flow<PagingData<CartItem>>? = null

    fun getHistoryOrdered(): Flow<PagingData<CartItem>> {
        val newResult: Flow<PagingData<CartItem>> = repository.getListOrdered()
            .cachedIn(viewModelScope)
        currentListOrderedResult = newResult
        return newResult
    }
}