package com.example.graduationproject.calender

import android.app.Activity
import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.content.Intent
import android.icu.text.TimeZoneFormat
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.provider.AlarmClock
import android.widget.Toast
import com.example.graduationproject.R
import com.example.graduationproject.model.EventFireBase
import com.google.android.gms.location.places.ui.PlacePicker
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import kotlinx.android.synthetic.main.activity_add_event.*
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList


class AddEvent : AppCompatActivity() {
    var startTime:String = "00:00"
    var endTime:String = "00:00"
    var startDate : String = ""
    var endDate : String = ""

    private var mAuth : FirebaseAuth? = null
    private var firebaseDataBase : FirebaseDatabase? = null
    private var dbReference : DatabaseReference? = null
    private var privacy = ""
    private var customUsr : ArrayList<String>? = null
    private var mLocation : String = ""
    companion object {
        private const val PLACE_PICKER_REQUEST = 1
        private const val REQUEST_CODE_FOR_CUSTOM_USERS = 4
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_add_event)
        val actionBar = supportActionBar
        actionBar!!.title = "Add Event"
        actionBar.elevation = 4.0F


        setAlarmButton.setOnClickListener {
            val formater = SimpleDateFormat("HH:mm")
            val parsTime = formater.parse(startTime)

            val hoursformater = SimpleDateFormat("HH")
            val hours = hoursformater.format(parsTime)

            val minutesformater = SimpleDateFormat("mm")
            val minutes = minutesformater.format(parsTime)

            val intent = Intent(AlarmClock.ACTION_SET_ALARM)
            intent.putExtra(AlarmClock.EXTRA_MESSAGE,AddEventTitle.text.toString())
            intent.putExtra(AlarmClock.EXTRA_HOUR,hours.toInt())
            intent.putExtra(AlarmClock.EXTRA_MINUTES,minutes.toInt())
            startActivity(intent)
        }


        privacy = "public"
        publicButton.background = resources.getDrawable(R.drawable.public_clicked)
        customUsr = ArrayList()
        publicButton.setOnClickListener {
            privacy = "public"
            publicButton.background = resources.getDrawable(R.drawable.public_clicked)
            privateButton.background = resources.getDrawable(R.drawable.private_unclicked)
            groupButton.background = resources.getDrawable(R.drawable.custom_unclicked)

        }
        privateButton.setOnClickListener {
            privacy = "private"
            publicButton.background = resources.getDrawable(R.drawable.public_unclick)
            privateButton.background = resources.getDrawable(R.drawable.private_clicked)
            groupButton.background = resources.getDrawable(R.drawable.custom_unclicked)
        }
        groupButton.setOnClickListener {

            publicButton.background = resources.getDrawable(R.drawable.public_unclick)
            privateButton.background = resources.getDrawable(R.drawable.private_unclicked)
            groupButton.background = resources.getDrawable(R.drawable.custom_clicked)
            privacy = "CustomUsers"
            var i = Intent(this,CustomUsers::class.java)
            startActivityForResult(i,REQUEST_CODE_FOR_CUSTOM_USERS)
        }


        addLocation.setOnClickListener {
            val builder =PlacePicker.IntentBuilder()
            startActivityForResult(builder.build(this), PLACE_PICKER_REQUEST)
        }


        mAuth = FirebaseAuth.getInstance()
        firebaseDataBase = FirebaseDatabase.getInstance()
        dbReference = firebaseDataBase!!.reference
        dbReference!!.keepSynced(true)

        var i = intent
        var mDate = i.getStringExtra("dateOfTheDay")
        val sdf = SimpleDateFormat("MM dd yyyy", Locale.ENGLISH)
        val parsedDate = sdf.parse(mDate)
        val date1 = SimpleDateFormat("MMM dd, yyyy")
        var lDAte = date1.format(parsedDate)
        addEventStartDate.text = lDAte
        startDate = lDAte



        AddEventAdd.setOnClickListener {
            var title : String = AddEventTitle.text.toString()
            var details : String = AddEventDetails.text.toString()


            var sendEvent = EventFireBase()
            sendEvent.mEventCreator = mAuth!!.currentUser!!.email.toString()
            sendEvent.mDetails = details
            sendEvent.mEndTime = endTime
            sendEvent.mStartTime = startTime
            sendEvent.mDate = lDAte
            sendEvent.mTitle = title
            sendEvent.privacy = privacy
            sendEvent.location = mLocation
            sendEvent.startDate = startDate
            sendEvent.endDate = endDate
            for(n in customUsr!!)
            {
                sendEvent.customUsrs!!.add(n)
            }

            var mId = dbReference!!.child("Events").push().key
            sendEvent.id = mId!!
            dbReference!!.child("Events").child(mId).setValue(sendEvent)
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
        addEventStartDate.setOnClickListener {
            val now = Calendar.getInstance()
            val datePickerDialog = DatePickerDialog(this,
                DatePickerDialog.OnDateSetListener{ datePicker, year, month, day ->


                    val sdf = SimpleDateFormat("MM dd yyyy", Locale.ENGLISH)
                    val parsedDate = sdf.parse("$month $day $year")
                    val date1 = SimpleDateFormat("MMM dd, yyyy")
                    var lDAte = date1.format(parsedDate)
                    startDate = lDAte

                    addEventStartDate.text = lDAte



            },now.get(Calendar.YEAR),now.get(Calendar.MONTH),now.get(Calendar.DAY_OF_MONTH))
            datePickerDialog.show()

        }
        addEventEndDate.setOnClickListener {
            val now = Calendar.getInstance()
            val datePickerDialog = DatePickerDialog(this,
                DatePickerDialog.OnDateSetListener{ datePicker, year, month, day ->

                    val sdf = SimpleDateFormat("MM dd yyyy", Locale.ENGLISH)
                    val parsedDate = sdf.parse("$month $day $year")
                    val date1 = SimpleDateFormat("MMM dd, yyyy")
                    var lDAte = date1.format(parsedDate)
                    endDate = lDAte

                    addEventEndDate.text = lDAte
                },now.get(Calendar.YEAR),now.get(Calendar.MONTH),now.get(Calendar.DAY_OF_MONTH))
            datePickerDialog.show()

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
        }else if (requestCode == REQUEST_CODE_FOR_CUSTOM_USERS && resultCode == Activity.RESULT_OK )
        {
            if (data != null)
            {
                customUsr = data.extras!!.getStringArrayList("listString")
                Toast.makeText(applicationContext,"size is of returned${customUsr!!.size}",Toast.LENGTH_LONG ).show()
            }
        }
    }
}
