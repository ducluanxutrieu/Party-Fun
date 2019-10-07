package com.uit.party.ui.profile

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.FrameLayout
import com.uit.party.R
import com.uit.party.util.AddNewFragment

class ProfileActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_profile)

        val fragment = ProfileFragment.newInstance()
        AddNewFragment().addFragment(R.id.profile_container, fragment, true, this)
    }
}
