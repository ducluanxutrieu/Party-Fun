package com.uit.party.ui.main.cart_detail

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.uit.party.BR
import com.uit.party.R
import com.uit.party.databinding.ItemCartDetailBinding
import com.uit.party.model.CartModel
import com.uit.party.util.BindableAdapter

interface OnCartDetailListener {
    fun onChangeNumberDish(position: Int, cartModel: CartModel, isIncrease: Boolean)
    fun onDeleteDish(position: Int)
}

class CartDetailAdapter(private val mListener: OnCartDetailListener) :
    RecyclerView.Adapter<CartDetailAdapter.CartDetailViewHolder>(), BindableAdapter<CartModel> {
    private var mListCart = ArrayList<CartModel>()

    override fun setData(items: ArrayList<CartModel>) {
        mListCart = items
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CartDetailViewHolder {
        val binder = DataBindingUtil.inflate<ItemCartDetailBinding>(
            LayoutInflater.from(parent.context),
            R.layout.item_cart_detail,
            parent,
            false
        )
        return CartDetailViewHolder(mListener, binder)
    }

    override fun getItemCount(): Int {
        return mListCart.size
    }

    override fun onBindViewHolder(holder: CartDetailViewHolder, position: Int) {
        holder.bindData(mListCart[position])
    }


    class CartDetailViewHolder(
        private val mListener: OnCartDetailListener,
        private val mBinder: ItemCartDetailBinding
    ) : RecyclerView.ViewHolder(mBinder.root) {
        private val mItemViewModel = CartDetailItemViewModel()

        fun bindData(cartModel: CartModel) {
            mBinder.setVariable(BR.itemViewModel, mItemViewModel)
            mBinder.executePendingBindings()
            mItemViewModel.initItemData(cartModel)
            mBinder.btnReduction.setOnClickListener {
                var numberDish = mItemViewModel.mNumberDishInType.get()?.toInt()
                if (numberDish != null && numberDish > 1 && cartModel.dishModel.price != null) {
                    --numberDish
                    mItemViewModel.mDishPrice.set("${numberDish * cartModel.dishModel.price!!.toInt()} Đ")
                    mItemViewModel.mNumberDishInType.set(numberDish.toString())
                    cartModel.numberDish = numberDish
                    mListener.onChangeNumberDish(adapterPosition, cartModel, false)
                }
            }

            mBinder.btnIncrease.setOnClickListener {
                var numberDish = mItemViewModel.mNumberDishInType.get()?.toInt()
                if (numberDish != null && cartModel.dishModel.price!= null) {
                    ++numberDish
                    mItemViewModel.mDishPrice.set("${numberDish * cartModel.dishModel.price!!.toInt()} Đ")
                    mItemViewModel.mNumberDishInType.set(numberDish.toString())
                    cartModel.numberDish = numberDish
                    mListener.onChangeNumberDish(adapterPosition, cartModel, true)
                }
            }

            mBinder.btnDeleteDish.setOnClickListener {
                mListener.onDeleteDish(adapterPosition)
            }

        }
    }
}