package com.uit.party.ui.main.book_party_success

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.uit.party.R
import com.uit.party.databinding.FragmentBookPartySuccessBinding

class BookPartySuccessFragment : Fragment(){

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val binding: FragmentBookPartySuccessBinding = DataBindingUtil.inflate(inflater, R.layout.fragment_book_party_success, container, false)
        binding.viewModel = BookPartySuccessViewModel()
        return binding.root
    }
}