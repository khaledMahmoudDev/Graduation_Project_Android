package com.example.graduationproject.model

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize

@Parcelize
class ToDoModel (
    var id :String = "",
    var title :String = "",
    var datails :String = "",
    var startTime : String = "",
    var startDate : String = "",
    var endTime : String = "",
    var endDate : String = "",
    var priority : String = "",
    var status : String = ""
    ): Parcelable {
}