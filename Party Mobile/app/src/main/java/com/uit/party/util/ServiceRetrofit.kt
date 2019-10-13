package com.uit.party.util

import com.uit.party.model.AccountResponse
import com.uit.party.model.LoginModel
import com.uit.party.model.RegisterModel
import com.uit.party.model.BaseResponse
import com.uit.party.ui.profile.editprofile.RequestUpdateProfile
import okhttp3.Interceptor
import okhttp3.MultipartBody
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.*
import java.util.concurrent.TimeUnit


interface ServiceRetrofit {
    @HTTP(method = "POST", path = "user/signin", hasBody = true)
    fun login(
        @Body body: LoginModel
    ): Call<AccountResponse>

    @POST("user/signup")
    fun register(
        @Body body: RegisterModel
    ): Call<AccountResponse>

    @POST("user/signout")
    fun logout(
        @Header("authorization") token: String
    ): Call<BaseResponse>

    @POST("user/changepassword")
    @FormUrlEncoded
    fun changePassword(
        @Header("authorization") token: String,
        @Field("password") password: String,
        @Field("passwordchange") passwordchange: String
    ): Call<BaseResponse>

    @POST("user/updateuser")
    fun updateUser(
        @Header("authorization") token: String,
        @Body body: RequestUpdateProfile
    ): Call<AccountResponse>

    @POST("user/uploadavatar")
    fun updateAvatar(
        @Header("authorization") token: String,
        @Part image: MultipartBody.Part
    ): Call<BaseResponse>
}

class SetupConnectToServer {
    fun setupConnect(): ServiceRetrofit {

        val logging = HttpLoggingInterceptor()
        logging.level = HttpLoggingInterceptor.Level.BODY

        val okHttpClient = OkHttpClient.Builder()
            .readTimeout(30, TimeUnit.SECONDS)
            .connectTimeout(30, TimeUnit.SECONDS)
            .addInterceptor(interceptor)
            .addInterceptor(logging)
            .build()


        val builder = Retrofit.Builder()
            .baseUrl(" http://23.101.31.63:3000/")
            .client(okHttpClient)
            .addConverterFactory(GsonConverterFactory.create())
        val retrofit = builder.build()

        return retrofit.create(ServiceRetrofit::class.java)
    }

    private var interceptor: Interceptor = Interceptor { chain ->
        val newRequest: Request = chain.request().newBuilder()

            .addHeader("Content-Type", "application/x-www-form-urlencoded")
            .method(chain.request().method(), chain.request().body())
            .build()

        chain.proceed(newRequest)
    }
}