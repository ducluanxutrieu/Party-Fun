package com.uit.party.ui.profile

import com.uit.party.di.ActivityScope
import com.uit.party.ui.main.MainActivity
import com.uit.party.ui.profile.profile_fragment.ProfileFragment
import dagger.Subcomponent

@ActivityScope
@Subcomponent
interface ProfileComponent {

    @Subcomponent.Factory
    interface Factory{
        fun create(): ProfileComponent
    }

    fun inject(activity: MainActivity)
    fun inject(fragment: ProfileFragment)
}