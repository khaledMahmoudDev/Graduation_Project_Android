package com.example.graduationproject.model

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize

@Parcelize
data class User (var userId : String? = "",
                 var firstName :String? = "",
                 var lastName : String? = "",
                 var email:String? = "",
                 var imageLink: String? = ""): Parcelable {
}