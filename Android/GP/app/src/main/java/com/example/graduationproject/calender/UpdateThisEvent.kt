package com.example.graduationproject.calender

import android.app.TimePickerDialog
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.text.format.DateFormat
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.Toast
import com.example.graduationproject.R
import com.example.graduationproject.model.Event
import com.example.graduationproject.model.EventFireBase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import io.realm.Realm
import io.realm.RealmConfiguration
import kotlinx.android.synthetic.main.activity_add_event.*
import kotlinx.android.synthetic.main.activity_update_this_event.*
import java.util.*

class UpdateThisEvent : AppCompatActivity() {

    var list_of_items = arrayOf("Public", "Private")
    lateinit var event:Event
    var startTime:String = "00:00"
    var endTime:String = "00:00"

    private var mAuth : FirebaseAuth? = null
    private var firebaseDataBase : FirebaseDatabase? = null
    private var dbReference : DatabaseReference? = null


    var privacy = true
    var mLocation : String = ""
    var mId : String  = ""
    var mDate :String = ""



    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_update_this_event)

        mAuth = FirebaseAuth.getInstance()
        firebaseDataBase = FirebaseDatabase.getInstance()
        dbReference = firebaseDataBase!!.getReference("Events")


        val aa = ArrayAdapter(this, android.R.layout.simple_spinner_item, list_of_items)
        // Set layout to use when the list of choices appear
        aa.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        // Set Adapter to Spinner
        updatespinnerPrivacy.adapter = aa
        updatespinnerPrivacy.onItemSelectedListener = object : AdapterView.OnItemSelectedListener{
            override fun onNothingSelected(p0: AdapterView<*>?) {

            }

            override fun onItemSelected(p0: AdapterView<*>?, p1: View?, p2: Int, p3: Long) {

                privacy = p0!!.getItemAtPosition(p2).toString() == "Public"
            }
        }




        event= intent.getParcelableExtra("clickedEventTobeUpdated")
        updateEventStartTime.text = event.startTime
        updateEventEndTime.text = event.endTime
        updateEventTitle.append(event.title)
        updateEventDetails.append(event.details)
        mId = event.id
        mDate = event.mDate
        if(mAuth!!.currentUser!!.email != event.eventCreator)
        {
            Toast.makeText(applicationContext,"u Can not update this event ", Toast.LENGTH_SHORT).show()
            finish()
        }



        updateEventUpdateButton.setOnClickListener {
            updateFireBase()
            Realm.init(this)
            val config = RealmConfiguration.Builder().name("event4.realm").build()
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
    fun updateFireBase()
    {
        val ev : EventFireBase = EventFireBase()
        ev.id = mId
        ev.location = mLocation
        ev.privacy = privacy
        ev.mTitle = updateEventTitle.text.toString()
        ev.mDetails = updateEventDetails.text.toString()
        ev.mStartTime = updateEventStartTime.text.toString()
        ev.mEndTime = updateEventEndTime.text.toString()
        ev.mEventCreator = mAuth!!.currentUser!!.email.toString()
        ev.mDate = mDate

        var childRef = dbReference!!.child(mId)

        childRef.setValue(ev)
    }



}
