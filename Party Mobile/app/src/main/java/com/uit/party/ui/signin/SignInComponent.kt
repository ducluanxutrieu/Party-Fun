package com.uit.party.ui.signin

import com.uit.party.di.ActivityScope
import com.uit.party.ui.SplashActivity
import com.uit.party.ui.signin.login.LoginFragment
import com.uit.party.ui.signin.register.RegisterFragment
import com.uit.party.ui.signin.reset_password.ResetPasswordFragment
import dagger.Subcomponent

@ActivityScope
@Subcomponent
interface SignInComponent {

    @Subcomponent.Factory
    interface Factory{
        fun create(): SignInComponent
    }

    fun inject(activity: SplashActivity)
    fun inject(activity: SignInActivity)
    fun inject(fragment: LoginFragment)
    fun inject(fragment: RegisterFragment)
    fun inject(fragment: ResetPasswordFragment)
}