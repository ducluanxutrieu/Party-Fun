package com.uit.party.ui.main.detail_dish

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import com.uit.party.R
import com.uit.party.databinding.FragmentDetailDishBinding
import com.uit.party.model.DishModel
import com.uit.party.ui.main.MainActivity

class DetailDishFragment : Fragment(){
    private lateinit var model: DishModel
    private var position: Int = 0
    private var viewModel = DetailDishViewModel()
    private lateinit var binding: FragmentDetailDishBinding


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        binding = setupBinding(container)
        return binding.root
    }

    private fun setupBinding(
        container: ViewGroup?
    ): FragmentDetailDishBinding {
        val mBinding = DataBindingUtil.inflate<FragmentDetailDishBinding>(LayoutInflater.from(context), R.layout.fragment_detail_dish, container, false)
        mBinding.viewModel = viewModel
        return mBinding
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        viewModel.init(model)

        setupActionBar()
    }

    private fun setupActionBar() {
        binding.appBar.setNavigationIcon(R.drawable.ic_arrow_back_while_24dp)
        binding.appBar.title = model.name
        binding.appBar.setTitleTextColor(resources.getColor(R.color.colorWhile))
        binding.appBar.setNavigationOnClickListener {
            (context as MainActivity).onBackPressed()
        }

        binding.appBar.inflateMenu(R.menu.toolbar_menu)
        binding.appBar.setOnMenuItemClickListener {
            when(it.itemId){
                R.id.ToolbarFilterIcon -> {
                    Toast.makeText(context, "Filter Clicked", Toast.LENGTH_SHORT).show()
                    true
                }

                R.id.ToolbarSearchIcon -> {
                    Toast.makeText(context, "Search Clicked", Toast.LENGTH_SHORT).show()
                    true
                }

                else -> super.onOptionsItemSelected(it)
            }
        }
    }

    companion object{
        fun newInstance(model: DishModel, position: Int): DetailDishFragment{
            return DetailDishFragment().apply {
                this.model = model
                this.position = position
            }
        }
    }
}