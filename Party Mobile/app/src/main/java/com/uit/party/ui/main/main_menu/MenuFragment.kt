package com.uit.party.ui.main.main_menu

import android.animation.Animator
import android.animation.AnimatorSet
import android.animation.ObjectAnimator
import android.content.Intent
import android.graphics.Bitmap
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.*
import androidx.appcompat.widget.AppCompatImageView
import androidx.appcompat.widget.SearchView
import androidx.appcompat.widget.Toolbar
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.RecyclerView
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout
import com.google.gson.Gson
import com.uit.party.R
import com.uit.party.databinding.FragmentListDishBinding
import com.uit.party.model.DishModel
import com.uit.party.ui.main.MainActivity
import com.uit.party.ui.signin.SignInActivity
import com.uit.party.util.SharedPrefs
import com.uit.party.util.ToastUtil
import com.uit.party.util.rxbus.RxBus
import com.uit.party.util.rxbus.RxEvent
import io.reactivex.disposables.Disposable

class MenuFragment : Fragment(), Toolbar.OnMenuItemClickListener {
    private val mViewModel = MenuViewModel()
    private lateinit var binding: FragmentListDishBinding
    private lateinit var mSwipeRefreshLayout: SwipeRefreshLayout

    private lateinit var mDisposableAddCart: Disposable
    private lateinit var mDisposableUpdateDish: Disposable
    private var mListDishesSelected = ArrayList<DishModel>()

    private lateinit var mDummyImgView: AppCompatImageView

    private lateinit var mSearchView: SearchView


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        setupBinding(container, inflater)
        setupRecyclerView()
        return binding.root
    }

    private fun setupRecyclerView() {
        binding.recyclerView.adapter = mViewModel.mMenuAdapter
        binding.recyclerView.setHasFixedSize(false)
        binding.recyclerView.addOnScrollListener(object : RecyclerView.OnScrollListener() {
            override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
                super.onScrolled(recyclerView, dx, dy)
                binding.fabAddDish.isExtended = dy < 0
            }
        })
    }

    private fun setupBinding(container: ViewGroup?, inflater: LayoutInflater) {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_list_dish, container, false)
        binding.viewModel = mViewModel
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        setPullToRefresh()
        rxBusListen()
        mDummyImgView = binding.ivCopy
        setupToolbar()
    }

    private fun setupToolbar() {
        setHasOptionsMenu(true)
        val toolbar = activity!!.findViewById<View>(R.id.app_bar) as Toolbar
        toolbar.inflateMenu(R.menu.main_menu)
        toolbar.setOnMenuItemClickListener(this)
    }

    override fun onCreateOptionsMenu(menu: Menu, inflater: MenuInflater) {
        inflater.inflate(R.menu.main_menu, menu)
        mSearchView = menu.findItem(R.id.toolbar_search).actionView as SearchView
        mSearchView.setOnQueryTextListener(object : SearchView.OnQueryTextListener {
            override fun onQueryTextSubmit(query: String?): Boolean {
                return true
            }

            override fun onQueryTextChange(newText: String?): Boolean {
                if (!newText.isNullOrEmpty()) {
                    Log.i(TAG, newText)
                }
                mViewModel.mMenuAdapter.getFilter().filter(newText)
                return true
            }

        })
        super.onCreateOptionsMenu(menu, inflater)
    }

    private fun setPullToRefresh() {
        mSwipeRefreshLayout = binding.swlListDish
        mSwipeRefreshLayout.setOnRefreshListener {
            mSwipeRefreshLayout.isRefreshing = true
            mViewModel.getListDishes {
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
                val action = MenuFragmentDirections.actionListDishFragmentToCartDetailFragment(
                    Gson().toJson(mListDishesSelected)
                )
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
        mViewModel.logout {
            if (it) {
                SharedPrefs().getInstance().clear()
                val intent = Intent(context, SignInActivity::class.java)
                startActivity(intent)
                (context as MainActivity).finish()
            } else {
                ToastUtil.showToast(getString(R.string.cannot_logout))
            }
        }
    }

    private fun rxBusListen() {
        mDisposableAddCart = RxBus.listen(RxEvent.AddToCart::class.java).subscribe {
            mListDishesSelected.add(it.dishModel)
//            val textFab = "${mListDishesSelected.size} Dishes Selected"
//            binding.fabAddDish.text = textFab

            if (it.cardDish != null) {
/*                val b = GlobalApplication().loadBitmapFromView(
                    it.cardDish,
                    it.cardDish.width,
                    it.cardDish.height
                )*/

                startAnimationAddToCard()
                //animateView(it.cardDish, b)
            }
        }

        mDisposableUpdateDish = RxBus.listen(RxEvent.AddDish::class.java).subscribe {
            if (it.dishModel != null) {
                mViewModel.mMenuAdapter.updateDish(it.dishModel, it.dishType, it.position)
            }
        }
    }

    private fun startAnimationAddToCard() {
        binding.lavAddToCart.visibility = View.VISIBLE
        binding.lavAddToCart.playAnimation()
        binding.lavAddToCart.addAnimatorListener(object : Animator.AnimatorListener{
            override fun onAnimationRepeat(animation: Animator?) {

            }

            override fun onAnimationEnd(animation: Animator?) {
                binding.lavAddToCart.cancelAnimation()
                binding.lavAddToCart.visibility = View.GONE
            }

            override fun onAnimationCancel(animation: Animator?) {
            }

            override fun onAnimationStart(animation: Animator?) {
//                        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
            }

        })
    }

    override fun onPause() {
        super.onPause()
        if (!mDisposableAddCart.isDisposed) mDisposableAddCart.dispose()
    }

    private fun animateView(foodCardView: View, b: Bitmap) {
        mDummyImgView.setImageBitmap(b)
        mDummyImgView.visibility = View.VISIBLE
        val u = IntArray(2)
        foodCardView.getLocationInWindow(u)
        mDummyImgView.left = foodCardView.left
        mDummyImgView.top = foodCardView.top
        val animSetXY = AnimatorSet()

        val y = ObjectAnimator.ofFloat(
            mDummyImgView,
            "translationY",
            (u[1] - 2 * 220).toFloat(),
//            (mDummyImgView.top).toFloat()
            0f
        )
        val x = ObjectAnimator.ofFloat(
            mDummyImgView,
            "translationX",
            (mDummyImgView.left).toFloat(),
//            (u[0] - 2 * 100).toFloat()
            (binding.root.width - 200).toFloat()
        )
        val sy = ObjectAnimator.ofFloat(mDummyImgView, "scaleY", 0.9f, 0f)
        val sx = ObjectAnimator.ofFloat(mDummyImgView, "scaleX", 0.9f, 0f)
        animSetXY.playTogether(x, y, sx, sy)
        animSetXY.duration = 650
        animSetXY.start()
    }

    companion object {
        private const val TAG = "MenuFragmentTag"
    }
}