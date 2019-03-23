package com.example.graduationproject.calender

import android.app.TimePickerDialog
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.text.format.DateFormat
import com.example.graduationproject.R
import com.example.graduationproject.model.Event
import io.realm.Realm
import io.realm.RealmConfiguration
import kotlinx.android.synthetic.main.activity_update_this_event.*
import java.util.*

class UpdateThisEvent : AppCompatActivity() {

    lateinit var event:Event
    var startTime:String = "00:00"
    var endTime:String = "00:00"



    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_update_this_event)




        event= intent.getParcelableExtra("clickedEventTobeUpdated")
        updateEventStartTime.text = event.startTime
        updateEventEndTime.text = event.endTime
        updateEventTitle.append(event.title)
        updateEventDetails.append(event.details)


        updateEventUpdateButton.setOnClickListener {
            Realm.init(this)
            val config = RealmConfiguration.Builder().name("event.realm").build()
            var realm = Realm.getInstance(config)
            realm!!.beginTransaction()
            val ourObj = realm!!.where(Event::class.java).equalTo("title",event.title).findFirst()
      //      realm.beginTransaction()
            ourObj!!.title = updateEventTitle.text.toString()
            ourObj.details = updateEventDetails.text.toString()
            ourObj.startTime = updateEventStartTime.text.toString()
            ourObj.endTime = updateEventEndTime.text.toString()

            realm.commitTransaction()

            startActivity(Intent(this,Calender::class.java))
            finish()












        }


        updateEventStartTime.setOnClickListener {

            val now = Calendar.getInstance()


            val timePickerDialog = TimePickerDialog(this,
                TimePickerDialog.OnTimeSetListener { view, hourOfDay, minute ->

                    updateEventStartTime.text = "$hourOfDay:$minute"
                    startTime = "$hourOfDay:$minute"
                },
                now.get(Calendar.HOUR_OF_DAY),
                now.get(Calendar.SECOND),
                DateFormat.is24HourFormat(applicationContext))

            timePickerDialog.show()
        }



        updateEventEndTime.setOnClickListener {

            val now = Calendar.getInstance()

            val timePickerDialog = TimePickerDialog(this,
                TimePickerDialog.OnTimeSetListener { view, hourOfDay, minute ->

                    updateEventEndTime.text = "$hourOfDay:$minute"
                    endTime = "$hourOfDay:$minute"

                },
                now.get(Calendar.HOUR_OF_DAY),
                now.get(Calendar.SECOND),
                DateFormat.is24HourFormat(applicationContext))

            timePickerDialog.show()
        }



    }
}
