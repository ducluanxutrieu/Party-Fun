package com.uit.party.ui.main.addnewdish

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.uit.party.R
import com.uit.party.databinding.FragmentAddNewDishBinding
import com.uit.party.model.Thumbnail


class AddNewDishFragment : Fragment(){
    private lateinit var mBinding: FragmentAddNewDishBinding
    private lateinit var mViewModel: AddNewDishFragmentViewModel

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        mBinding = DataBindingUtil.inflate(inflater, R.layout.fragment_add_new_dish, container, false)
        mViewModel = AddNewDishFragmentViewModel()
        mBinding.viewModel = mViewModel
        return mBinding.root
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        setupSpinner()
    }

    private fun setupSpinner() {
        mBinding.spinnerDishType.adapter = SpinnerAdapter(this.context!!, R.layout.item_spinner_dish, Thumbnail.values())
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