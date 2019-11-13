package com.uit.party.ui.main.cart_detail

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.uit.party.R
import com.uit.party.databinding.FragmentCartDetailBinding
import com.uit.party.model.DishModel
import com.uit.party.ui.main.MainActivity

class CartDetailFragment : Fragment(){
    private var mListDishes = ArrayList<DishModel>()
    private lateinit var mBinding: FragmentCartDetailBinding
    private val mViewModel = CartDetailViewModel()

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
        mViewModel.initData(mListDishes)

        mBinding.rvCartDetail.adapter = mViewModel.mCartAdapter

        setupToolbar()
    }

    @SuppressLint("NewApi")
    private fun setupToolbar() {
        mBinding.toolbarCartDetail.setNavigationIcon(R.drawable.ic_arrow_back_green_24dp)
        mBinding.toolbarCartDetail.title = getString(R.string.cart_detail)
        mBinding.toolbarCartDetail.setTitleTextColor(
            resources.getColor(
                R.color.colorWhile,
                context?.theme
            )
        )
        mBinding.toolbarCartDetail.setNavigationOnClickListener {
            (activity as MainActivity).supportFragmentManager.popBackStack()
        }
    }

    companion object {
        fun newInstance(listDishes: ArrayList<DishModel>): CartDetailFragment {
            return CartDetailFragment().apply {
                mListDishes = listDishes
            }
        }
    }
}