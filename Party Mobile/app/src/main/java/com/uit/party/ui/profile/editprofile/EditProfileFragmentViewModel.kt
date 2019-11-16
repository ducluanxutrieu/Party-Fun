package com.uit.party.ui.profile.editprofile

import android.app.DatePickerDialog
import android.text.Editable
import android.text.TextWatcher
import android.view.View
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableField
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.ViewModel
import com.uit.party.R
import com.uit.party.model.Account
import com.uit.party.model.AccountResponse
import com.uit.party.ui.main.MainActivity.Companion.TOKEN_ACCESS
import com.uit.party.ui.main.MainActivity.Companion.serviceRetrofit
import com.uit.party.ui.signin.login.LoginViewModel.Companion.USER_INFO_KEY
import com.uit.party.util.SharedPrefs
import com.uit.party.util.StringUtil
import com.uit.party.util.ToastUtil
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.text.SimpleDateFormat
import java.util.*

class EditProfileFragmentViewModel(private val mActivity: FragmentActivity?) : ViewModel() {
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

    private val formatDateUI = "dd-MM-yyyy"
    private val sf = SimpleDateFormat(formatDateUI, Locale.US)

    private val account = SharedPrefs().getInstance()[USER_INFO_KEY, Account::class.java]

    private val birthDaySetListener =
        DatePickerDialog.OnDateSetListener { _, year, monthOfYear, dayOfMonth ->
            updateBirthdayInView()
            calBirthdayPicker.set(Calendar.YEAR, year)
            calBirthdayPicker.set(Calendar.MONTH, monthOfYear)
            calBirthdayPicker.set(Calendar.DAY_OF_MONTH, dayOfMonth)
        }

    init {
//        val timeStart = sf.format(calBirthdayPicker.time)
        if (account?.birthday.isNullOrEmpty()) {
            mBirthday.set(account?.birthday)
        }
        if (!account?.email.isNullOrEmpty()) {
            mEmail.set(account?.email)
            emailValid = true
            checkEnableButtonUpdate()
        }
        if (!account?.phoneNumber.isNullOrEmpty()) {
            mPhoneNumber.set(account?.phoneNumber)
            phoneNumberValid = true
            checkEnableButtonUpdate()
        }
        if (!account?.fullName.isNullOrEmpty()) {
            mFullName.set(account?.fullName)
            fullNameValid = true
            checkEnableButtonUpdate()
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

    fun getEmailTextChanged(): TextWatcher {
        return object : TextWatcher {
            override fun afterTextChanged(editable: Editable?) {
                checkEmailValid(editable)
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }
        }
    }

    private fun checkEmailValid(editable: Editable?) {
        when {
            editable.isNullOrEmpty() -> {
                errorEmailText.set(StringUtil.getString(R.string.this_field_required))
                emailValid = false
                checkEnableButtonUpdate()
            }
            !android.util.Patterns.EMAIL_ADDRESS.matcher(editable).matches() -> {
                errorEmailText.set(StringUtil.getString(R.string.email_not_valid))
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

    fun onUpdateClicked() {
        val requestModel = RequestUpdateProfile(
            mEmail.get(),
            mFullName.get(),
            mPhoneNumber.get(),
            mBirthday.get(),
            mSex
        )
        serviceRetrofit.updateUser(TOKEN_ACCESS, requestModel)
            .enqueue(object : Callback<AccountResponse> {
                override fun onFailure(call: Call<AccountResponse>, t: Throwable) {
                    if (!t.message.isNullOrEmpty()) {
                        ToastUtil().showToast(t.message!!)
                    }
                }

                override fun onResponse(
                    call: Call<AccountResponse>,
                    response: Response<AccountResponse>
                ) {
                    val repo = response.body()
                    if (repo != null) {
                        saveToMemory(repo)
                        ToastUtil().showToast(StringUtil.getString(R.string.update_profile_success))
                    }
                }
            })
    }

    private fun saveToMemory(model: AccountResponse) {
        SharedPrefs().getInstance().put(USER_INFO_KEY, model.account)
    }
}