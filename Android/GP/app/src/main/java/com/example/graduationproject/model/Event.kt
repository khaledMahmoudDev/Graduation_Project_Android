package com.example.graduationproject.model

import android.os.Parcelable
import io.realm.RealmObject
import io.realm.annotations.RealmClass
import kotlinx.android.parcel.Parcelize

@RealmClass
@Parcelize
open class Event(
    var id : String = "",
    var mDate : String = ""
    ,var title : String = ""
    ,var details: String = ""
    ,var startTime :String = ""
    ,var endTime :String = "",
    var eventCreator : String = "",
    var privacy : Boolean = true,
    var location: String = ""
):RealmObject(), Parcelable {

}