package com.uit.party.ui.main.main_menu

import android.animation.Animator
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.*
import androidx.appcompat.widget.Toolbar
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.RecyclerView
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout
import com.uit.party.R
import com.uit.party.data.getDatabase
import com.uit.party.databinding.FragmentListDishBinding
import com.uit.party.model.CartModel
import com.uit.party.ui.main.MainActivity
import com.uit.party.ui.signin.SignInActivity
import com.uit.party.util.UiUtil
import com.uit.party.util.rxbus.RxBus
import com.uit.party.util.rxbus.RxEvent
import io.reactivex.disposables.Disposable
import kotlinx.coroutines.launch

class MenuFragment : Fragment(), Toolbar.OnMenuItemClickListener {
    private lateinit var mViewModel: MenuViewModel
    private lateinit var binding: FragmentListDishBinding
    private lateinit var mSwipeRefreshLayout: SwipeRefreshLayout
    private val mMenuAdapter = MenuAdapter()

    private var mDisposableAddCart: Disposable? = null
    private lateinit var mDisposableUpdateDish: Disposable


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        setupBinding(container, inflater)
        setupRecyclerView()
        listenLiveData()
        return binding.root
    }

    private fun setupRecyclerView() {
        binding.recyclerView.adapter = mMenuAdapter
        binding.recyclerView.setHasFixedSize(false)
        binding.recyclerView.isNestedScrollingEnabled = false
        binding.recyclerView.addOnScrollListener(object : RecyclerView.OnScrollListener() {
            override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
                super.onScrolled(recyclerView, dx, dy)
                binding.fabAddDish.isExtended = dy < 0
            }
        })
    }

    private fun listenLiveData() {
        mViewModel.listMenu.observe(viewLifecycleOwner, {
            val listMenu = mViewModel.menuAllocation(it)
            mMenuAdapter.submitList(listMenu)
            mViewModel.mShowMenu.set(listMenu.isNotEmpty())
        })
    }

    private fun setupBinding(container: ViewGroup?, inflater: LayoutInflater) {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_list_dish, container, false)
        val database = getDatabase(this.requireContext())
        mViewModel =
            ViewModelProvider(this, HomeViewModelFactory(database)).get(MenuViewModel::class.java)
        binding.viewModel = mViewModel
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        setPullToRefresh()
        rxBusListen()
        setupToolbar()
    }

    private fun setupToolbar() {
        setHasOptionsMenu(true)
        val toolbar = activity?.findViewById<View>(R.id.app_bar) as Toolbar
        toolbar.inflateMenu(R.menu.main_menu)
        toolbar.setOnMenuItemClickListener(this)
    }

    override fun onCreateOptionsMenu(menu: Menu, inflater: MenuInflater) {
        inflater.inflate(R.menu.main_menu, menu)
        super.onCreateOptionsMenu(menu, inflater)
    }

    private fun setPullToRefresh() {
        mSwipeRefreshLayout = binding.swlListDish
        mSwipeRefreshLayout.setOnRefreshListener {
            mSwipeRefreshLayout.isRefreshing = true
            lifecycleScope.launch {
                mViewModel.getListDishes()
                mSwipeRefreshLayout.isRefreshing = false
            }
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            mSwipeRefreshLayout.setColorSchemeColors(
                resources.getColor(R.color.colorPrimary, context?.theme),
                resources.getColor(android.R.color.holo_green_dark, context?.theme),
                resources.getColor(android.R.color.holo_orange_dark, context?.theme),
                resources.getColor(android.R.color.holo_blue_dark, context?.theme)
            )
        }
    }

    override fun onMenuItemClick(item: MenuItem?): Boolean {
        when (item?.itemId) {
            R.id.toolbar_search -> {
                Log.i("MenuFragment", "SearchClicked")
                return true
            }

            R.id.toolbar_cart -> {
                val action = MenuFragmentDirections.actionListDishFragmentToCartDetailFragment()
                this.findNavController().navigate(action)
                return true
            }

            R.id.log_out -> {
                logOut()
            }
        }
        return false
    }

    private fun logOut() {
        lifecycleScope.launch {
            try {
                mViewModel.logout()
                val intent = Intent(context, SignInActivity::class.java)
                startActivity(intent)
                (context as MainActivity).finish()
            } catch (error: Exception) {
                UiUtil.showToast(error.message ?: "")
            }
        }
    }

    private fun rxBusListen() {
        if (mDisposableAddCart == null) {
            mDisposableAddCart = RxBus.listen(RxEvent.AddToCart::class.java).subscribe {
                mViewModel.addDishToCart(CartModel(it.dishModel.id, name = it.dishModel.name, price = it.dishModel.price, newPrice = it.dishModel.newPrice, quantity = 1, featureImage = it.dishModel.featureImage))
                startAnimationAddToCard()
            }
        }

        mDisposableUpdateDish = RxBus.listen(RxEvent.AddDish::class.java).subscribe {
            if (it.dishModel != null) {
                mViewModel.addNewDish(it.dishModel)
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
        if (mDisposableAddCart?.isDisposed == false) mDisposableAddCart?.dispose()
    }
}