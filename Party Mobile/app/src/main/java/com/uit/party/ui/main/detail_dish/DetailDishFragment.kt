package com.uit.party.ui.main.detail_dish

import android.os.Bundle
import android.view.*
import androidx.appcompat.widget.Toolbar
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import androidx.navigation.fragment.navArgs
import com.uit.party.R
import com.uit.party.databinding.FragmentDetailDishBinding
import com.uit.party.model.Account
import com.uit.party.model.DishModel
import com.uit.party.ui.signin.login.LoginViewModel
import com.uit.party.util.SharedPrefs

class DetailDishFragment : Fragment() {
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
        binding = DataBindingUtil.inflate(
            LayoutInflater.from(context),
            R.layout.fragment_detail_dish,
            container,
            false
        )
        binding.viewModel = viewModel

        if (checkIsStaff()){
            setupToolbar()
        }
    }

    private fun checkIsStaff(): Boolean {
        val role =
            SharedPrefs().getInstance()[LoginViewModel.USER_INFO_KEY, Account::class.java]?.role
        return role.equals("nhanvien")
    }

    private fun setupToolbar() {
        setHasOptionsMenu(true)
        val toolbar = activity?.findViewById<View>(R.id.app_bar) as Toolbar
        toolbar.inflateMenu(R.menu.menu_dish_detail)
        toolbar.setOnMenuItemClickListener {
            if (it.itemId == R.id.toolbar_edit_dish) {
                val action = DetailDishFragmentDirections.actionDishDetailFragmentToModifyDishFragment(mDishModel)
                this.findNavController()
                    .navigate(action)
                true
            } else {
                false
            }
        }
    }

    override fun onCreateOptionsMenu(menu: Menu, inflater: MenuInflater) {
        inflater.inflate(R.menu.menu_dish_detail, menu)
        super.onCreateOptionsMenu(menu, inflater)
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