package com.uit.party.ui.main.history_book

import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import androidx.databinding.ObservableBoolean
import androidx.databinding.library.baseAdapters.BR
import com.uit.party.data.GetData.getHistoryBooking
import com.uit.party.data.history_order.CartItem

class HistoryBookingViewModel : BaseObservable(){
    val mShowLoading = ObservableBoolean(false)
    @get: Bindable
    var mListOrdered = ArrayList<CartItem>()
    private set(value) {
        field = value
        notifyPropertyChanged(BR.mListOrdered)
    }

    val mListUserCardAdapter = UserCardAdapter()

    init {
        mShowLoading.set(true)
        getHistoryBooking{historyBooking ->
            mShowLoading.set(false)
            if (historyBooking?.cartItems != null){
                mListOrdered = historyBooking.cartItems
            }
        }
    }

}