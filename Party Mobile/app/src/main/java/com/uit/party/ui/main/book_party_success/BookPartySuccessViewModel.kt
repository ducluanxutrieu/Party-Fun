package com.uit.party.ui.main.book_party_success

import android.view.View
import androidx.lifecycle.ViewModel
import androidx.navigation.findNavController
import com.uit.party.R

class BookPartySuccessViewModel :ViewModel(){

    fun onBackMenuClicked(view: View){
        view.findNavController().navigate(R.id.action_BookingSuccessFragment_to_MenuFragment)
    }
}