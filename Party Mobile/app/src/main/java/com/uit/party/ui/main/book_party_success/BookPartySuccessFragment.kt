package com.uit.party.ui.main.book_party_success

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.navArgs
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.uit.party.R
import com.uit.party.databinding.FragmentBookPartySuccessBinding
import com.uit.party.model.CartModel
import com.uit.party.util.UiUtil.afterTextChanged
import com.uit.party.util.UiUtil.getNumber

class BookPartySuccessFragment : Fragment(){
    private val myArgs : BookPartySuccessFragmentArgs by navArgs()
    private val mViewModel = BookPartySuccessViewModel()
    private lateinit var binding: FragmentBookPartySuccessBinding

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_book_party_success, container, false)
        binding.viewModel = mViewModel
        return binding.root
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        val data = myArgs.listCart
        if (!data.isNullOrEmpty()) {
            val listType = object : TypeToken<List<CartModel?>?>() {}.type
            val list: List<CartModel> = Gson().fromJson(data, listType)
            mViewModel.listCartStorage = list
        }

        mViewModel.setTotalPrice()

        binding.etCustomer.afterTextChanged {
            val num = it.getNumber()
            binding.etCustomer.setText(num.toString())
            mViewModel.mNumberCustomer = num
        }

        binding.etTable.afterTextChanged {
            val num = it.getNumber()
            binding.etTable.setText(num.toString())
            mViewModel.mNumberTable = num
            mViewModel.setTotalPrice()
        }
    }
}