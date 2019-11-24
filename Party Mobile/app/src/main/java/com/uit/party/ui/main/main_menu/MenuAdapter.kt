package com.uit.party.ui.main.main_menu

import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.Filter
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.uit.party.BR
import com.uit.party.R
import com.uit.party.databinding.ItemMainMenuBinding
import com.uit.party.model.DishModel
import com.uit.party.model.MenuModel
import com.uit.party.util.BindableAdapter

class MenuAdapter : RecyclerView.Adapter<MenuAdapter.MenuViewHolder>(), BindableAdapter<DishModel> {
    private var mListDishMenuOrigin = ArrayList<DishModel>()
    private var mListDishMenuFiltered = ArrayList<DishModel>()
    private var mListMenuFiltered = ArrayList<MenuModel>()
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
        return mListMenuFiltered.size
    }

    override fun onBindViewHolder(holder: MenuViewHolder, position: Int) {
        holder.bind(mListMenuFiltered[position])
    }

    override fun setData(items: ArrayList<DishModel>) {
        mListDishMenuOrigin.clear()
        mListDishMenuOrigin = items

        mListDishMenuFiltered.clear()
        mListDishMenuFiltered = items

        mListMenuFiltered = menuAllocation(mListDishMenuOrigin)
        notifyDataSetChanged()
    }

    private fun menuAllocation(dishes: java.util.ArrayList<DishModel>): java.util.ArrayList<MenuModel> {
        val listMenu = ArrayList<MenuModel>()
        val listHolidayOffers = ArrayList<DishModel>()
        val listFirstDishes = ArrayList<DishModel>()
        val listMainDishes = ArrayList<DishModel>()
        val listSeafood = ArrayList<DishModel>()
        val listDrink = ArrayList<DishModel>()
        for (row in dishes) {
            when (row.type) {
                "Holiday Offers" -> listHolidayOffers.add(row)
                "First Dishes" -> listFirstDishes.add(row)
                "Main Dishes" -> listMainDishes.add(row)
                "Seafood" -> listSeafood.add(row)
                "Drinks" -> listDrink.add(row)
            }
        }
        if (listHolidayOffers.size > 0) {
            listMenu.add(MenuModel("Holiday Offers", listHolidayOffers))
        }
        if (listFirstDishes.size > 0) {
            listMenu.add(MenuModel("First Dishes", listFirstDishes))
        }
        if (listMainDishes.size > 0) {
            listMenu.add(MenuModel("Main Dishes", listMainDishes))
        }
        if (listSeafood.size > 0) {
            listMenu.add(MenuModel("Seafood", listSeafood))
        }
        if (listDrink.size > 0) {
            listMenu.add(MenuModel("Drinks", listDrink))
        }

        return listMenu
    }

    fun getFilter(): Filter {
        return object : Filter() {
            override fun performFiltering(p0: CharSequence?): FilterResults {
                val charString = p0.toString()
                mListDishMenuFiltered = if (charString.isEmpty()) {
                    mListDishMenuOrigin
                } else {
                    val filteredList = ArrayList<DishModel>()
                    for (row in mListDishMenuOrigin) {
                        if (row.name?.toLowerCase()?.contains(charString.toLowerCase()) == true) {
                            filteredList.add(row)
                        }
                    }
                    filteredList
                }

                val filterResults = FilterResults()
                filterResults.values = mListDishMenuFiltered
                return filterResults
            }

            override fun publishResults(p0: CharSequence?, p1: FilterResults?) {
                mListMenuFiltered = menuAllocation(p1?.values as ArrayList<DishModel>)
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