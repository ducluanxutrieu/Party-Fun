package com.uit.party.di

import android.content.Context
import com.uit.party.util.SharedPrefs
import com.uit.party.util.Storage
import dagger.Module
import dagger.Provides
import javax.inject.Qualifier


@Retention(AnnotationRetention.BINARY)
@Qualifier
annotation class RegistrationStorage

@Retention(AnnotationRetention.BINARY)
@Qualifier
annotation class LoginStorage

@Module
class StorageModule {
    @RegistrationStorage
    @Provides
    fun provideRegistrationStorage(context: Context): Storage {
        return SharedPrefs(context)
    }

    @LoginStorage
    @Provides
    fun provideLoginStorage(context: Context): Storage {
        return SharedPrefs(context)
    }
}