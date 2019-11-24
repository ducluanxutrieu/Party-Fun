package com.uit.party.ui.main.detail_dish

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.uit.party.R
import com.uit.party.databinding.ItemImageDishDetailBinding
import com.uit.party.util.BindableAdapter

class DishDetailAdapter : RecyclerView.Adapter<DishDetailAdapter.DishDetailViewHolder>(),
    BindableAdapter<String>
{
    private var mListData = ArrayList<String>()

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): DishDetailViewHolder {
        val binding = DataBindingUtil.inflate<ItemImageDishDetailBinding>(LayoutInflater.from(parent.context), R.layout.item_image_dish_detail, parent, false)
        return DishDetailViewHolder(binding)
    }

    override fun getItemCount(): Int {
        return mListData.size
    }

    override fun onBindViewHolder(holder: DishDetailViewHolder, position: Int) {
        holder.bindData(mListData[position])
    }

    override fun setData(items: ArrayList<String>) {
        mListData = items
        notifyDataSetChanged()
    }

    class DishDetailViewHolder(private val mBinder: ItemImageDishDetailBinding): RecyclerView.ViewHolder(mBinder.root){
        fun bindData(url: String) {
            Glide.with(mBinder.root.context).load(url).error(R.drawable.dish_sample).into(mBinder.ivDish)
        }
    }
}