package com.uit.party.util

import com.uit.party.R


fun CharSequence?.usernameErrorMes(): String {
    return when {
        this.isNullOrEmpty() -> UiUtil.getString(R.string.this_field_required)
        this.contains(" ") -> UiUtil.getString(R.string.this_field_cannot_contain_space)
        else -> ""
    }
}