package com.uit.party.ui.main.cart_detail

import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.content.Context
import android.text.Editable
import android.text.TextWatcher
import android.view.View
import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableField
import androidx.databinding.library.baseAdapters.BR
import androidx.navigation.findNavController
import com.uit.party.R
import com.uit.party.model.*
import com.uit.party.ui.main.MainActivity.Companion.TOKEN_ACCESS
import com.uit.party.ui.main.MainActivity.Companion.serviceRetrofit
import com.uit.party.util.StringUtil
import com.uit.party.util.TimeFormatUtil
import com.uit.party.util.ToastUtil
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.util.*
import kotlin.collections.ArrayList

class CartDetailViewModel : BaseObservable(), OnCartDetailListener {
    val mShowCart = ObservableBoolean(false)
    val mShowLoading = ObservableBoolean(false)
    val mCartAdapter = CartDetailAdapter(this)
    val mTotalPrice = ObservableField("")
    val mNumberTableField = ObservableField("1")
    val mDatePartyField = ObservableField("")
    private var mNumberTable = 1

    private var calDatePartyPicker = Calendar.getInstance()
    private val calDateNow = Calendar.getInstance()

    private val datePartySetListener =
        DatePickerDialog.OnDateSetListener { view, year, monthOfYear, dayOfMonth ->
            setTimePicker(view.context)
            calDatePartyPicker.set(Calendar.YEAR, year)
            calDatePartyPicker.set(Calendar.MONTH, monthOfYear)
            calDatePartyPicker.set(Calendar.DAY_OF_MONTH, dayOfMonth)
        }

    @get: Bindable
    var mListCart = ArrayList<CartModel>()
        private set(value) {
            field = value
            notifyPropertyChanged(BR.mListCart)
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

    override fun onChangeNumberDish(position: Int, cartModel: CartModel, isIncrease: Boolean) {
        mListCart[position] = cartModel
        mTotalPrice.set(calculateTotalPrice().toString() + "Đ")
    }

    override fun onDeleteDish(position: Int) {
        mListCart.removeAt(position)
        mTotalPrice.set(calculateTotalPrice().toString() + "Đ")
        mCartAdapter.notifyItemRemoved(position)
    }

    private fun calculateTotalPrice(): Int {
        var totalPrice = 0
        for (row in mListCart) {
            totalPrice += (row.numberDish * (row.dishModel.price?.toInt() ?: 0))
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
                checkPasswordValid(editable)
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }
        }
    }

    private fun checkPasswordValid(editable: Editable?) {
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

    fun initData(listDishModel: ArrayList<DishModel>) {
        if (listDishModel.isNullOrEmpty()){
            mShowCart.set(false)
        }else {
            mShowCart.set(true)
            for (dish in listDishModel) {
                var doubleCart = false
                for (cart in mListCart) {
                    if (cart.dishModel._id == dish._id) {
                        cart.numberDish++
                        doubleCart = true
                        break
                    }
                }

                if (!doubleCart) {
                    mListCart.add(CartModel(1, dish))
                }
            }
            mTotalPrice.set(calculateTotalPrice().toString() + "Đ")
        }
    }

    fun onOrderNowClicked(view: View){
        mShowLoading.set(true)
        val mListDishes = ArrayList<ListDishes>()
        for (row in mListCart){
            if (!row.dishModel._id.isNullOrEmpty())
                mListDishes.add(ListDishes(row.numberDish.toString(), row.dishModel._id!!
            ))
        }

        val bookModel = RequestOrderPartyModel(TimeFormatUtil.formatTimeToServer(calDatePartyPicker), mNumberTable.toString(), mListDishes)
        serviceRetrofit.bookParty(TOKEN_ACCESS, bookModel)
            .enqueue(object : Callback<BillModel>{
                override fun onFailure(call: Call<BillModel>, t: Throwable) {
                    t.message?.let { ToastUtil.showToast(it) }
                    mShowLoading.set(false)
                }

                override fun onResponse(call: Call<BillModel>, response: Response<BillModel>) {
                    mShowLoading.set(false)
                    if (response.code() == 200){
                        response.body()?.message?.let { ToastUtil.showToast(it) }
                        if (response.body()?.success == true){
                            view.findNavController().navigate(R.id.action_CartDetailFragment_to_BookingSuccessFragment)
                        }
                    }else{
                        ToastUtil.showToast(response.message())
                    }
                }
            })
    }
}