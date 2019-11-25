package com.uit.party.ui.main.addnewdish

import android.graphics.Bitmap
import android.text.Editable
import android.text.TextWatcher
import android.view.View
import androidx.appcompat.widget.AppCompatImageView
import androidx.databinding.BaseObservable
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableField
import androidx.databinding.ObservableInt
import androidx.navigation.findNavController
import com.bumptech.glide.Glide
import com.bumptech.glide.request.RequestOptions
import com.uit.party.R
import com.uit.party.model.*
import com.uit.party.ui.main.MainActivity
import com.uit.party.ui.main.MainActivity.Companion.TOKEN_ACCESS
import com.uit.party.ui.main.MainActivity.Companion.serviceRetrofit
import com.uit.party.ui.signin.login.LoginViewModel.Companion.USER_INFO_KEY
import com.uit.party.util.GlobalApplication
import com.uit.party.util.SharedPrefs
import com.uit.party.util.StringUtil
import com.uit.party.util.ToastUtil
import com.vansuita.pickimage.bundle.PickSetup
import com.vansuita.pickimage.dialog.PickImageDialog
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody.Companion.asRequestBody
import okhttp3.RequestBody.Companion.toRequestBody
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.ByteArrayOutputStream
import java.io.File

class AddNewDishFragmentViewModel : BaseObservable() {
    val mTitle = ObservableField("")
    val mDescription = ObservableField("")
    val mPrice = ObservableField("")
    val mButtonField = ObservableField(StringUtil.getString(R.string.add_dish))
    val mShowUploadImageDish = ObservableInt(View.VISIBLE)
/*    val mImageDish1 = ObservableField("")
    val mImageDish2 = ObservableField("")
    val mImageDish3 = ObservableField("")
    val mImageDish4 = ObservableField("")*/

    val mErrorTitle = ObservableField("")
    val mErrorDescription = ObservableField("")
    val mErrorPrice = ObservableField("")

    private var mTitleText = ""
    private var mDescriptionText = ""
    private var mPriceText = ""
    var mTypeText = ""

    val mEnableSendButton = ObservableBoolean(false)

    private val description = "image-type".toRequestBody("text/plain".toMediaTypeOrNull())

    private val listImagePath = ArrayList<String>()

    private var mTitleValid = false
    private var mDescriptionValid = false
    private var mPriceValid = false

    var mDishModel: DishModel? = null

    fun initData() {
        mTitle.set(mDishModel?.name)
        mTitleText = mDishModel?.name.toString()

        mDescription.set(mDishModel?.description)
        mDescriptionText = mDishModel?.description.toString()

        mPrice.set(mDishModel?.price)
        mPriceText = mDishModel?.price.toString()

        mTypeText = mDishModel?.type.toString()

        mShowUploadImageDish.set(View.GONE)
        mEnableSendButton.set(true)
        mButtonField.set(StringUtil.getString(R.string.update_dish))
    }

