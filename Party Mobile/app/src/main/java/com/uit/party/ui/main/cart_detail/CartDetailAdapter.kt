package com.uit.party.ui.main.cart_detail

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.uit.party.R
import com.uit.party.databinding.ItemCartDetailBinding
import com.uit.party.model.CartModel
import com.uit.party.util.BindableAdapter

class CartDetailAdapter : RecyclerView.Adapter<CartDetailAdapter.CartDetailViewHolder>(), BindableAdapter<CartModel> {
    private var mListCart = ArrayList<CartModel>()

    override fun setData(items: ArrayList<CartModel>) {
        mListCart = items
    }


    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CartDetailViewHolder {
        val binder = DataBindingUtil.inflate<ItemCartDetailBinding>(LayoutInflater.from(parent.context), R.layout.item_cart_detail, parent, false)
        return CartDetailViewHolder(binder)
    }

    override fun getItemCount(): Int {
        return mListCart.size
    }

    override fun onBindViewHolder(holder: CartDetailViewHolder, position: Int) {
        holder.bindData(mListCart[position])
    }


    class CartDetailViewHolder(private val mBinder: ItemCartDetailBinding): RecyclerView.ViewHolder(mBinder.root){
        private val mItemViewModel = CartDetailItemViewModel()

        fun bindData(cartModel: CartModel) {
            mBinder.itemViewModel = mItemViewModel
            mItemViewModel.initItemData(cartModel)
        }
    }
}