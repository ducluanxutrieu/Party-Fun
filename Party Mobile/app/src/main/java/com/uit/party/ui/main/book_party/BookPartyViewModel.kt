package com.uit.party.ui.main.book_party

import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.content.Context
import android.util.Log
import android.view.View
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableField
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import androidx.navigation.findNavController
import com.uit.party.R
import com.uit.party.data.CusResult
import com.uit.party.data.cart.CartRepository
import com.uit.party.model.CartModel
import com.uit.party.model.ListDishes
import com.uit.party.model.RequestOrderPartyModel
import com.uit.party.util.TimeFormatUtil
import com.uit.party.util.UiUtil
import com.uit.party.util.UiUtil.toVNCurrency
import kotlinx.coroutines.CoroutineExceptionHandler
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.util.*

class BookPartyViewModel(private val repository: CartRepository) : ViewModel() {
    val mTotalPrice = ObservableField("")
    val mDatePartyField = ObservableField("")
    val mDishCountCodeField = ObservableField("")
    val mShowLoading = ObservableBoolean(false)
    var mNumberTable = 5
    var mNumberCustomer = 50
    private var calDatePartyPicker = Calendar.getInstance()
    private val calDateNow = Calendar.getInstance()
    var listCartStorage = emptyList<CartModel>()

    private val toastMessageLive = MutableLiveData("")
    val toastMessage: LiveData<String> = toastMessageLive


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

    private fun setTimePicker(context: Context) {
        val timeSetListener = TimePickerDialog.OnTimeSetListener { _, hour, minute ->
            calDatePartyPicker.set(Calendar.HOUR_OF_DAY, hour)
            calDatePartyPicker.set(Calendar.MINUTE, minute)
            if (calDatePartyPicker <= calDateNow) {
                UiUtil.showToast(UiUtil.getString(R.string.date_booking_must_greater_than_day_now))
            } else {
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

    fun setTotalPrice() {
        val totalPrice = calculateTotalPrice()
        mTotalPrice.set(totalPrice.toString().toVNCurrency())
    }

    fun onOrderNowClicked(view: View) {
        mShowLoading.set(true)
        val bookModel = prepareDataForOrder()

        val coroutineExceptionHandler = CoroutineExceptionHandler{_, throwable ->
            throwable.printStackTrace()
            Log.e("BookPartyViewModel: ", throwable.message ?: "")
//            toastLiveData.value = showToastValueWhatever()
        }

        viewModelScope.launch(Dispatchers.IO + coroutineExceptionHandler) {
            try {
                val result = repository.orderParty(bookModel)
                mShowLoading.set(false)
                if (result is CusResult.Success) {
                    val action =
                        BookPartyFragmentDirections.actionBookingPartyFragmentToPaymentFragment(
                            result.data.billModel
                        )
                    view.findNavController().navigate(action)
                } else {
                    toastMessageLive.postValue(result.toStrings())
                }
            } catch (cause: Throwable) {
                mShowLoading.set(false)
                toastMessageLive.postValue(cause.message.toString())
            }
        }
    }

    private fun prepareDataForOrder(): RequestOrderPartyModel {
        val mListDishes = ArrayList<ListDishes>()
        for (row in listCartStorage) {
            if (row.id.isNotEmpty())
                mListDishes.add(
                    ListDishes(
                        row.quantity, row.id
                    )
                )
        }

        val dateParty = TimeFormatUtil.formatTimeToServer(calDatePartyPicker)
        val discountCode = mDishCountCodeField.get()

        return RequestOrderPartyModel(
            dateParty,
            mNumberTable,
            mNumberCustomer,
            discountCode,
            mListDishes
        )
    }
}