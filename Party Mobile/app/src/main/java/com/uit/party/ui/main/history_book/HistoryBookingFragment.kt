package com.uit.party.ui.main.history_book

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.uit.party.R
import com.uit.party.databinding.FragmentHistoryBookingBinding

class HistoryBookingFragment : Fragment(){
    private lateinit var mBinding: FragmentHistoryBookingBinding
    private val mViewModel = HistoryBookingViewModel()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        mBinding = DataBindingUtil.inflate(inflater, R.layout.fragment_history_booking, container, false)
        mBinding.viewModel = mViewModel
        return mBinding.root
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        setupRecyclerView()
    }

    private fun setupRecyclerView() {
        mBinding.rvListOrdered.adapter = mViewModel.mListUserCardAdapter
    }
}