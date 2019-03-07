package com.example.graduationproject.calender

import android.app.Activity
import android.app.TimePickerDialog
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.telecom.Call
import com.example.graduationproject.R
import kotlinx.android.synthetic.main.activity_add_event.*
import java.util.*

class AddEvent : AppCompatActivity() {
     var startTime:String = "00:00"
     var endTime:String = "00:00"


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_add_event)

        AddEventAdd.setOnClickListener {
            var title : String = AddEventTitle.text.toString()
            var details : String = AddEventDetails.text.toString()
            var i = Intent()
            i.putExtra("AddEventTitle", title)
            i.putExtra("AddEventDetails", details)
            i.putExtra("AddEventStartTime", startTime)
            i.putExtra("AddEventEndTime", endTime)
            setResult(Activity.RESULT_OK,i)
            finish()
        }
        addEventStartTime.setOnClickListener {

            val now = Calendar.getInstance()

            val timePickerDialog = TimePickerDialog(this,
                TimePickerDialog.OnTimeSetListener { view, hourOfDay, minute ->

                    addEventStartTime.text = "$hourOfDay:$minute"
                    startTime = "$hourOfDay:$minute"
                },
                now.get(Calendar.HOUR_OF_DAY),
                now.get(Calendar.SECOND),
                android.text.format.DateFormat.is24HourFormat(applicationContext))

            timePickerDialog.show()
        }
        addEventEndTime.setOnClickListener {

            val now = Calendar.getInstance()

            val timePickerDialog = TimePickerDialog(this,
                TimePickerDialog.OnTimeSetListener { view, hourOfDay, minute ->

                    addEventEndTime.text = "$hourOfDay:$minute"
                    endTime = "$hourOfDay:$minute"

                },
                now.get(Calendar.HOUR_OF_DAY),
                now.get(Calendar.SECOND),
                android.text.format.DateFormat.is24HourFormat(applicationContext))

            timePickerDialog.show()
        }


    }

}
