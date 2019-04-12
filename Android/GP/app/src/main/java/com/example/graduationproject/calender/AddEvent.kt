package com.example.graduationproject.calender

import android.app.Activity
import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.telecom.Call
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import com.example.graduationproject.R
import com.example.graduationproject.eventLocation.EventLocation
import com.example.graduationproject.model.Event
import com.example.graduationproject.model.EventFireBase
import com.google.android.gms.location.places.ui.PlacePicker
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import kotlinx.android.synthetic.main.activity_add_event.*
import java.util.*

class AddEvent : AppCompatActivity() {


    var list_of_items = arrayOf("Public", "Private")
    var startTime:String = "00:00"
    var endTime:String = "00:00"
    private var mAuth : FirebaseAuth? = null
    private var firebaseDataBase : FirebaseDatabase? = null
    private var dbReference : DatabaseReference? = null
    var privacy = true
    var mLocation : String = ""
    companion object {
        private const val PLACE_PICKER_REQUEST = 1
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_add_event)

        val aa = ArrayAdapter(this, android.R.layout.simple_spinner_item, list_of_items)
        // Set layout to use when the list of choices appear
        aa.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        // Set Adapter to Spinner
        spinnerPrivacy!!.adapter = aa

        spinnerPrivacy.onItemSelectedListener = object : AdapterView.OnItemSelectedListener{
            override fun onNothingSelected(p0: AdapterView<*>?) {
            }

            override fun onItemSelected(p0: AdapterView<*>?, p1: View?, p2: Int, p3: Long) {
                privacy = p0!!.getItemAtPosition(p2).toString() == "Public"
            }
        }

        addLocation.setOnClickListener {



            val builder =PlacePicker.IntentBuilder()
            startActivityForResult(builder.build(this), PLACE_PICKER_REQUEST)

           // startActivity(Intent(this,EventLocation::class.java))

        }


        mAuth = FirebaseAuth.getInstance()
        firebaseDataBase = FirebaseDatabase.getInstance()
        dbReference = firebaseDataBase!!.reference

        var i = intent
        var mDate = i.getStringExtra("dateOfTheDay")


        AddEventAdd.setOnClickListener {
            var title : String = AddEventTitle.text.toString()
            var details : String = AddEventDetails.text.toString()
            var i = Intent()
            i.putExtra("AddEventTitle", title)
            i.putExtra("AddEventDetails", details)
            i.putExtra("AddEventStartTime", startTime)
            i.putExtra("AddEventEndTime", endTime)


            var sendEvent = EventFireBase()
            sendEvent.mEventCreator = mAuth!!.currentUser!!.email.toString()
            sendEvent.mDetails = details
            sendEvent.mEndTime = endTime
            sendEvent.mStartTime = startTime
            sendEvent.mDate = mDate
            sendEvent.mTitle = title
            sendEvent.privacy = privacy
            sendEvent.location = mLocation

            var mId = dbReference!!.child("Events").push().key
            sendEvent.id = mId!!
            dbReference!!.child("Events").child(mId).setValue(sendEvent)


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

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == PLACE_PICKER_REQUEST && resultCode == Activity.RESULT_OK)
        {
            var place = PlacePicker.getPlace(this,data)
            addLocation.text = place.name.toString()
            mLocation = addLocation.text.toString()


        }
    }


}
