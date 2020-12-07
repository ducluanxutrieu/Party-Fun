package com.uit.party.di


import com.uit.party.ui.signin.SignInComponent
import com.uit.party.user.UserComponent
import dagger.Module

@Module(subcomponents = [SignInComponent::class, UserComponent::class])
class AppSubcomponents {
}