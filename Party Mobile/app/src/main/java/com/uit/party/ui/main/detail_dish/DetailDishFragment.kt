package com.uit.party.ui.main.detail_dish

import android.animation.Animator
import android.os.Bundle
import android.view.*
import androidx.appcompat.widget.Toolbar
import androidx.core.content.res.ResourcesCompat
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import androidx.navigation.fragment.navArgs
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.smarteist.autoimageslider.IndicatorAnimations
import com.smarteist.autoimageslider.SliderAnimations
import com.uit.party.R
import com.uit.party.data.home.getDatabase
import com.uit.party.databinding.FragmentDetailDishBinding
import com.uit.party.model.Account
import com.uit.party.model.ItemDishRateWithListRates
import com.uit.party.model.UserRole
import com.uit.party.util.Constants.Companion.USER_INFO_KEY
import com.uit.party.util.SharedPrefs

class DetailDishFragment : Fragment() {
    private lateinit var viewModel: DetailDishViewModel
    private lateinit var binding: FragmentDetailDishBinding
    private val mArgs: DetailDishFragmentArgs by navArgs()
    private val mRatingAdapter = DishRatingAdapter()

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

        val database = getDatabase(requireContext())
        viewModel = ViewModelProvider(this, DishDetailViewModelFactory(database)).get(DetailDishViewModel::class.java)
        binding.viewModel = viewModel

        setupToolbar()
        ratingClicked()
    }

    private fun ratingClicked(){
        binding.floatingActionButton.setOnClickListener {
            val onRatingDialogListener = object : OnRatingDialogListener {
                override fun onSubmitted(content: String, score: Float) {
                    viewModel.onSubmitClicked(content, score)
                }
            }
            val dialog = RatingDialog(onRatingDialogListener)
            dialog.showsDialog = true
            val frameManager = childFragmentManager
            dialog.show(frameManager, "Dialog Review")
        }
    }

    private fun checkIsStaff(): Boolean {
        val role =
            SharedPrefs().getInstance()[USER_INFO_KEY, Account::class.java]?.role
        return (role == UserRole.Admin.ordinal || role == UserRole.Staff.ordinal)
    }

    private fun setupToolbar() {
        setHasOptionsMenu(true)
        val toolbar = activity?.findViewById<View>(R.id.app_bar) as Toolbar

        toolbar.inflateMenu(R.menu.menu_dish_detail)

        toolbar.setOnMenuItemClickListener {
            when (it.itemId) {
                R.id.toolbar_edit_dish -> {
                    val action =
                        DetailDishFragmentDirections.actionDishDetailFragmentToModifyDishFragment(
                            position = viewModel.mPosition,
                            dishType = viewModel.mDishType,
                            StringDishModel = viewModel.mDishModel
                        )
                    this.findNavController()
                        .navigate(action)
                    true
                }
                R.id.toolbar_delete_dish -> {
                    deleteDish()
                    true
                }

                R.id.toolbar_add_to_cart -> {
                    viewModel.addToCart()
                    startAnimationAddToCard()
                    true
                }
                else -> false
            }
        }
    }

    private fun deleteDish() {
        MaterialAlertDialogBuilder(requireContext())
            .setIcon(context?.resources?.let { ResourcesCompat.getDrawable(it, R.drawable.ic_alert, context?.theme) })
            .setTitle(getString(R.string.delete_dish))
            .setMessage(getString(R.string.alert_delete_dish))
            .setPositiveButton(getString(R.string.delete)) { dialog, _ ->
                viewModel.deleteDish(binding.root, dialog)
            }
            .setNegativeButton(getString(R.string.cancel)) { dialog, _ ->
                dialog.dismiss()
            }
            .show()
    }

    override fun onCreateOptionsMenu(menu: Menu, inflater: MenuInflater) {
        inflater.inflate(R.menu.menu_dish_detail, menu)
        if (!checkIsStaff()) {
            menu.findItem(R.id.toolbar_edit_dish).isVisible = false
            menu.findItem(R.id.toolbar_delete_dish).isVisible = false
        }else{
            menu.findItem(R.id.toolbar_add_to_cart).isVisible = false
        }
        super.onCreateOptionsMenu(menu, inflater)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        initData()
        listenLiveData()
        if (viewModel.mDishModel != null) {
            viewModel.init()
        }
        setupRecyclerView()
    }

    private fun startAnimationAddToCard() {
        binding.lavAddToCart.visibility = View.VISIBLE
        binding.lavAddToCart.playAnimation()
        binding.lavAddToCart.addAnimatorListener(object : Animator.AnimatorListener {
            override fun onAnimationRepeat(animation: Animator?) {

            }

            override fun onAnimationEnd(animation: Animator?) {
                binding.lavAddToCart.cancelAnimation()
                binding.lavAddToCart.visibility = View.GONE
            }

            override fun onAnimationCancel(animation: Animator?) {
            }

            override fun onAnimationStart(animation: Animator?) {
            }
        })
    }

    private fun setupRecyclerView() {
        binding.imageSlider.sliderAdapter = viewModel.mAdapter
        binding.imageSlider.startAutoCycle()
        binding.imageSlider.setIndicatorAnimation(IndicatorAnimations.WORM)
        binding.imageSlider.setSliderTransformAnimation(SliderAnimations.SIMPLETRANSFORMATION)

        binding.rvRating.adapter = mRatingAdapter
    }

    private fun initData() {
        viewModel.mPosition = mArgs.position
        viewModel.mDishType = mArgs.dishType
        viewModel.mDishModel = mArgs.StringDishModel
        viewModel.getListRating()
    }

    private fun listenLiveData(){
        viewModel.mListRates.observe(viewLifecycleOwner, { list ->
            val item: ItemDishRateWithListRates? = list.find {
                it.itemDishRateModel.dishId == viewModel.mDishModel?.id
            }
            if (item != null){
                mRatingAdapter.submitList(item.listRatings)
            }
        })
    }
}