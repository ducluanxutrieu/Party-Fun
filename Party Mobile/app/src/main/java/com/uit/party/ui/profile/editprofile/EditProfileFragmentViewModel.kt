package com.uit.party.ui.profile.editprofile

import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.text.Editable
import android.text.TextWatcher
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel
import com.uit.party.R
import com.uit.party.util.GlobalApplication
import com.uit.party.util.StringUtil
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.*

class EditProfileFragmentViewModel : ViewModel(){
    private var fullNameValid = false
    private var phoneNumberValid = false

    var errorFullName = ObservableField<String>("")
    var errorPhoneNumber = ObservableField<String>("")
    var birthdayText = ObservableField<String>("")

    var btnUpdateEnabled: ObservableBoolean = ObservableBoolean()

    private var fullNameText: String = ""
    private var phoneNumberText: String = ""

    private var timeBirthdayPicker = Calendar.getInstance()
    private var callBirthdayPicker = Calendar.getInstance()

    private val formatDateUI = "dd-MM-yyyy"
    private val sf = SimpleDateFormat(formatDateUI, Locale.US)
    private val context = GlobalApplication.appContext!!

    private val birthDaySetListener = DatePickerDialog.OnDateSetListener { _, year, monthOfYear, dayOfMonth ->
        timeBirthdayPicker()
        callBirthdayPicker.set(Calendar.YEAR, year)
        callBirthdayPicker.set(Calendar.MONTH, monthOfYear)
        callBirthdayPicker.set(Calendar.DAY_OF_MONTH, dayOfMonth)
    }
    private fun timeBirthdayPicker() {
        val timeStartSetListener = TimePickerDialog.OnTimeSetListener { _, hour, minute ->
            timeBirthdayPicker.set(Calendar.HOUR_OF_DAY, hour)
            timeBirthdayPicker.set(Calendar.MINUTE, minute)
            updateBirthdayInView()
        }
        TimePickerDialog(
            context,
            timeStartSetListener,
            timeBirthdayPicker.get(Calendar.HOUR_OF_DAY),
            timeBirthdayPicker.get(Calendar.MINUTE),
            true
        ).show()
    }

    private fun updateBirthdayInView() {
        val timeStart = "${sf.format(callBirthdayPicker.time)} ${DateFormat.getTimeInstance(DateFormat.SHORT, Locale.FRANCE).format(timeBirthdayPicker.time)}"
        birthdayText.set(timeStart)
    }

    private fun checkEnableButtonUpdate() {
        if (fullNameValid && phoneNumberValid) {
            btnUpdateEnabled.set(true)
        } else btnUpdateEnabled.set(false)
    }

    fun getFullNameTextChanged(): TextWatcher {
        return object : TextWatcher {
            override fun afterTextChanged(editable: Editable?) {
                checkFullNameValid(editable)
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }
        }
    }

    private fun checkFullNameValid(editable: Editable?) {
        when {
            editable.isNullOrEmpty() -> {
                errorFullName.set(StringUtil.getString(R.string.this_field_required))
                fullNameValid = false
                checkEnableButtonUpdate()
            }
            else -> {
                fullNameValid = true
                errorFullName.set("")
                fullNameText = editable.toString()
                checkEnableButtonUpdate()
            }
        }
    }

    fun getPhoneNumberTextChanged(): TextWatcher {
        return object : TextWatcher {
            override fun afterTextChanged(editable: Editable?) {
                checkPhoneNumberValid(editable)
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

        }
    }

    private fun checkPhoneNumberValid(editable: Editable?) {
        when {
            editable.isNullOrEmpty() -> {
                errorPhoneNumber.set(StringUtil.getString(R.string.this_field_required))
                phoneNumberValid = false
                checkEnableButtonUpdate()
            }
            !android.util.Patterns.PHONE.matcher(editable).matches() -> {
                errorPhoneNumber.set(StringUtil.getString(R.string.phone_not_valid))
                phoneNumberValid = false
                checkEnableButtonUpdate()
            }
            else -> {
                phoneNumberValid = true
                errorPhoneNumber.set("")
                phoneNumberText = editable.toString()
                checkEnableButtonUpdate()
            }
        }
    }
    fun onBirthdayClicked(){
        DatePickerDialog(
            context,
            birthDaySetListener,
            callBirthdayPicker.get(Calendar.YEAR),
            callBirthdayPicker.get(Calendar.MONTH),
            callBirthdayPicker.get(Calendar.DAY_OF_MONTH)
        ).show()
    }

    fun onUpdateClicked(){

    }
}