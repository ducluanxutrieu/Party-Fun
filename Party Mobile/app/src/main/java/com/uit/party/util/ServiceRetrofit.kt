package com.uit.party.util

import com.uit.party.model.*
import com.uit.party.ui.profile.editprofile.RequestUpdateProfile
import okhttp3.*
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

    @POST("user/resetpassword")
    @FormUrlEncoded
    fun resetPassword(
        @Field("username") username: String
    ): Call<BaseResponse>

    @POST("/user/resetconfirm")
    @FormUrlEncoded
    fun verifyPassword(
        @Field("resetpassword") resetpassword: String,
        @Field("passwordnew") passwordnew: String
    ): Call<BaseResponse>

    @POST("user/changepassword")
    @FormUrlEncoded
    fun changePassword(
        @Header("authorization") token: String,
        @Field("password") password: String,
        @Field("newpassword") passwordchange: String
    ): Call<BaseResponse>

    @GET("/user/profile")
    fun getProfile(
        @Header("authorization") token: String
    ): Call<AccountResponse>

    @POST("user/updateuser")
    fun updateUser(
        @Header("authorization") token: String,
        @Body body: RequestUpdateProfile
    ): Call<AccountResponse>

    @Multipart
    @POST("user/uploadavatar")
    fun updateAvatar(
        @Header("authorization") token: String,
        @Part image: MultipartBody.Part, @Part("image") requestBody: RequestBody
    ): Call<BaseResponse>

    @Multipart
    @POST("product/adddish")
    fun addDish(
        @Header("authorization") token: String,
        @Part("name") name: RequestBody?,
        @Part("description") description: RequestBody?,
        @Part("price") price: RequestBody?,
        @Part("type") type: RequestBody?,
        @Part("discount") discount: RequestBody?,
        @Part image: ArrayList<MultipartBody.Part>,
        @Part("image") requestBody: RequestBody
    ): Call<AddDishResponse>

    @POST("/product/updatedish")
    fun updateDish(
        @Header("authorization") token: String,
        @Body body: UpdateDishRequestModel
        ): Call<UpdateDishResponse>

    @GET("product/finddish")
    fun getListDishes(
        @Header("authorization") token: String
    ): Call<DishesResponse>

    @HTTP(method = "POST", path = "product/getItemDish", hasBody = true)
    fun getItemDish(
        @Body body : HashMap<String, String?>
    ): Call<DishItemResponse>

    @POST("/product/ratedish")
    fun ratingDish(
        @Header("authorization") token: String,
        @Body body: RequestRatingModel
    ): Call<BaseResponse>

    @HTTP(method = "DELETE", path = "/product/deletedish", hasBody = true)
    fun deleteDish(
        @Header("authorization") token: String,
        @Body body: HashMap<String, String>
    ): Call<BaseResponse>

    @POST("/product/book")
    fun bookParty(
        @Header("authorization") token: String,
        @Body body: RequestOrderPartyModel
    ): Call<BillModel>
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
            .baseUrl("http://139.180.131.30:3000/")
            .client(okHttpClient)
            .addConverterFactory(GsonConverterFactory.create())
        val retrofit = builder.build()

        return retrofit.create(ServiceRetrofit::class.java)
    }

    private var interceptor: Interceptor = Interceptor { chain ->
        val newRequest: Request = chain.request().newBuilder()

            .addHeader("Content-Type", "application/x-www-form-urlencoded")
            .method(chain.request().method, chain.request().body)
            .build()

        chain.proceed(newRequest)
    }
}