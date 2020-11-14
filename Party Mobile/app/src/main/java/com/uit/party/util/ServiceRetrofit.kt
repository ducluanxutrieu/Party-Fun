package com.uit.party.util

import com.uit.party.model.*
import com.uit.party.ui.profile.edit_profile.RequestUpdateProfile
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

    @GET("user/signout")
    suspend fun logout(
        @Header("authorization") token: String
    ): BaseResponse

    @POST("user/resetpassword")
    @FormUrlEncoded
    fun resetPassword(
        @Field("username") username: String
    ): Call<BaseResponse>

    @POST("user/resetconfirm")
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

    @GET("user/profile")
    fun getProfile(
        @Header("authorization") token: String
    ): Call<AccountResponse>

    @GET("user/get_history_cart")
    fun getHistoryBooking(
        @Header("authorization") token: String
    ): Call<GetHistoryCartResponse>

    @POST("user/updateuser")
    fun updateUser(
        @Header("authorization") token: String,
        @Body body: RequestUpdateProfile
    ): Call<AccountResponse>

    @Multipart
    @POST("user/uploadavatar")
    fun updateAvatar(
        @Header("authorization") token: String,
        @Part image: MultipartBody.Part,
        @Part("image") requestBody: RequestBody
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

    @POST("product/updatedish")
    fun updateDish(
        @Header("authorization") token: String,
        @Body body: UpdateDishRequestModel
    ): Call<UpdateDishResponse>

    @GET("product/dishs")
    suspend fun getListDishes(
        @Header("authorization") token: String
    ): DishesResponse

    @HTTP(method = "POST", path = "product/getItemDish", hasBody = true)
    suspend fun getItemDish(
        @Body body: HashMap<String, String?>
    ): DishItemResponse

    //Rating
    @GET("product/rate")
    suspend fun getDishRates(
        @Query("id") id: String,
        @Query("page") page: Int
    ): RateResponseModel

    @POST("product/rate")
    suspend fun ratingDish(
        @Header("authorization") token: String,
        @Body body: RequestRatingModel
    ): SingleRateResponseModel

    @PUT("product/rate")
    suspend fun updateRatingDish(
        @Header("authorization") token: String,
        @Body body: RequestRatingModel
    ): SingleRateResponseModel

    @HTTP(method = "DELETE", path = "product/deletedish", hasBody = true)
    suspend fun deleteDish(
        @Header("authorization") token: String,
        @Body body: HashMap<String, String>
    ): BaseResponse

    @POST("product/book")
    suspend fun orderParty(
        @Header("authorization") token: String,
        @Body body: RequestOrderPartyModel
    ): BillResponseModel

    @GET("payment/get_payment")
    suspend fun getPayment(
        @Header("authorization") token: String,
        @Query("_id") id: String
    ): GetPaymentResponse
}

private val service: ServiceRetrofit by lazy {

    val logging = HttpLoggingInterceptor()
    logging.level = HttpLoggingInterceptor.Level.BODY

    val okHttpClient = OkHttpClient.Builder()
        .readTimeout(30, TimeUnit.SECONDS)
        .connectTimeout(30, TimeUnit.SECONDS)
        .addInterceptor(interceptor)
        .addInterceptor(logging)
        .build()


    val builder = Retrofit.Builder()
        .baseUrl("https://partybooking.herokuapp.com/")
        .client(okHttpClient)
        .addConverterFactory(GsonConverterFactory.create())
    val retrofit = builder.build()

    retrofit.create(ServiceRetrofit::class.java)
}

fun getNetworkService() = service

private var interceptor: Interceptor = Interceptor { chain ->
    val newRequest: Request = chain.request().newBuilder()

        .addHeader("Content-Type", "application/x-www-form-urlencoded")
        .method(chain.request().method, chain.request().body)
        .build()

    chain.proceed(newRequest)
}