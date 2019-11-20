package com.uit.party.util

import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentTransaction
import com.uit.party.R

class AddNewFragment {
    private var mCurrentFragment: Fragment? = null
    fun addFragment(
        containerId: Int, fragment: Fragment?, shouldAddStack: Boolean,
        context: AppCompatActivity
    ) {
        val fragmentManager = context.supportFragmentManager
        val ft = fragmentManager.beginTransaction()

        if (fragment != null) {
//            val defaultContainerId = R.id.fl_fragment_container
            ft.replace(containerId, fragment, fragment.javaClass.simpleName)
//            if (shouldAddStack) {
//                ft.addToBackStack(fragment.javaClass.simpleName)
//            }
            mCurrentFragment = fragment
        }
        ft.commitAllowingStateLoss()
    }

    fun addNewSlideUp(
        containerId: Int, fragment: Fragment?, shouldAddStack: Boolean,
        context: AppCompatActivity,
        enter: Int = R.anim.slide_in_up, exit: Int = R.anim.slide_out_down,
        popEnter: Int = R.anim.slide_in_up, popExit: Int = R.anim.slide_out_down
    ) {
        val fragmentManager = context.supportFragmentManager
        val ft = fragmentManager.beginTransaction()
        if (enter > 0 || exit > 0 || popEnter > 0 || popExit > 0) {
            ft.setCustomAnimations(enter, exit, popEnter, popExit)
        }
        if (fragment != null) {
//            val defaultContainerId = R.id.fl_fragment_container
            ft.replace(containerId, fragment, fragment.javaClass.simpleName)
            ft.setTransition(FragmentTransaction.TRANSIT_FRAGMENT_OPEN)
            if (shouldAddStack) {
                ft.addToBackStack(fragment.javaClass.simpleName)
            }
            mCurrentFragment = fragment
        }
        ft.commitAllowingStateLoss()
    }
}