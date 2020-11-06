package com.uit.party.ui.main.book_party

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.navArgs
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.uit.party.R
import com.uit.party.data.getDatabase
import com.uit.party.databinding.FragmentBookPartyBinding
import com.uit.party.model.CartModel
import com.uit.party.util.UiUtil.afterTextChanged
import com.uit.party.util.UiUtil.getNumber

class BookPartyFragment : Fragment(){
    private val myArgs : BookPartyFragmentArgs by navArgs()
    private lateinit var mViewModel: BookPartyViewModel
    private lateinit var binding: FragmentBookPartyBinding

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_book_party, container, false)
        val database = getDatabase(requireContext())
        mViewModel = ViewModelProvider(this, BookPartyViewModelFactory(database.cartDao)).get(BookPartyViewModel::class.java)
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