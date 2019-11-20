package com.uit.party.ui.main.main_menu

import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.Filter
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.uit.party.BR
import com.uit.party.R
import com.uit.party.databinding.ItemMainMenuBinding
import com.uit.party.model.MenuModel
import com.uit.party.util.BindableAdapter
import java.util.*
import kotlin.collections.ArrayList

class MenuAdapter : RecyclerView.Adapter<MenuAdapter.MenuViewHolder>(), BindableAdapter<MenuModel> {
    private var mListDishMenuOrigin = ArrayList<MenuModel>()
    private var mListDishMenuFiltered = ArrayList<MenuModel>()
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
        return mListDishMenuFiltered.size
    }

    override fun onBindViewHolder(holder: MenuViewHolder, position: Int) {
        holder.bind(mListDishMenuFiltered[position])
    }

    override fun setData(items: ArrayList<MenuModel>) {
        mListDishMenuOrigin.clear()
        mListDishMenuOrigin = items

        mListDishMenuFiltered.clear()
        mListDishMenuFiltered = items
        notifyDataSetChanged()
    }

    fun getFilter(): Filter {
        return object : Filter() {
            override fun performFiltering(p0: CharSequence?): FilterResults {
                val charString = p0.toString()
                mListDishMenuFiltered = if (charString.isEmpty()) {
                    mListDishMenuOrigin
                } else {
                    val filteredList = ArrayList<MenuModel>()
                    for (row in mListDishMenuOrigin) {
                        val menuItem = MenuModel(row.menuName, ArrayList())
                        if (row.listDish.size != 0) {
                            row.listDish.forEach { dish ->
                                if (dish.name?.contains(charString.toLowerCase(Locale("vi"))) == true) {
                                    menuItem.listDish.add(dish)
                                }
                            }
                        }
                        if (row.listDish.size > 0) {
                            filteredList.add(menuItem)
                        }
                    }
                    filteredList
                }

                val filterResults = FilterResults()
                filterResults.values = mListDishMenuFiltered
                return filterResults
            }

            @Suppress("UNCHECKED_CAST")
            override fun publishResults(p0: CharSequence?, p1: FilterResults?) {
                mListDishMenuFiltered = p1?.values as ArrayList<MenuModel>
                notifyDataSetChanged()
            }
        }
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