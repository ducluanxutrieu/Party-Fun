package com.uit.party.ui.main.main_menu

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.uit.party.BR
import com.uit.party.R
import com.uit.party.databinding.ItemMainMenuBinding
import com.uit.party.model.MenuModel
import com.uit.party.util.BindableAdapter

class MenuAdapter : RecyclerView.Adapter<MenuAdapter.MenuViewHolder>(), BindableAdapter<MenuModel> {
    private var dishMenu = ArrayList<MenuModel>()
    private lateinit var binding: ItemMainMenuBinding

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MenuViewHolder {
        binding = DataBindingUtil.inflate(
            LayoutInflater.from(parent.context),
            R.layout.item_main_menu,
            parent,
            false
        )
        return MenuViewHolder(binding)
    }

    override fun getItemCount(): Int {
        return dishMenu.size
    }

    override fun onBindViewHolder(holder: MenuViewHolder, position: Int) {
        holder.bind(dishMenu[position])
    }

    override fun setData(items: ArrayList<MenuModel>) {
        dishMenu.clear()
        dishMenu = items
        notifyDataSetChanged()
    }

    class MenuViewHolder(val binding: ItemMainMenuBinding) : RecyclerView.ViewHolder(binding.root) {
        fun bind(menuModel: MenuModel) {
            val itemViewModel = ItemMenuViewModel()
            binding.setVariable(BR.itemViewModel, itemViewModel)
            binding.executePendingBindings()
            itemViewModel.init(menuModel)
            binding.rvDishMain.adapter = itemViewModel.mDishesAdapter
        }
    }
}