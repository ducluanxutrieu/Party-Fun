package com.uit.party.ui.main.payment_party

import androidx.lifecycle.ViewModelProvider
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.navigation.fragment.navArgs
import com.uit.party.R
import com.uit.party.databinding.PaymentPartyFragmentBinding

class PaymentPartyFragment : Fragment() {
    lateinit var mBinding: PaymentPartyFragmentBinding

    private lateinit var viewModel: PaymentPartyViewModel
    private val myArgs: PaymentPartyFragmentArgs by navArgs()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        mBinding = DataBindingUtil.inflate(inflater, R.layout.payment_party_fragment, container, false)
        viewModel = PaymentPartyViewModel()
        mBinding.viewModel = viewModel
        return mBinding.root
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        viewModel = ViewModelProvider(this).get(PaymentPartyViewModel::class.java)
        viewModel.mBillModel = myArgs.billModel
    }

}