    fun onAddImageDescription(view: View) {
        PickImageDialog.build(PickSetup()).setOnPickResult { result ->
            val byteArrayOutputStream = ByteArrayOutputStream()
            result.bitmap.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream)
            listImagePath.add(result.path)
            Glide.with(GlobalApplication.appContext!!).load(File(result.path))
                .apply { RequestOptions.fitCenterTransform() }.into(view as AppCompatImageView)
        }.setOnPickCancel { /*binding.loadingAvatar.visibility = View.GONE */ }
            .show((view.context as MainActivity).supportFragmentManager)
    }

    fun onSendAddDishClicked(view: View) {
        if (mDishModel == null) {
            uploadDishImages(view)
        } else {
            updateDish()
        }
    }

    private fun updateDish() {
        val mUpdateModel = UpdateDishRequestModel(mDishModel?._id.toString(), mTitleText, mDescriptionText, mPriceText, mTypeText)
        serviceRetrofit.updateDish(TOKEN_ACCESS, mUpdateModel)
            .enqueue(object : Callback<BaseResponse>{
                override fun onFailure(call: Call<BaseResponse>, t: Throwable) {
                    t.message?.let { ToastUtil.showToast(it) }
                }

                override fun onResponse(
                    call: Call<BaseResponse>,
                    response: Response<BaseResponse>
                ) {
                    if (response.code() == 200){
                        response.body()?.message?.let { ToastUtil.showToast(it) }
                    }else{
                        ToastUtil.showToast(StringUtil.getString(R.string.update_dish_false))
                    }
                }
            })
    }

    fun getTitleTextChanged(): TextWatcher {
        return object : TextWatcher {
            override fun afterTextChanged(editable: Editable?) {
                checkTitleValid(editable)
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }
        }
    }

    private fun checkTitleValid(editable: Editable?) {
        when {
            editable.isNullOrEmpty() -> {
                mErrorTitle.set(StringUtil.getString(R.string.this_field_required))
                mTitleValid = false
                checkEnableButtonSend()
            }
            else -> {
                mTitleValid = true
                mErrorTitle.set("")
                checkEnableButtonSend()
                mTitleText = editable.toString()
            }
        }
    }

    fun getDescriptionTextChanged(): TextWatcher {
        return object : TextWatcher {
            override fun afterTextChanged(editable: Editable?) {
                checkDescriptionValid(editable)
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }
        }
    }

    private fun checkDescriptionValid(editable: Editable?) {
        when {
            editable.isNullOrEmpty() -> {
                mErrorDescription.set(StringUtil.getString(R.string.this_field_required))
                mDescriptionValid = false
                checkEnableButtonSend()
            }
            else -> {
                mDescriptionValid = true
                mErrorDescription.set("")
                checkEnableButtonSend()
                mDescriptionText = editable.toString()
            }
        }
    }

    fun getPriceTextChanged(): TextWatcher {
        return object : TextWatcher {
            override fun afterTextChanged(editable: Editable?) {
                checkPriceValid(editable)
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }
        }
    }

    private fun checkPriceValid(editable: Editable?) {
        when {
            editable.isNullOrEmpty() -> {
                mErrorTitle.set(StringUtil.getString(R.string.this_field_required))
                mPriceValid = false
                checkEnableButtonSend()
            }
            else -> {
                mPriceValid = true
                mErrorTitle.set("")
                checkEnableButtonSend()
                mPriceText = editable.toString()
            }
        }
    }

    private fun checkEnableButtonSend() {
        if (mTitleValid && mDescriptionValid && mPriceValid) {
            mEnableSendButton.set(true)
        }
    }

    private fun uploadDishImages(view: View) {
        val builder = MultipartBody.Builder()
        builder.setType(MultipartBody.FORM)

        val multipartPath = ArrayList<MultipartBody.Part>()
        val parseType = "multipart/form-data"
        for (row in listImagePath) {
            val file = File(row)

            multipartPath.add(
                MultipartBody.Part.createFormData(
                    "image",
                    file.name,
                    file.asRequestBody(parseType.toMediaTypeOrNull())
                )
            )
        }

        //Create request body with text description and text media type
        val token = SharedPrefs().getInstance()[USER_INFO_KEY, Account::class.java]?.token
        serviceRetrofit.addDish(
            token!!,
            mTitleText.toRequestBody(MultipartBody.FORM),
            mDescriptionText.toRequestBody(MultipartBody.FORM),
            mPriceText.toRequestBody(MultipartBody.FORM),
            mTypeText.toRequestBody(MultipartBody.FORM),
            multipartPath,
            description
        )
            .enqueue(object : Callback<AddDishResponse> {
                override fun onFailure(call: Call<AddDishResponse>, t: Throwable) {
                    t.message?.let { ToastUtil.showToast(it) }
                }

                override fun onResponse(
                    call: Call<AddDishResponse>,
                    response: Response<AddDishResponse>
                ) {
                    if (response.isSuccessful) {
                        response.body()?.message?.let { ToastUtil.showToast(it) }
                        view.findNavController().popBackStack()
                    }
                }
            })
    }
}