package com.uit.party.ui.main.main_menu

import android.view.View
import androidx.databinding.ObservableInt
import androidx.lifecycle.ViewModel
import androidx.navigation.findNavController
import com.uit.party.model.Account
import com.uit.party.model.BaseResponse
import com.uit.party.model.DishModel
import com.uit.party.model.DishesResponse
import com.uit.party.ui.main.MainActivity.Companion.TOKEN_ACCESS
import com.uit.party.ui.main.MainActivity.Companion.serviceRetrofit
import com.uit.party.ui.signin.login.LoginViewModel
import com.uit.party.util.SharedPrefs
import com.uit.party.util.ToastUtil
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class MenuViewModel : ViewModel(){
    val mShowFab = ObservableInt(View.GONE)
    val mMenuAdapter = MenuAdapter()

    var listMenu = ArrayList<DishModel>()

    init {
        if (listMenu.isNullOrEmpty()) {
            getListDishes {}
        }else{
            mMenuAdapter.setData(listMenu)
        }
        setIsAdmin()
    }

    private fun setIsAdmin() {
        if (checkAdmin()) {
            mShowFab.set(View.VISIBLE)
        }
    }

    fun onAddDishClicked(view: View){
        val action = MenuFragmentDirections.actionListDishToAddDish(0, "", null)
        view.findNavController().navigate(action)
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
                            mMenuAdapter.setData(listMenu)
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