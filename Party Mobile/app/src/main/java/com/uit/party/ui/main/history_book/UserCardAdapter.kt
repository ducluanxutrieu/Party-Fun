package com.uit.party.ui.main.history_book

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.uit.party.R
import com.uit.party.databinding.ItemUserCardBinding
import com.uit.party.data.history_order.CartItem
import com.uit.party.util.BindableAdapter
import com.uit.party.util.TimeFormatUtil.formatTime12hToClient

class UserCardAdapter : RecyclerView.Adapter<UserCardAdapter.UserCardViewHolder>(), BindableAdapter<CartItem>{
    private val mListUserCart =  ArrayList<CartItem>()

    class UserCardViewHolder(private val binding: ItemUserCardBinding): RecyclerView.ViewHolder(binding.root){
        private val itemDishAdapter = ItemDishUserCartAdapter()
        private var isExpand = false

        @SuppressLint("SetTextI18n")
        fun bindData(userCart: CartItem) {
            binding.tvTimeBooking.text = userCart.dateParty.formatTime12hToClient()
            binding.tvNumberTableBooking.text = userCart.table.toString()
            binding.tvTotalPrice.text = "${userCart.total} VND"
            itemDishAdapter.setData(userCart.dishes)
            binding.rvListDishes.adapter = itemDishAdapter
            binding.rvListDishes.hasFixedSize()

            itemView.setOnClickListener {
                if (isExpand)
                {
                    binding.llListDishes.visibility = View.GONE
                }else{
                    binding.llListDishes.visibility = View.VISIBLE
                }
                isExpand = !isExpand
            }
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): UserCardViewHolder {
        val binding: ItemUserCardBinding = DataBindingUtil.inflate(LayoutInflater.from(parent.context), R.layout.item_user_card, parent, false)
        return UserCardViewHolder(binding)
    }

    override fun getItemCount(): Int {
        return mListUserCart.size
    }

    override fun onBindViewHolder(holder: UserCardViewHolder, position: Int) {
        holder.bindData(mListUserCart[position])
    }

    override fun setData(items: ArrayList<CartItem>) {
        mListUserCart.clear()
        mListUserCart.addAll(items)
        notifyDataSetChanged()
    }
}