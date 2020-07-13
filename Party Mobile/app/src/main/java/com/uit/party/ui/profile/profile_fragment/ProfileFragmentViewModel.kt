package com.uit.party.ui.profile.profile_fragment

import android.graphics.Bitmap
import android.util.Log
import android.view.View
import androidx.databinding.ObservableField
import androidx.lifecycle.ViewModel
import androidx.navigation.findNavController
import com.uit.party.R
import com.uit.party.model.Account
import com.uit.party.model.BaseResponse
import com.uit.party.model.UserGender
import com.uit.party.ui.main.MainActivity
import com.uit.party.ui.main.MainActivity.Companion.TOKEN_ACCESS
import com.uit.party.ui.main.MainActivity.Companion.serviceRetrofit
import com.uit.party.ui.signin.login.LoginViewModel.Companion.USER_INFO_KEY
import com.uit.party.util.SharedPrefs
import com.uit.party.util.TimeFormatUtil
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

class ProfileFragmentViewModel(val context: MainActivity) : ViewModel(){
    val mName = ObservableField("")
    val mUsername = ObservableField("")
    val mEmail = ObservableField("")
    val mMobile = ObservableField("")
    val mSex = ObservableField("")
    val mBirthDay = ObservableField("")
    val mAvatar = ObservableField("")

    private var mAccount = SharedPrefs().getInstance()[USER_INFO_KEY, Account::class.java]

    init {
        mName.set(mAccount?.fullName)
        mEmail.set(mAccount?.email)
        mSex.set(UserGender.values()[mAccount?.gender ?: 0].name)
        mBirthDay.set(TimeFormatUtil.formatDateToClient(mAccount?.birthday))
        mAvatar.set(mAccount?.avatar)
        mMobile.set(mAccount?.phone.toString())
        mUsername.set(mAccount?.username)
    }

    fun editProfile(view: View){
        view.findNavController().navigate(R.id.action_ProfileFragment_to_EditProfileFragment)
    }

    fun onChangePasswordClicked(view: View){
        val action = ProfileFragmentDirections.actionProfileFragmentToChangePasswordFragment("CHANGE")
        view.findNavController().navigate(action)
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
            file.asRequestBody(parseType.toMediaTypeOrNull())
        )

        //Create request body with text description and text media type
        val description = "image-type".toRequestBody("text/plain".toMediaTypeOrNull())
        serviceRetrofit.updateAvatar(TOKEN_ACCESS, part, description)
            .enqueue(object : Callback<BaseResponse> {
                override fun onFailure(call: Call<BaseResponse>, t: Throwable) {
                    if (t.message != null) {
                        ToastUtil.showToast(t.message!!)
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
                        ToastUtil.showToast(response.message())
                    }
                }
            })
    }
}