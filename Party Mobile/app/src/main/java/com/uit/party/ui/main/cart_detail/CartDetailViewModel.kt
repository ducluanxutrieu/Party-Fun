package com.uit.party.ui.main.cart_detail

import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.content.Context
import android.text.Editable
import android.text.TextWatcher
import android.view.View
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.findNavController
import com.uit.party.R
import com.uit.party.data.getToken
import com.uit.party.data.home.HomeRepository
import com.uit.party.model.BillModel
import com.uit.party.model.CartModel
import com.uit.party.model.ListDishes
import com.uit.party.model.RequestOrderPartyModel
import com.uit.party.util.TimeFormatUtil
import com.uit.party.util.UiUtil
import com.uit.party.util.UiUtil.toVNCurrency
import com.uit.party.util.getNetworkService
import kotlinx.coroutines.launch
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.util.*
import kotlin.collections.ArrayList

class CartDetailViewModel(private val repository: HomeRepository) : ViewModel(){
    val mShowCart = ObservableBoolean(false)

    val listCart = repository.listCart

    fun onOrderNowClicked(view: View){
        view.findNavController().navigate(R.id.action_CartDetailFragment_to_BookingSuccessFragment)
    }

    fun changeQuantityCart(cartModel: CartModel) {
        viewModelScope.launch {
            try {
                repository.updateCart(cartModel)
            }catch (e: Exception){
                e.message?.let { UiUtil.showToast(it) }
            }
        }
    }

    fun onDeleteItemCart(cartModel: CartModel) {
        viewModelScope.launch {
            try {
                repository.deleteCart(cartModel)
            }catch (e: Exception){
                e.message?.let { UiUtil.showToast(it) }
            }
        }
    }

    fun insertCart(cartModel: CartModel) {
        viewModelScope.launch {
            try {
                repository.insertCart(cartModel)
            }catch (e: Exception){
                e.message?.let { UiUtil.showToast(it) }
            }
        }
    }
}