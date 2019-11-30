package com.uit.party.ui.main.history_book

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.uit.party.R
import com.uit.party.databinding.ItemUserCardBinding
import com.uit.party.model.UserCart
import com.uit.party.util.BindableAdapter
import com.uit.party.util.TimeFormatUtil

class UserCardAdapter : RecyclerView.Adapter<UserCardAdapter.UserCardViewHolder>(), BindableAdapter<UserCart>{
    private val mListUserCart =  ArrayList<UserCart>()

    class UserCardViewHolder(private val binding: ItemUserCardBinding): RecyclerView.ViewHolder(binding.root){
        private val itemDishAdapter = ItemDishUserCartAdapter()
        private var isExpand = false

        @SuppressLint("SetTextI18n")
        fun bindData(userCart: UserCart) {
            binding.tvTimeBooking.text = TimeFormatUtil.formatTime12hToClient(userCart.dateParty)
            binding.tvNumberTableBooking.text = userCart.numbertable.toString()
            binding.tvTotalPrice.text = "${userCart.totalMoney} VND"
            userCart.listDishesCart?.let { itemDishAdapter.setData(it) }
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

    override fun setData(items: ArrayList<UserCart>) {
        mListUserCart.clear()
        mListUserCart.addAll(items)
        notifyDataSetChanged()
    }
}