package com.uit.party.ui.main.main_menu.menu_item

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.uit.party.BR
import com.uit.party.R
import com.uit.party.databinding.ItemDishBinding
import com.uit.party.model.DishModel
import com.uit.party.util.BindableAdapter

class DishesAdapter(private val itemClicked: DishItemOnClicked) : RecyclerView.Adapter<DishesAdapter.DishViewHolder>(), BindableAdapter<DishModel> {
    private var dishList = ArrayList<DishModel>()
    private lateinit var binding: ItemDishBinding
    private lateinit var mDishType: String

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): DishViewHolder {
        binding = DataBindingUtil.inflate(
            LayoutInflater.from(parent.context),
            R.layout.item_dish,
            parent,
            false
        )
        return DishViewHolder(mDishType, binding, itemClicked)
    }

    override fun getItemCount(): Int {
        return dishList.size
    }

    fun setDishesType(dishType: String){
        mDishType = dishType
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
        fun onItemDishClicked(dishType: String, position: Int, item: DishModel)
    }

    class DishViewHolder(val dishType: String, val binding: ItemDishBinding, private val itemClicked: DishItemOnClicked) : RecyclerView.ViewHolder(binding.root) {
        fun bind(dishModel: DishModel) {
            val itemViewModel = ItemDishViewModel()
            binding.setVariable(BR.itemViewModel, itemViewModel)
            binding.executePendingBindings()
            itemViewModel.init(dishModel)
            binding.root.setOnClickListener {
                itemClicked.onItemDishClicked(dishType, adapterPosition, dishModel)
            }
        }
    }
}