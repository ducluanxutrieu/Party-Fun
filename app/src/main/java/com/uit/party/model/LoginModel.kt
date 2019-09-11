package com.uit.party.model

import com.google.gson.annotations.SerializedName
import java.io.Serializable

class LoginModel: Serializable {
    var id: Int = 0
    var email:String? = null
    var fullname:String? = null
    var username : String? = null
    var avatar: String? = null
    var token:String? = null
}

//class Project {
//    var id:Int? = 0
//    var name:String? = null
//    var description:String? = null
//    var type:String? = null
//    var state:String? = null
//    var color:String? = null
//    var avatar:String? = null
//    var createdAt:String? = null
//    var updatedAt:String? = null
//    var userProject:UserProject? = null
//}

/**
val numberOfMember: Int? = null

 */

data class UserProject (
    @SerializedName("user_id") val user_id : Int,
    @SerializedName("project_id") val project_id : Int,
    @SerializedName("role") val role : String,
    @SerializedName("createdAt") val createdAt : String,
    @SerializedName("updatedAt") val updatedAt : String
)