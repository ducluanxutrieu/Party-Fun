/*
 * Copyright (C) 2019 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.uit.party.util

import com.uit.party.data.getToken
import com.uit.party.user.LoggedUserScope
import com.uit.party.user.UserManager
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
