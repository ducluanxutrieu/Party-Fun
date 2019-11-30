package com.uit.party.ui.main.addnewdish

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.navArgs
import com.uit.party.R
import com.uit.party.databinding.FragmentAddNewDishBinding
import com.uit.party.model.Thumbnail


class AddNewDishFragment : Fragment() {
    private lateinit var mBinding: FragmentAddNewDishBinding
    private lateinit var mViewModel: AddNewDishFragmentViewModel
    private val myArgs: AddNewDishFragmentArgs by navArgs()
    private lateinit var mSpinnerAdapter: SpinnerAdapter

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        mBinding =
            DataBindingUtil.inflate(inflater, R.layout.fragment_add_new_dish, container, false)
        mViewModel = AddNewDishFragmentViewModel()
        mBinding.viewModel = mViewModel
        return mBinding.root
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        setupSpinner()
        getData()
    }

    private fun getData() {
        mViewModel.mDishModel = myArgs.StringDishModel
        if (mViewModel.mDishModel != null) {
            mViewModel.initData()
            for (i in Thumbnail.values().indices){
                if (Thumbnail.values()[i].dishName == mViewModel.mDishModel?.type){
                    val spinnerPosition = mSpinnerAdapter.getPosition(Thumbnail.values()[i])
                    mBinding.spinnerDishType.setSelection(spinnerPosition)
                }
            }
        }
    }

    private fun setupSpinner() {
        mSpinnerAdapter = SpinnerAdapter(this.context!!, R.layout.item_spinner_dish, Thumbnail.values())
        mBinding.spinnerDishType.adapter = mSpinnerAdapter
            mBinding.spinnerDishType.onItemSelectedListener =
            object : AdapterView.OnItemSelectedListener {
                override fun onItemSelected(
                    parent: AdapterView<*>,
                    view: View,
                    position: Int,
                    id: Long
                ) {
                    val thumbnail = parent.getItemAtPosition(position) as Thumbnail
                    mViewModel.mTypeText = thumbnail.dishName
                }

                override fun onNothingSelected(parent: AdapterView<*>) {
                    mViewModel.mTypeText = Thumbnail.Thumbnail1.dishName
                }
            }
    }
}