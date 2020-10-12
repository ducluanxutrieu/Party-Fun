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
import com.uit.party.data.home.HomeRepository
import com.uit.party.model.BillModel
import com.uit.party.model.DishModel
import com.uit.party.model.ListDishes
import com.uit.party.model.RequestOrderPartyModel
import com.uit.party.ui.main.MainActivity.Companion.TOKEN_ACCESS
import com.uit.party.util.StringUtil
import com.uit.party.util.TimeFormatUtil
import com.uit.party.util.ToastUtil
import com.uit.party.util.getNetworkService
import kotlinx.coroutines.launch
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.lang.Exception
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
            calDatePartyPicker.set(Calendar.HOUR_OF_DAY,hour)
            calDatePartyPicker.set(Calendar.MINUTE,minute)
            if (calDatePartyPicker <= calDateNow){
                ToastUtil.showToast(StringUtil.getString(R.string.date_booking_must_greater_than_day_now))
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

    fun calculateTotalPrice(): Int {
        var totalPrice = 0
        for (row in listCart.value ?: emptyList()) {
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

        mTotalPrice.set(calculateTotalPrice().toString() + "Đ")
    }

    fun onOrderNowClicked(view: View){
        mShowLoading.set(true)
        val mListDishes = ArrayList<ListDishes>()
        for (row in listCart.value ?: emptyList()){
            if (row.id.isNotEmpty())
                mListDishes.add(ListDishes(row.quantity.toString(), row.id
            ))
        }

        val bookModel = RequestOrderPartyModel(TimeFormatUtil.formatTimeToServer(calDatePartyPicker), mNumberTable.toString(), mListDishes)
        getNetworkService().bookParty(TOKEN_ACCESS, bookModel)
            .enqueue(object : Callback<BillModel>{
                override fun onFailure(call: Call<BillModel>, t: Throwable) {
                    t.message?.let { ToastUtil.showToast(it) }
                    mShowLoading.set(false)
                }

                override fun onResponse(call: Call<BillModel>, response: Response<BillModel>) {
                    mShowLoading.set(false)
                    if (response.isSuccessful){
                        response.body()?.message?.let { ToastUtil.showToast(it) }
                        view.findNavController().navigate(R.id.action_CartDetailFragment_to_BookingSuccessFragment)
                    }else{
                        ToastUtil.showToast(response.message())
                    }
                }
            })
    }

    fun changeNumberDish(dishModel: DishModel) {
        viewModelScope.launch {
            try {
                repository.updateCart(dishModel)
            }catch (e: Exception){
                e.message?.let { ToastUtil.showToast(it) }
            }
        }
    }

    fun onDeleteDish(dishModel: DishModel) {
        viewModelScope.launch {
            try {
                repository.deleteCart(dishModel)
            }catch (e: Exception){
                e.message?.let { ToastUtil.showToast(it) }
            }
        }
    }

    fun insertCart(dishModel: DishModel) {
        viewModelScope.launch {
            try {
                repository.insertCart(dishModel)
            }catch (e: Exception){
                e.message?.let { ToastUtil.showToast(it) }
            }
        }
    }
}