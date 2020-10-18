package com.uit.party.ui.main.detail_dish

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import com.uit.party.R
import com.uit.party.databinding.ItemRatingBinding
import com.uit.party.model.RateModel
import com.uit.party.util.TimeFormatUtil

class DishRatingAdapter :
    ListAdapter<RateModel, DishRatingAdapter.DishRatingViewHolder>(DIFF_CALLBACK) {


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

    override fun onBindViewHolder(holder: DishRatingViewHolder, position: Int) {
        holder.bindData(getItem(position))
    }

    class DishRatingViewHolder(private val binding: ItemRatingBinding) :
        RecyclerView.ViewHolder(binding.root) {
        fun bindData(listRate: RateModel) {
            binding.tvUsernameRating.text = listRate.user_rate
            binding.tvContentRating.text = listRate.comment
            binding.ratingBar.rating = listRate.score ?: 5f
            binding.tvTimeRating.text = TimeFormatUtil.formatDateToClient(listRate.update_at)
        }
    }

    companion object {
        private val DIFF_CALLBACK = object : DiffUtil.ItemCallback<RateModel>() {
            override fun areItemsTheSame(oldItem: RateModel, newItem: RateModel): Boolean {
                return oldItem._id == newItem._id
            }

            override fun areContentsTheSame(oldItem: RateModel, newItem: RateModel): Boolean {
                return (oldItem.avatar == newItem.avatar &&
                        oldItem.comment == newItem.comment &&
                        oldItem.score == newItem.score)
            }

        }
    }
}