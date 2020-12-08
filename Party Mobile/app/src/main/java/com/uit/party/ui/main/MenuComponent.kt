package com.uit.party.ui.main

import com.uit.party.di.ActivityScope
import com.uit.party.ui.main.main_menu.MenuFragment
import dagger.Subcomponent

@ActivityScope
@Subcomponent
interface MenuComponent {
    @Subcomponent.Factory
    interface Factory {
        fun create(): MenuComponent
    }

    fun inject(activity: MainActivity)
    fun inject(fragment: MenuFragment)
}