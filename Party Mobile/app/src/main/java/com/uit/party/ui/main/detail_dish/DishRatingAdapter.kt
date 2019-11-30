package com.uit.party.ui.main.detail_dish

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.RecyclerView
import com.uit.party.R
import com.uit.party.databinding.ItemRatingBinding
import com.uit.party.model.ListRate
import com.uit.party.util.BindableAdapter
import com.uit.party.util.TimeFormatUtil

class DishRatingAdapter : RecyclerView.Adapter<DishRatingAdapter.DishRatingViewHolder>(),
    BindableAdapter<ListRate> {

    private val mListRate = ArrayList<ListRate>()

    override fun onCreateViewHolder(
        parent: ViewGroup,
        viewType: Int
    ): DishRatingViewHolder {
        val binding: ItemRatingBinding = DataBindingUtil.inflate(
            LayoutInflater.from(parent.context),
            R.layout.item_rating,
            parent,
            false
        )
        return DishRatingViewHolder(binding)
    }

    override fun getItemCount(): Int {
        return mListRate.size
    }

    override fun onBindViewHolder(holder: DishRatingViewHolder, position: Int) {
        holder.bindData(mListRate[position])
    }

    override fun setData(items: ArrayList<ListRate>) {
        mListRate.clear()
        mListRate.addAll(items)
    }

    class DishRatingViewHolder(private val binding: ItemRatingBinding) :
        RecyclerView.ViewHolder(binding.root) {
        fun bindData(listRate: ListRate) {
            binding.tvUsernameRating.text = listRate.username
            binding.tvContentRating.text = listRate.content
            binding.ratingBar.rating = listRate.scorerate ?: 5f
            binding.tvTimeRating.text = TimeFormatUtil.formatDate12hToClient(listRate.createAt)
        }
    }
}