package com.uit.party.ui.main.main_menu

import android.animation.AnimatorSet
import android.animation.ObjectAnimator
import android.content.Intent
import android.graphics.Bitmap
import android.os.Build
import android.os.Bundle
import android.view.*
import androidx.appcompat.widget.AppCompatImageView
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout
import com.google.android.material.navigation.NavigationView
import com.uit.party.R
import com.uit.party.databinding.FragmentListDishBinding
import com.uit.party.model.Account
import com.uit.party.model.DishModel
import com.uit.party.ui.main.MainActivity
import com.uit.party.ui.main.addnewdish.AddNewDishFragment
import com.uit.party.ui.main.cart_detail.CartDetailFragment
import com.uit.party.ui.signin.SignInActivity
import com.uit.party.ui.signin.login.LoginViewModel
import com.uit.party.util.*
import com.uit.party.util.rxbus.RxBus
import com.uit.party.util.rxbus.RxEvent
import io.reactivex.disposables.Disposable


@Suppress("DEPRECATION")
class MenuFragment : Fragment(),
    NavigationView.OnNavigationItemSelectedListener {
    private var avatarUrl: String? = ""
    private var username: String = ""
    private var fullName: String = ""

    private val mViewModel = MenuViewModel()
    private lateinit var binding: FragmentListDishBinding
    private val adapter = MenuAdapter()
    private lateinit var mSwipeRefreshLayout: SwipeRefreshLayout

    private var mIsAdmin = false

    private lateinit var mDisposableAddCart: Disposable
    private var mListDishesSelected = ArrayList<DishModel>()

    private lateinit var mDummyImgView: AppCompatImageView


    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        setupBinding(container, inflater)

        return binding.root
    }

    private fun setupBinding(container: ViewGroup?, inflater: LayoutInflater) {
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_list_dish, container, false)

        binding.viewModel = mViewModel
        mViewModel.init()
        binding.recyclerView.adapter = adapter

        mIsAdmin = checkAdmin()

        setIsAdmin()
    }

    private fun setIsAdmin() {
        if (mIsAdmin) {
            binding.fabAddDish.icon = resources.getDrawable(R.drawable.plus)
            binding.fabAddDish.text = StringUtil.getString(R.string.add_dish)
            binding.fabAddDish.setOnClickListener {
                val fragment = AddNewDishFragment.newInstance(context as MainActivity)
//                AddNewFragment().addNewSlideUp(
//                    R.id.main_container,
//                    fragment,
//                    true,
//                    context as MainActivity
//                )
            }
        } else {
            binding.fabAddDish.icon = resources.getDrawable(R.drawable.ic_shopping_cart_vd_theme_24)
            binding.fabAddDish.setOnClickListener {
                val fragment = CartDetailFragment.newInstance(mListDishesSelected)
//                AddNewFragment().addNewSlideUp(
//                    R.id.main_container,
//                    fragment,
//                    true,
//                    context as MainActivity
//                )
            }
        }
    }

    private fun checkAdmin(): Boolean {
        val role =
            SharedPrefs().getInstance()[LoginViewModel.USER_INFO_KEY, Account::class.java]?.role
        return role.equals("Admin")
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
//        setupDrawer()
        setPullToRefresh()
        rxBusListen()
        mDummyImgView = binding.ivCopy
    }

    /*private fun setupDrawer() {
        if (!avatarUrl.isNullOrEmpty()) {
            Glide.with(context!!).load(avatarUrl).apply { RequestOptions.circleCropTransform() }
                .into(headerBinding.ivAvatar)
        }

        if (username.isNotEmpty()) {
            headerBinding.tvUsername.text = username
        }
        if (fullName.isNotEmpty()) {
            headerBinding.tvFullName.text = fullName
        }
    }*/

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

    override fun onCreateOptionsMenu(menu: Menu, inflater: MenuInflater) {
        super.onCreateOptionsMenu(menu, inflater)
        inflater.inflate(R.menu.toolbar_menu, menu)

//        val searchView = menu.findItem(R.id.toolbar_search)
        //TODO add search view
    }

    override fun onNavigationItemSelected(item: MenuItem): Boolean {
        // Handle navigation view item clicks here.
        when (item.itemId) {
            R.id.log_out -> {
                logOut()
            }
            R.id.naw_user_order -> {
                ToastUtil().showToast("Your Order clicked")
            }
        }

//        binding.drawerLayout.closeDrawer(GravityCompat.START)
        return true
    }

    private fun logOut() {
        SharedPrefs().getInstance().clear()
        mViewModel.logout {
            if (it) {
                val intent = Intent(context, SignInActivity::class.java)
                startActivity(intent)
                (context as MainActivity).finish()
            } else {
                ToastUtil().showToast(getString(R.string.cannot_logout))
            }
        }
    }

    private fun rxBusListen() {
        mDisposableAddCart = RxBus.listen(RxEvent.AddToCart::class.java).subscribe {
            mListDishesSelected.add(it.dishModel)
            val textFab = "${mListDishesSelected.size} Dishes Selected"
            binding.fabAddDish.text = textFab

            val b = GlobalApplication().loadBitmapFromView(
                it.cardDish,
                it.cardDish.width,
                it.cardDish.height
            )
            animateView(it.cardDish, b)
        }
    }

    private fun animateView(foodCardView: View, b: Bitmap) {
        mDummyImgView.setImageBitmap(b)
        mDummyImgView.visibility = View.VISIBLE
        val u = IntArray(2)
        binding.fabAddDish.getLocationInWindow(u)
        mDummyImgView.left = foodCardView.left
        mDummyImgView.top = foodCardView.top
        val animSetXY = AnimatorSet()
        val y = ObjectAnimator.ofFloat(
            mDummyImgView,
            "translationY",
            (mDummyImgView.top).toFloat(),
            (u[1] - 2 * 220).toFloat()
        )
        val x = ObjectAnimator.ofFloat(
            mDummyImgView,
            "translationX",
            (mDummyImgView.left).toFloat(),
            (u[0] - 2 * 100).toFloat()
        )
        val sy = ObjectAnimator.ofFloat(mDummyImgView, "scaleY", 0.8f, 0.1f)
        val sx = ObjectAnimator.ofFloat(mDummyImgView, "scaleX", 0.8f, 0.1f)
        animSetXY.playTogether(x, y, sx, sy)
        animSetXY.duration = 650
        animSetXY.start()
    }

    override fun onDestroyView() {
        super.onDestroyView()
        if (!mDisposableAddCart.isDisposed) mDisposableAddCart.dispose()
    }

    companion object {
        fun newInstance(account: Account): MenuFragment {
            return MenuFragment().apply {
                this.avatarUrl = account.imageurl
                this.username = account.username!!
                this.fullName = account.fullName!!
            }
        }
    }
}