package com.uit.party.ui.profile.edit_profile

import android.app.DatePickerDialog
import android.view.View
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel
import androidx.navigation.findNavController
import com.uit.party.R
import com.uit.party.data.getToken
import com.uit.party.model.Account
import com.uit.party.model.AccountResponse
import com.uit.party.util.*
import com.uit.party.util.Constants.Companion.USER_INFO_KEY
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.text.SimpleDateFormat
import java.util.*

class EditProfileFragmentViewModel : ViewModel() {
    private var fullNameValid = false
    private var phoneNumberValid = false
    private var emailValid = false

    var errorFullName = ObservableField<String>("")
    var errorPhoneNumber = ObservableField<String>("")
    var errorEmailText = ObservableField<String>("")

    val mFullName = ObservableField("")
    val mPhoneNumber = ObservableField("")
    val mEmail = ObservableField("")
    val mBirthday = ObservableField("")
    var mSex: String = ""

    var btnUpdateEnabled: ObservableBoolean = ObservableBoolean()


    private var calBirthdayPicker = Calendar.getInstance()
    private val calDateNow = Calendar.getInstance()

    private val formatDateUI = "dd-MM-yyyy"
    private val sf = SimpleDateFormat(formatDateUI, Locale.US)

    val account = SharedPrefs(GlobalApplication.appContext!!).getData(USER_INFO_KEY, Account::class.java)!!

    private val birthDaySetListener =
        DatePickerDialog.OnDateSetListener { _, year, monthOfYear, dayOfMonth ->
            calBirthdayPicker.set(Calendar.YEAR, year)
            calBirthdayPicker.set(Calendar.MONTH, monthOfYear)
            calBirthdayPicker.set(Calendar.DAY_OF_MONTH, dayOfMonth)
            if (calBirthdayPicker >= calDateNow) {
                UiUtil.showToast(UiUtil.getString(R.string.birthday_greater_than_now_day))
            } else {
                updateBirthdayInView()
            }
        }

    init {
//        val timeStart = sf.format(calBirthdayPicker.time)
        if (account.birthday.isNullOrEmpty()) {
            mBirthday.set(account.birthday)
        }
        if (!account.email.isNullOrEmpty()) {
            mEmail.set(account.email)
            emailValid = true
            checkEnableButtonUpdate()
        }
        if (account.phone != null) {
            mPhoneNumber.set(account.phone.toString())
            phoneNumberValid = true
            checkEnableButtonUpdate()
        }
        if (!account.fullName.isNullOrEmpty()) {
            mFullName.set(account.fullName)
            fullNameValid = true
            checkEnableButtonUpdate()
        }

        if (!account.birthday.isNullOrEmpty()) {
            mBirthday.set(TimeFormatUtil.formatDateToClient(account.birthday))
        }
    }

    private fun updateBirthdayInView() {
        val timeStart = sf.format(calBirthdayPicker.time)
        this.mBirthday.set(timeStart)
    }

    private fun checkEnableButtonUpdate() {
        if (fullNameValid && phoneNumberValid && emailValid) {
            btnUpdateEnabled.set(true)
        } else btnUpdateEnabled.set(false)
    }

    fun checkEmailValid(text: CharSequence?) {
        when {
            text.isNullOrEmpty() -> {
                errorEmailText.set(UiUtil.getString(R.string.this_field_required))
                emailValid = false
                checkEnableButtonUpdate()
            }
            !android.util.Patterns.EMAIL_ADDRESS.matcher(text).matches() -> {
                errorEmailText.set(UiUtil.getString(R.string.email_not_valid))
                emailValid = false
                checkEnableButtonUpdate()
            }
            else -> {
                emailValid = true
                errorEmailText.set("")
                checkEnableButtonUpdate()
            }
        }
    }

    fun checkFullNameValid(text: CharSequence?) {
        when {
            text.isNullOrEmpty() -> {
                errorFullName.set(UiUtil.getString(R.string.this_field_required))
                fullNameValid = false
                checkEnableButtonUpdate()
            }
            else -> {
                fullNameValid = true
                errorFullName.set("")
                checkEnableButtonUpdate()
            }
        }
    }

    fun checkPhoneNumberValid(text: CharSequence?) {
        when {
            text.isNullOrEmpty() -> {
                errorPhoneNumber.set(UiUtil.getString(R.string.this_field_required))
                phoneNumberValid = false
                checkEnableButtonUpdate()
            }
            !android.util.Patterns.PHONE.matcher(text).matches() -> {
                errorPhoneNumber.set(UiUtil.getString(R.string.phone_not_valid))
                phoneNumberValid = false
                checkEnableButtonUpdate()
            }
            text.trim().length < 9 -> {
                errorPhoneNumber.set(UiUtil.getString(R.string.phone_number_too_short))
                phoneNumberValid = false
                checkEnableButtonUpdate()
            }
            else -> {
                phoneNumberValid = true
                errorPhoneNumber.set("")
                checkEnableButtonUpdate()
            }
        }
    }

    fun onBirthdayClicked(view: View) {
        DatePickerDialog(
            view.context,
            birthDaySetListener,
            calBirthdayPicker.get(Calendar.YEAR),
            calBirthdayPicker.get(Calendar.MONTH),
            calBirthdayPicker.get(Calendar.DAY_OF_MONTH)
        ).show()
    }

    fun onUpdateClicked(view: View) {
        val requestModel = RequestUpdateProfile(
            mEmail.get(),
            mFullName.get(),
            mPhoneNumber.get(),
            TimeFormatUtil.formatDateToServer(mBirthday.get()),
            mSex
        )
        getNetworkService().updateUser(getToken(), requestModel)
            .enqueue(object : Callback<AccountResponse> {
                override fun onFailure(call: Call<AccountResponse>, t: Throwable) {
                    if (!t.message.isNullOrEmpty()) {
                        UiUtil.showToast(t.message!!)
                    }
                }

                override fun onResponse(
                    call: Call<AccountResponse>,
                    response: Response<AccountResponse>
                ) {
                    val repo = response.body()
                    if (repo != null) {
                        saveToMemory(repo)
                        UiUtil.showToast(UiUtil.getString(R.string.update_profile_success))
                        view.findNavController().popBackStack()
                    }
                }
            })
    }

    private fun saveToMemory(model: AccountResponse) {
        SharedPrefs(GlobalApplication.appContext!!).setData(USER_INFO_KEY, model.account)
    }
}