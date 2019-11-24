package com.uit.party.ui.main.detail_dish

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.navArgs
import com.uit.party.R
import com.uit.party.databinding.FragmentDetailDishBinding
import com.uit.party.model.DishModel

class DetailDishFragment : Fragment(){
    private lateinit var mDishModel: DishModel
    private var mPosition: Int = 0
    private var viewModel = DetailDishViewModel()
    private lateinit var mDishType: String
    private lateinit var binding: FragmentDetailDishBinding
    private val mArgs: DetailDishFragmentArgs by navArgs()

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        setupBinding(container)
        return binding.root
    }

    private fun setupBinding(container: ViewGroup?) {
        binding = DataBindingUtil.inflate(LayoutInflater.from(context), R.layout.fragment_detail_dish, container, false)
        binding.viewModel = viewModel
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        initData()
        viewModel.init(mDishModel)
        setupRecyclerView()
    }

    private fun setupRecyclerView() {
        binding.rvImagesDish.adapter = viewModel.mAdapter
    }

    private fun initData() {
        mPosition = mArgs.position
        mDishType = mArgs.dishType
        mDishModel = mArgs.StringDishModel
    }
}