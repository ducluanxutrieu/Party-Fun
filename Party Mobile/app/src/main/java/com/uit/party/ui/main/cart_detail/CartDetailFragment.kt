package com.uit.party.ui.main.cart_detail

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.navArgs
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.uit.party.R
import com.uit.party.databinding.FragmentCartDetailBinding
import com.uit.party.model.DishModel

class CartDetailFragment : Fragment(){
    private var mListDishes = ArrayList<DishModel>()
    private lateinit var mBinding: FragmentCartDetailBinding
    private val mViewModel = CartDetailViewModel()
    private val mArgs : CartDetailFragmentArgs by navArgs()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        mBinding =
            DataBindingUtil.inflate(inflater, R.layout.fragment_cart_detail, container, false)
        return mBinding.root
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        mBinding.viewModel = mViewModel

        val typeToken = object : TypeToken<ArrayList<DishModel>>() {}.type
        mListDishes = Gson().fromJson<ArrayList<DishModel>>(mArgs.StringListDishSelectedKey, typeToken)

        mViewModel.initData(mListDishes)

        mBinding.rvCartDetail.adapter = mViewModel.mCartAdapter
    }
}