package com.example.graduationproject.model

import android.content.Context
import android.widget.Toast
import io.realm.Realm
import io.realm.RealmConfiguration

class EventDb(val context: Context) {


    var realm: Realm? = null
    fun configuration()
    {
        val config = RealmConfiguration.Builder().name("event4.realm").build()
        realm = Realm.getInstance(config)


    }

    fun addEvent(event: Event)
    {

        realm!!.beginTransaction()
        var mEvent = realm!!.createObject(Event::class.java)
        mEvent.mDate = event.mDate
        mEvent.details = event.details
        mEvent.title = event.title
        mEvent.startTime =event.startTime
        mEvent.endTime = event.endTime
        mEvent.id = event.id
        mEvent.privacy = event.privacy
        mEvent.location = event.location

        Toast.makeText(context,"object add date is ${event.mDate} and title ${event.title}",Toast.LENGTH_LONG).show()
        realm!!.commitTransaction()

    }

    fun cleareDB()
    {
        realm!!.beginTransaction()
        realm!!.deleteAll()
        realm!!.commitTransaction()
    }
    fun returnEvents(dateQuery:String): ArrayList<Event>
    {

        Toast.makeText(context,"query is $dateQuery",Toast.LENGTH_SHORT).show()
        var events = ArrayList<Event>()


        val allData = realm!!.where(Event::class.java).equalTo("mDate",dateQuery).findAll()

      //  Toast.makeText(context,"result all data size is ${allData.size}",Toast.LENGTH_SHORT).show()

        allData.forEach{
            var mEv: Event = it


        //    Toast.makeText(context,"mdate is ${mEv.mDate}",Toast.LENGTH_SHORT).show()
            events.add(mEv)



        }

//        Toast.makeText(context,"result size is ${events.size}",Toast.LENGTH_SHORT).show()
        return events

    }

    fun closeRealm()
    {
        realm!!.close()
    }
}