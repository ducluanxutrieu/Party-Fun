package com.uit.party.user

import com.uit.party.data.CusResult
import com.uit.party.model.AccountResponse
import com.uit.party.model.BaseResponse
import com.uit.party.model.LoginModel
import com.uit.party.model.RegisterModel
import com.uit.party.ui.signin.SignInRepository
import com.uit.party.util.Constants.Companion.REGISTERED_USER
import com.uit.party.util.Storage
import javax.inject.Inject
import javax.inject.Singleton

//@Singleton
class UserManager @Inject constructor(
    private val storage: Storage,
    private val userComponentFactory: UserComponent.Factory,
    private val signInRepository: SignInRepository
) {

    var userComponent: UserComponent? = null
        private set

//    var userDataRepository: UserDataRepository? = null

    val username: String
        get() = storage.getData(REGISTERED_USER, String::class.java) ?:""

    //    fun isUserLoggedIn() = userDataRepository != null
    fun isUserLoggedIn() = userComponent != null

    fun isUserRegistered() = storage.getData(REGISTERED_USER, String::class.java)?.isNotEmpty()

    suspend fun registerUser(model: RegisterModel): CusResult<AccountResponse> {
        return signInRepository.register(model)
//        userJustLoggedIn()
    }

    suspend fun loginUser(model: LoginModel): CusResult<AccountResponse> {
        val result = signInRepository.login(model)

        if (result is CusResult.Success){
            signInRepository.saveToMemory(result.data)
        }

        userJustLoggedIn()

        return result
    }

    private fun userJustLoggedIn() {
//        userDataRepository = UserDataRepository(this)
        userComponent = userComponentFactory.create()
    }

    suspend fun resetPassword(username: String): CusResult<BaseResponse> {
        return signInRepository.resetPassword(username)
    }
}