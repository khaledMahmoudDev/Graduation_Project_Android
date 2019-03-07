package com.example.graduationproject.event

import com.example.graduationproject.calender.DateOfTheDay
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import io.realm.annotations.RealmClass
import java.util.*

@RealmClass
open class Event(var mDate : String = ""
                 ,var title : String = ""
                 ,var details: String = ""
                 ,var startTime :String = ""
                 ,var endTime :String = ""):RealmObject() {

}