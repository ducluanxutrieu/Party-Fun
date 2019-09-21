package com.uit.party.util

import androidx.appcompat.widget.AppCompatImageView
import androidx.databinding.BindingAdapter
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.request.RequestOptions
import com.google.android.material.textfield.TextInputLayout
import java.util.*


@Suppress("UNCHECKED_CAST")
@BindingAdapter("app:data")
fun <T> setupRecyclerView(recyclerView: RecyclerView, items: ArrayList<T>) {
    recyclerView.setHasFixedSize(true)
    val layoutManager = LinearLayoutManager(recyclerView.context, RecyclerView.VERTICAL, false)
    recyclerView.layoutManager = layoutManager

    if (recyclerView.adapter is BindableAdapter<*>) {
        (recyclerView.adapter as BindableAdapter<T>).setData(items)
    }
}

@BindingAdapter("app:imageUrl")
fun setImageIcon(imageView: AppCompatImageView, url: String?) {
    val requestOptions = RequestOptions()
//        .error(R.drawable.ic_round_account)
//        .placeholder(R.drawable.ic_round_account)
        .circleCrop()
    Glide.with(imageView.context).load(url).apply(requestOptions).into(imageView)
}

@BindingAdapter("bind:textError")
fun setTextError(textInput: TextInputLayout, error: String?) {
    if (!error.isNullOrEmpty()) {
        textInput.error = error
        textInput.isErrorEnabled = true
    }else{
        textInput.error = ""
        textInput.isErrorEnabled = false
    }
}