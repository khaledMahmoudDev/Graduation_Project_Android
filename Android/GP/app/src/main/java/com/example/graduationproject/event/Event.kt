package com.example.graduationproject.event

import android.os.Parcelable
import com.example.graduationproject.calender.DateOfTheDay
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import io.realm.annotations.RealmClass
import kotlinx.android.parcel.Parcelize
import java.io.Serializable
import java.util.*

@RealmClass
@Parcelize
open class Event(var mDate : String = ""
                 ,var title : String = ""
                 ,var details: String = ""
                 ,var startTime :String = ""
                 ,var endTime :String = ""):RealmObject(), Parcelable {

}