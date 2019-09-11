package com.uit.party.view_model.register

import android.text.Editable
import android.text.TextWatcher
import android.util.Log
import android.view.View
import android.widget.Toast
import androidx.databinding.ObservableBoolean
import androidx.databinding.ObservableField
import androidx.databinding.ObservableInt
import androidx.lifecycle.ViewModel
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.uit.party.model.ResponseMessage
import com.uit.party.ui.RegisterActivity
import com.uit.party.util.GlobalApplication


class RegisterViewModel(private val registerCallback: RegisterCallback) : ViewModel(){
    val showCardView: ObservableInt = ObservableInt()
    var fullNameValid = false
    var usernameValid = false
    var emailValid = false
    var passwordValid = false
    var confirmPasswordValid = false
    var mAuth: FirebaseAuth = FirebaseAuth.getInstance()
    var mUser : FirebaseUser? = null
    private val TAG = "RegisterTag"

    var btnRegisterEnabled: ObservableBoolean = ObservableBoolean()

    var fullName: ObservableField<String> = ObservableField()
    var username: ObservableField<String> = ObservableField()
    var email: ObservableField<String> = ObservableField()
    var password: ObservableField<String> = ObservableField()
    var confirmPassword: ObservableField<String> = ObservableField()

    private val content = GlobalApplication.appContext

    var fullNameText: String = ""
    var usernameText: String = ""
    var emailText: String = ""
    var passwordText: String =""
    private lateinit var activity: RegisterActivity

    fun init(activity: RegisterActivity){
        this.activity = activity
    }

    fun checkShowButtonRegister(){
        if (fullNameValid && usernameValid && emailValid && passwordValid && confirmPasswordValid) {
            btnRegisterEnabled.set(true)
        }
        else btnRegisterEnabled.set(false)
    }

    fun getFullNameTextChanged(): TextWatcher{
        return object : TextWatcher{
            override fun afterTextChanged(p0: Editable?) {
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                if (p0 != null) {
                    if (p0.isNotEmpty()){
                        fullNameValid = true
                        fullNameText = p0.toString()
                        checkShowButtonRegister()
                    }else{
                        fullNameValid = false
                        btnRegisterEnabled.set(false)
                    }
                }else{
                    fullNameValid = false
                    btnRegisterEnabled.set(false)
                }
            }
        }
    }

    fun getUsernameTextChanged(): TextWatcher{
        return object : TextWatcher{
            override fun afterTextChanged(p0: Editable?) {

            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                if (p0 != null) {
                    if (p0.isNotEmpty()){
                        usernameValid = true
                        usernameText = p0.toString()
                        checkShowButtonRegister()
                    }else{
                        usernameValid = false
                        btnRegisterEnabled.set(false)
                    }
                }else{
                    usernameValid = false
                    btnRegisterEnabled.set(false)
                }
            }

        }
    }

    fun getEmailTextChanged(): TextWatcher{
        return object : TextWatcher{
            override fun afterTextChanged(p0: Editable?) {

            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                if (p0 != null) {
                    if (p0.toString().contains("@") && p0.toString().contains(".") && p0.toString().trim().length > 5){
                        emailValid = true
                        emailText = p0.toString()
                        checkShowButtonRegister()
                    }else{
                        emailValid = false
                        btnRegisterEnabled.set(false)
                    }
                }else{
                    emailValid = false
                    btnRegisterEnabled.set(false)
                }
            }

        }
    }

    fun getPasswordTextChanged(): TextWatcher{
        return object : TextWatcher{
            override fun afterTextChanged(p0: Editable?) {

            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                if (p0 != null) {
                    if (p0.toString().trim().length > 5){
                        passwordText = p0.toString()
                        passwordValid = true
                        checkShowButtonRegister()
                    }else{
                        passwordValid = false
                        btnRegisterEnabled.set(false)
                    }
                }else{
                    passwordValid = false
                    btnRegisterEnabled.set(false)
                }
            }

        }
    }

    fun getConfirmPasswordTextChanged(): TextWatcher{
        return object : TextWatcher{
            override fun afterTextChanged(p0: Editable?) {
            }

            override fun beforeTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
            }

            override fun onTextChanged(p0: CharSequence?, p1: Int, p2: Int, p3: Int) {
                if (p0 != null) {
                    if (p0.toString().equals(passwordText)){
                        confirmPasswordValid = true
                        checkShowButtonRegister()
                    }else{
                        confirmPasswordValid = false
                        btnRegisterEnabled.set(false)
                    }
                }else{
                    confirmPasswordValid = false
                    btnRegisterEnabled.set(false)
                }
            }
        }
    }

    fun onRegisterClicked(){
        register(fullNameText, usernameText, emailText, passwordText, activity) {registerResponse ->
           when (registerResponse?.message){
               "Create successed" -> {
                   Toast.makeText(content, "Register successful", Toast.LENGTH_LONG).show()
                   registerCallback.onBackLogin()
               }
               "Create failed" -> registerCallback.onFail("Register Failed - Please try again")
               "Username existed" -> registerCallback.onFail("Username existed - Please try another")
           }
        }
    }

    private fun register(fullName: String, username: String, email: String, password: String, activity: RegisterActivity, onComplete: (ResponseMessage?) -> Unit){
        mAuth.createUserWithEmailAndPassword(email, password)
            .addOnCompleteListener(activity
            ) { task ->
                if (task.isSuccessful) {
                    // Sign in success, update UI with the signed-in user's information
                    Log.d(TAG, "createUserWithEmail:success")
                    val user = mAuth.currentUser
                    updateUI(user)
                } else {
                    // If sign in fails, display a message to the user.
                    Log.w(TAG, "createUserWithEmail:failure", task.exception)
                    Toast.makeText(
                        content, "Authentication failed.",
                        Toast.LENGTH_SHORT
                    ).show()
                    updateUI(null)
                }

                // ...
            }

//        serviceRetrofit.register(fullName, username, email, password)
//                .enqueue(object : Callback<ResponseMessage> {
//                    override fun onFailure(call: Call<ResponseMessage>, t: Throwable) {
//
//                    }
//
//                    override fun onResponse(call: Call<ResponseMessage>, responseMessage: Response<ResponseMessage>) {
//                        val repo = responseMessage.body()
//                        onComplete(repo)
//                        Log.i(LoginActivity.TAG, repo.toString())
//                    }
//                })
    }

    private fun updateUI(user : FirebaseUser?){
        //TODO update user UI
    }

    fun onBackLogin(){
        registerCallback.onBackLogin()
    }

    fun setCardViewShow() {
        showCardView.set(View.GONE)
    }


}