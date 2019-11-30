package com.uit.party.ui.main.history_book

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.uit.party.R
import com.uit.party.databinding.ItemDishUserCartBinding
import com.uit.party.model.ListDishesCart

class ItemDishUserCartAdapter : RecyclerView.Adapter<ItemDishUserCartAdapter.UserCardViewHolder>(){
    private val mListDishes =  ArrayList<ListDishesCart>()

    class UserCardViewHolder(private val binding: ItemDishUserCartBinding): RecyclerView.ViewHolder(binding.root){
        fun bindData(dishCart: ListDishesCart) {
            binding.tvDishesNumber.text = dishCart.numberDish.toString()
            binding.tvNameDish.text = dishCart.name
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): UserCardViewHolder {
        val binding: ItemDishUserCartBinding = DataBindingUtil.inflate(LayoutInflater.from(parent.context), R.layout.item_dish_user_cart, parent, false)
        return UserCardViewHolder(binding)
    }

    override fun getItemCount(): Int {
        return mListDishes.size
    }

    override fun onBindViewHolder(holder: UserCardViewHolder, position: Int) {
        holder.bindData(mListDishes[position])
    }

    fun setData(items: ArrayList<ListDishesCart>) {
        mListDishes.clear()
        mListDishes.addAll(items)
        notifyDataSetChanged()
    }
}