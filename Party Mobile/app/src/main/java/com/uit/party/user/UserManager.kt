package com.uit.party.user

import com.uit.party.data.CusResult
import com.uit.party.model.*
import com.uit.party.ui.signin.SignInRepository
import com.uit.party.util.Constants
import com.uit.party.util.Constants.Companion.REGISTERED_USER
import com.uit.party.util.Storage
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class UserManager @Inject constructor(
    private val storage: Storage,
    private val userComponentFactory: UserComponent.Factory,
    private val signInRepository: SignInRepository,
    private val userDataRepository: UserDataRepository
) {

    var userComponent: UserComponent? = null
        private set

//    var userDataRepository: UserDataRepository? = null

    val username: String
        get() = storage.getData(REGISTERED_USER, String::class.java) ?: ""

    private val role: Int?
        get() = storage.getData(Constants.USER_INFO_KEY, Account::class.java)?.role

    val isAdmin: Boolean
        get() = role == null && (role == UserRole.Admin.ordinal || role == UserRole.Staff.ordinal)

    var userAccount: Account? = storage.getData(Constants.USER_INFO_KEY, Account::class.java)

    //    fun isUserLoggedIn() = userDataRepository != null
    fun isUserLoggedIn() = userComponent != null

    fun isUserRegistered() = storage.getData(REGISTERED_USER, String::class.java)?.isNotEmpty()

    suspend fun registerUser(model: RegisterModel): CusResult<AccountResponse> {
        return signInRepository.register(model)
//        userJustLoggedIn()
    }

    suspend fun loginUser(model: LoginModel): CusResult<AccountResponse> {
        val result = signInRepository.login(model)

        if (result is CusResult.Success) {
            signInRepository.saveToMemory(result.data.account, result.data.account?.token)
        }

        userJustLoggedIn()

        return result
    }

    fun updateUserInfoToShared(userAccount: Account?){
        signInRepository.saveToMemory(userAccount)
    }

    private fun userJustLoggedIn() {
//        userDataRepository = UserDataRepository(this)
        userComponent = userComponentFactory.create()
    }

    suspend fun resetPassword(username: String): CusResult<BaseResponse> {
        return signInRepository.resetPassword(username)
    }

    suspend fun logout(): CusResult<BaseResponse> {
        val result = userDataRepository.logout()

        if (result is CusResult.Success) {
            userDataRepository.clearData()
        }

        return result
    }
}