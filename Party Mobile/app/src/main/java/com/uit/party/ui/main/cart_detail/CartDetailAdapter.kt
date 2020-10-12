package com.uit.party.ui.main.cart_detail

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.uit.party.BR
import com.uit.party.R
import com.uit.party.databinding.ItemCartDetailBinding
import com.uit.party.model.DishModel

interface OnCartDetailListener {
    fun onChangeNumberDish(dishModel: DishModel, isIncrease: Boolean)
}

class CartDetailAdapter(private val mListener: OnCartDetailListener) :
    ListAdapter<DishModel, CartDetailAdapter.CartDetailViewHolder>(DIFF_CALLBACK) {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CartDetailViewHolder {
        val binder = DataBindingUtil.inflate<ItemCartDetailBinding>(
            LayoutInflater.from(parent.context),
            R.layout.item_cart_detail,
            parent,
            false
        )
        return CartDetailViewHolder(mListener, binder)
    }

    override fun onBindViewHolder(holder: CartDetailViewHolder, position: Int) {
        holder.bindData(getItem(position))
    }

    fun getSingleItem(position: Int): DishModel{
        return  getItem(position)
    }

    class CartDetailViewHolder(
        private val mListener: OnCartDetailListener,
        private val mBinder: ItemCartDetailBinding
    ) : RecyclerView.ViewHolder(mBinder.root) {
        private val mItemViewModel = CartDetailItemViewModel()

        fun bindData(dishModel: DishModel) {
            mBinder.setVariable(BR.itemViewModel, mItemViewModel)
            mBinder.executePendingBindings()
            mItemViewModel.initItemData(dishModel)
            mBinder.btnReduction.setOnClickListener {
                var numberDish = mItemViewModel.mNumberDishInType.get()?.toInt()
                if (numberDish != null && numberDish > 1 && dishModel.price != null) {
                    --numberDish
                    mItemViewModel.mDishPrice.set("${numberDish * dishModel.price.toInt()} Đ")
                    mItemViewModel.mNumberDishInType.set(numberDish.toString())
                    dishModel.quantity = numberDish
                    mListener.onChangeNumberDish(dishModel, false)
                }
            }

            mBinder.btnIncrease.setOnClickListener {
                var numberDish = mItemViewModel.mNumberDishInType.get()?.toInt()
                if (numberDish != null && dishModel.price!= null) {
                    ++numberDish
                    mItemViewModel.mDishPrice.set("${numberDish * dishModel.price.toInt()} Đ")
                    mItemViewModel.mNumberDishInType.set(numberDish.toString())
                    dishModel.quantity = numberDish
                    mListener.onChangeNumberDish(dishModel, true)
                }
            }
        }
    }

    companion object{
        private val DIFF_CALLBACK = object : DiffUtil.ItemCallback<DishModel>(){
            override fun areItemsTheSame(oldItem: DishModel, newItem: DishModel): Boolean {
                return oldItem.id == newItem.id
            }

            override fun areContentsTheSame(oldItem: DishModel, newItem: DishModel): Boolean {
                return (oldItem.quantity == newItem.quantity &&
                        oldItem.name == newItem.name)
            }

        }
    }
}