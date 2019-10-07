package com.uit.party.ui.main

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.uit.party.BR
import com.uit.party.R
import com.uit.party.databinding.ItemDishBinding
import com.uit.party.ui.main.list_dish.DishModel
import com.uit.party.ui.main.list_dish.ItemDishViewModel
import com.uit.party.util.BindableAdapter

class DishAdapter(private val itemClicked: DishItemOnClicked) : RecyclerView.Adapter<DishAdapter.DishViewHolder>(), BindableAdapter<DishModel> {
    private var dishList = ArrayList<DishModel>()
    private lateinit var binding: ItemDishBinding

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): DishViewHolder {
        binding = DataBindingUtil.inflate(
            LayoutInflater.from(parent.context),
            R.layout.item_dish,
            parent,
            false
        )
        return DishViewHolder(binding, itemClicked)
    }

    override fun getItemCount(): Int {
        return dishList.size
    }

    override fun onBindViewHolder(holder: DishViewHolder, position: Int) {
        holder.bind(dishList[position])
    }

    override fun setData(items: ArrayList<DishModel>) {
        dishList.clear()
        dishList = items
        notifyDataSetChanged()
    }

    interface DishItemOnClicked{
        fun onItemDishClicked(position: Int, item: DishModel)
    }

    class DishViewHolder(val binding: ItemDishBinding, private val itemClicked: DishItemOnClicked) : RecyclerView.ViewHolder(binding.root) {
        fun bind(dishModel: DishModel) {
            val itemViewModel = ItemDishViewModel()
            binding.setVariable(BR.itemViewModel, itemViewModel)
            binding.executePendingBindings()
            itemViewModel.init(dishModel)
            binding.root.setOnClickListener {
                itemClicked.onItemDishClicked(adapterPosition, dishModel)
            }
        }
    }
}