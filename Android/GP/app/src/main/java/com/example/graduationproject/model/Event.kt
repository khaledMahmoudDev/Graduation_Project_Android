package com.example.graduationproject.model

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize

@Parcelize
open class Event(
    var id : String = "",
    var mDate : String = ""
    ,var title : String = ""
    ,var details: String = ""
    ,var startTime :String = ""
    ,var endTime :String = "",
    var eventCreator : String = "",
    var privacy : String = "",
    var location: String = "",
    var startDate : String = "",
    var endDate : String = "",
    var customUsrs : ArrayList<String> = ArrayList()
): Parcelable {

}