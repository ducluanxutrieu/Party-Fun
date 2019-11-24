package com.uit.party.ui.main.main_menu

import android.view.View
import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import androidx.databinding.ObservableInt
import androidx.databinding.library.baseAdapters.BR
import androidx.navigation.findNavController
import com.uit.party.R
import com.uit.party.model.*
import com.uit.party.ui.main.MainActivity.Companion.TOKEN_ACCESS
import com.uit.party.ui.main.MainActivity.Companion.serviceRetrofit
import com.uit.party.ui.signin.login.LoginViewModel
import com.uit.party.util.SharedPrefs
import com.uit.party.util.ToastUtil
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class MenuViewModel : BaseObservable(){
    val mShowFab = ObservableInt(View.GONE)

    @get: Bindable
    var listMenu = ArrayList<DishModel>()
        private set(value) {
            field = value
            notifyPropertyChanged(BR.listMenu)
        }

    fun init() {
        getListDishes {}
        setIsAdmin()
    }

    private fun setIsAdmin() {
        if (checkAdmin()) {
            mShowFab.set(View.VISIBLE)
        }
    }

    fun onAddDishClicked(view: View){
        view.findNavController().navigate(R.id.action_ListDish_to_AddDish)
    }

    fun getListDishes(onComplete : (Boolean) -> Unit){
        serviceRetrofit.getListDishes(TOKEN_ACCESS)
            .enqueue(object : Callback<DishesResponse>{
                override fun onFailure(call: Call<DishesResponse>, t: Throwable) {
                    t.message?.let { ToastUtil.showToast(it) }
                    onComplete(false)
                }

                override fun onResponse(
                    call: Call<DishesResponse>,
                    response: Response<DishesResponse>
                ) {
                    onComplete(true)
                    if (response.isSuccessful){
                        val dishes = response.body()?.lishDishs
                        if (dishes != null){
                            listMenu = dishes
                        }
                    }
                }
            })
    }

    fun logout(onSuccess : (Boolean) -> Unit) {
        serviceRetrofit.logout(TOKEN_ACCESS)
            .enqueue(object : Callback<BaseResponse>{
                override fun onFailure(call: Call<BaseResponse>, t: Throwable) {
                    t.message?.let { ToastUtil.showToast(it) }
                    onSuccess(false)
                }

                override fun onResponse(
                    call: Call<BaseResponse>,
                    response: Response<BaseResponse>
                ) {
                    val repo = response.body()
                    if (repo != null && response.code() == 200){
                        onSuccess(true)
                    }else{
                        onSuccess(false)
                    }
                }
            })
    }

    private fun checkAdmin(): Boolean {
        val role =
            SharedPrefs().getInstance()[LoginViewModel.USER_INFO_KEY, Account::class.java]?.role
        return role.equals("nhanvien")
    }
}