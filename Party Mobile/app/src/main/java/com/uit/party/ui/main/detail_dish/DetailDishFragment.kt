package com.uit.party.ui.main.detail_dish

import android.animation.Animator
import android.os.Bundle
import android.view.*
import androidx.appcompat.widget.Toolbar
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import androidx.navigation.fragment.navArgs
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.smarteist.autoimageslider.IndicatorAnimations
import com.smarteist.autoimageslider.SliderAnimations
import com.uit.party.R
import com.uit.party.databinding.FragmentDetailDishBinding
import com.uit.party.model.Account
import com.uit.party.ui.signin.login.LoginViewModel
import com.uit.party.util.SharedPrefs
import com.uit.party.util.rxbus.RxBus
import com.uit.party.util.rxbus.RxEvent
import io.reactivex.disposables.Disposable

class DetailDishFragment : Fragment() {
    private var viewModel = DetailDishViewModel()
    private lateinit var binding: FragmentDetailDishBinding
    private val mArgs: DetailDishFragmentArgs by navArgs()
    private lateinit var mDisposable: Disposable

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

        setupToolbar()
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
                    addToCart()
                    startAnimationAddToCard()
                    true
                }
                else -> false
            }
        }
    }

    private fun addToCart() {
        RxBus.publish(RxEvent.AddToCart(viewModel.mDishModel!!, null))
    }

    private fun deleteDish() {
        MaterialAlertDialogBuilder(context)
            .setIcon(resources.getDrawable(R.drawable.ic_alert, context?.theme))
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
        if (viewModel.mDishModel != null) {
            viewModel.init()
        }
        setupRecyclerView()
        listenDataChange()
    }

    private fun listenDataChange() {
        mDisposable = RxBus.listen(RxEvent.AddDish::class.java).subscribe {
            if (it.dishModel != null) {
                viewModel.mDishModel = it.dishModel
                viewModel.init()
            }
        }
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

    override fun onDestroy() {
        super.onDestroy()
        if (!mDisposable.isDisposed) mDisposable.dispose()
    }

    private fun setupRecyclerView() {
        binding.imageSlider.sliderAdapter = viewModel.mAdapter
        binding.imageSlider.startAutoCycle()
        binding.imageSlider.setIndicatorAnimation(IndicatorAnimations.WORM)
        binding.imageSlider.setSliderTransformAnimation(SliderAnimations.SIMPLETRANSFORMATION)

        binding.rvRating.adapter = viewModel.mRatingAdapter
    }

    private fun initData() {
        viewModel.mPosition = mArgs.position
        viewModel.mDishType = mArgs.dishType
        viewModel.mDishModel = mArgs.StringDishModel
    }
}