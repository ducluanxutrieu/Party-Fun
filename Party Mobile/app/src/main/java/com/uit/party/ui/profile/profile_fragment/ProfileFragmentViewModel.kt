package com.uit.party.ui.profile.profile_fragment

import android.graphics.Bitmap
import android.util.Log
import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel
import com.uit.party.R
import com.uit.party.model.Account
import com.uit.party.model.BaseResponse
import com.uit.party.ui.main.MainActivity.Companion.TOKEN_ACCESS
import com.uit.party.ui.main.MainActivity.Companion.serviceRetrofit
import com.uit.party.ui.profile.ProfileActivity
import com.uit.party.ui.profile.change_password.ChangePasswordFragment
import com.uit.party.ui.profile.editprofile.EditProfileFragment
import com.uit.party.ui.signin.login.LoginViewModel.Companion.USER_INFO_KEY
import com.uit.party.util.AddNewFragment
import com.uit.party.util.SharedPrefs
import com.uit.party.util.ToastUtil
import com.vansuita.pickimage.bundle.PickSetup
import com.vansuita.pickimage.dialog.PickImageDialog
import okhttp3.MediaType
import okhttp3.MultipartBody
import okhttp3.RequestBody
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.ByteArrayOutputStream
import java.io.File

class ProfileFragmentViewModel(val context: ProfileActivity) : ViewModel(){
    val mName = ObservableField("")
    val mUsername = ObservableField("")
    val mEmail = ObservableField("")
    val mMobile = ObservableField("")
    val mSex = ObservableField("")
    val mBirthDay = ObservableField("")
    val mAvatar = ObservableField("")

    var mAccount = SharedPrefs().getInstance()[USER_INFO_KEY, Account::class.java]

    init {
        mName.set(mAccount?.fullName)
        mEmail.set(mAccount?.email)
        mSex.set(mAccount?.sex)
        mBirthDay.set(mAccount?.birthday)
        mAvatar.set(mAccount?.imageurl)
        mMobile.set(mAccount?.phoneNumber)
        mUsername.set(mAccount?.username)
    }

    fun editProfile(){
        val fragment = EditProfileFragment.newInstance(context)
        AddNewFragment().addNewSlideUp(R.id.profile_container, fragment, true, context)
    }

    fun changePassword(){
        val fragment = ChangePasswordFragment.newInstance( context)
        AddNewFragment().addNewSlideUp(R.id.profile_container, fragment, true, context)
    }

    fun avatarClicked(){
        PickImageDialog.build(PickSetup()).setOnPickResult { result ->
            val byteArrayOutputStream = ByteArrayOutputStream()
            result.bitmap.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream)
            uploadAvatar(result.path) {
                mAvatar.set(it)
            }
        }.setOnPickCancel {}
            .show(context.supportFragmentManager)
    }

    private fun uploadAvatar(result: String, onComplete: (String?) -> Unit) {
        val file = File(result)
        val parseType = "multipart/form-data"

        val part: MultipartBody.Part = MultipartBody.Part.createFormData(
            "image",
            file.name,
            RequestBody.create(MediaType.parse(parseType), file)
        )

        //Create request body with text description and text media type
        val description = RequestBody.create(MediaType.parse("text/plain"), "image-type")
        serviceRetrofit.updateAvatar(TOKEN_ACCESS, part, description)
            .enqueue(object : Callback<BaseResponse> {
                override fun onFailure(call: Call<BaseResponse>, t: Throwable) {
                    if (t.message != null) {
                        ToastUtil().showToast(t.message!!)
                        Log.e("uploadAvatar", t.message!!)
                    }
                }

                override fun onResponse(
                    call: Call<BaseResponse>,
                    response: Response<BaseResponse>
                ) {
                    if (response.isSuccessful) {
                        onComplete(response.body()?.message)
                    } else {
                        ToastUtil().showToast(response.message())
                    }
                }
            })
    }
}