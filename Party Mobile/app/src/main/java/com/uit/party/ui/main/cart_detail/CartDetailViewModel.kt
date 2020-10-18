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
    val mShowLoading = ObservableBoolean(false)
    val mTotalPrice = ObservableField("")
    val mNumberTableField = ObservableField("1")
    val mDatePartyField = ObservableField("")
    private var mNumberTable = 1

    private var calDatePartyPicker = Calendar.getInstance()
    private val calDateNow = Calendar.getInstance()

    val listCart = repository.listCart
    var listCartStorage = emptyList<CartModel>()

    private val datePartySetListener =
        DatePickerDialog.OnDateSetListener { view, year, monthOfYear, dayOfMonth ->
            setTimePicker(view.context)
            calDatePartyPicker.set(Calendar.YEAR, year)
            calDatePartyPicker.set(Calendar.MONTH, monthOfYear)
            calDatePartyPicker.set(Calendar.DAY_OF_MONTH, dayOfMonth)
        }

    init {
        val time = Calendar.getInstance()
        time.add(Calendar.DATE, 1)
        val timeStart = TimeFormatUtil.formatTimeToClient(time)
        mDatePartyField.set(timeStart)
    }

    private fun setTimePicker(context: Context){
        val timeSetListener = TimePickerDialog.OnTimeSetListener { _, hour, minute ->
            calDatePartyPicker.set(Calendar.HOUR_OF_DAY, hour)
            calDatePartyPicker.set(Calendar.MINUTE, minute)
            if (calDatePartyPicker <= calDateNow){
                UiUtil.showToast(UiUtil.getString(R.string.date_booking_must_greater_than_day_now))
            }else{
                updateDatePartyInView()
            }
        }
        TimePickerDialog(
            context,
            timeSetListener,
            calDatePartyPicker.get(Calendar.HOUR_OF_DAY),
            calDatePartyPicker.get(Calendar.MINUTE),
            true
        ).show()
    }

    private fun calculateTotalPrice(): Int {
        var totalPrice = 0
        for (row in listCartStorage) {
            totalPrice += (row.quantity * (row.newPrice?.toInt() ?: 0))
        }
        return totalPrice * mNumberTable
    }

    private fun updateDatePartyInView() {
        val timeStart = TimeFormatUtil.formatTimeToClient(calDatePartyPicker)
        mDatePartyField.set(timeStart)
    }

    fun onDatePartyClicked(view: View) {
        DatePickerDialog(
            view.context,
            datePartySetListener,
            calDatePartyPicker.get(Calendar.YEAR),
            calDatePartyPicker.get(Calendar.MONTH),
            calDatePartyPicker.get(Calendar.DAY_OF_MONTH)
        ).show()
    }

    fun getNumberTableTextChanged(): TextWatcher {
        return object : TextWatcher {
            override fun afterTextChanged(editable: Editable?) {
                checkNumberTableValid(editable)
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }
        }
    }

    private fun checkNumberTableValid(editable: Editable?) {
        mNumberTable = when {
            editable.isNullOrEmpty() -> {
                mNumberTableField.set("1")
                1
            }
            editable.toString().toInt() < 1 -> {
                mNumberTableField.set("1")
                1
            }
            else -> {
                editable.toString().toInt()
            }
        }

        setTotalPrice()
    }

    fun setTotalPrice(){
        val totalPrice = calculateTotalPrice()
        mTotalPrice.set(totalPrice.toString().toVNCurrency())
    }

    fun onOrderNowClicked(view: View){
        mShowLoading.set(true)
        val mListDishes = ArrayList<ListDishes>()
        for (row in listCart.value ?: emptyList()){
            if (row.id.isNotEmpty())
                mListDishes.add(
                    ListDishes(
                        row.quantity.toString(), row.id
                    )
                )
        }

        val bookModel = RequestOrderPartyModel(
            TimeFormatUtil.formatTimeToServer(calDatePartyPicker),
            mNumberTable.toString(),
            mListDishes
        )
        getNetworkService().bookParty(getToken(), bookModel)
            .enqueue(object : Callback<BillModel> {
                override fun onFailure(call: Call<BillModel>, t: Throwable) {
                    t.message?.let { UiUtil.showToast(it) }
                    mShowLoading.set(false)
                }

                override fun onResponse(call: Call<BillModel>, response: Response<BillModel>) {
                    mShowLoading.set(false)
                    if (response.isSuccessful) {
                        response.body()?.message?.let { UiUtil.showToast(it) }
                        view.findNavController()
                            .navigate(R.id.action_CartDetailFragment_to_BookingSuccessFragment)
                    } else {
                        UiUtil.showToast(response.message())
                    }
                }
            })
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