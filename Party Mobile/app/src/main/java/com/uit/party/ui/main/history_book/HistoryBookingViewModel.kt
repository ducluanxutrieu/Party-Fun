package com.uit.party.ui.main.history_book

import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import androidx.databinding.ObservableBoolean
import androidx.databinding.library.baseAdapters.BR
import com.uit.party.data.GetData.getUserProfile
import com.uit.party.model.UserCart

class HistoryBookingViewModel : BaseObservable(){
    val mShowLoading = ObservableBoolean(false)
    @get: Bindable
    var mListOrdered = ArrayList<UserCart>()
    private set(value) {
        field = value
        notifyPropertyChanged(BR.mListOrdered)
    }

    val mListUserCardAdapter = UserCardAdapter()

    init {
        mShowLoading.set(true)
        getUserProfile{account ->
            mShowLoading.set(false)
            if (account?.userCart != null){
                mListOrdered = account.userCart!!
            }
        }
    }

}