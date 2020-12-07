package com.uit.party.user

import com.uit.party.data.getToken
import com.uit.party.util.ServiceRetrofit
import javax.inject.Inject
import kotlin.random.Random

/**
 * UserDataRepository contains user-specific data such as username and unread notifications.
 */

@LoggedUserScope
class UserDataRepository @Inject constructor (private val userManager: UserManager, private val networkService: ServiceRetrofit) {

    val username: String
        get() = userManager.username

    var unreadNotifications: Int

    init {
        unreadNotifications = randomInt()
    }

    suspend fun logout() {
        val result = networkService.logout(getToken())
    }
}

fun randomInt(): Int {
    return Random.nextInt(until = 100)
}
