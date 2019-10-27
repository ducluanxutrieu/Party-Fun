package com.uit.party.ui.main.addnewdish

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.uit.party.R
import com.uit.party.databinding.FragmentAddNewDishBinding
import com.uit.party.model.Thumbnail
import com.uit.party.ui.main.MainActivity
import android.widget.AdapterView



class AddNewDishFragment : Fragment(){
    private lateinit var mBinding: FragmentAddNewDishBinding
    private lateinit var mActivity: MainActivity
    private lateinit var mViewModel: AddNewDishFragmentViewModel

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        mBinding = DataBindingUtil.inflate(inflater, R.layout.fragment_add_new_dish, container, false)
        mViewModel = AddNewDishFragmentViewModel(mActivity)
        mBinding.viewModel = mViewModel
        return mBinding.root
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        setupToolbar()
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

    @Suppress("DEPRECATION")
    private fun setupToolbar() {
        val toolbar = mBinding.toolbarAddDish
        toolbar.title = getString(R.string.add_dish)
        toolbar.setNavigationIcon(R.drawable.ic_arrow_back_green_24dp)
        toolbar.setNavigationOnClickListener{
            (context as MainActivity).onBackPressed()
        }
        toolbar.setTitleTextColor(resources.getColor(R.color.colorWhile))
    }

    companion object{
        fun newInstance(activity: MainActivity): AddNewDishFragment{
            return AddNewDishFragment().apply { this.mActivity = activity }
        }
    }
}