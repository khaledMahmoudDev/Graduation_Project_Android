package com.example.graduationproject.calender

import android.app.Activity
import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.provider.AlarmClock
import android.text.format.DateFormat
import android.widget.Toast
import com.example.graduationproject.R
import com.example.graduationproject.model.Event
import com.example.graduationproject.model.EventFireBase
import com.google.android.gms.location.places.ui.PlacePicker
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import kotlinx.android.synthetic.main.activity_update_event.*
import java.text.SimpleDateFormat
import java.util.*

class UpdateThisEvent : AppCompatActivity() {

    lateinit var event:Event


    private var mAuth : FirebaseAuth? = null
    private var firebaseDataBase : FirebaseDatabase? = null
    private var dbReference : DatabaseReference? = null
    var privacy = ""
    var mLocation : String = ""
    var mId : String  = ""
    var mDate :String = ""
    var startDate : String = ""
    var endDate : String = ""
    var startTime:String = "00:00"
    var endTime:String = "00:00"
    private var customUsr : ArrayList<String>? = null
    companion object {
        private const val UPDATE_PLACE_PICKER_REQUEST = 11
        private const val UPDATE_REQUEST_CODE_FOR_CUSTOM_USERS = 44
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_update_event)
        val actionBar = supportActionBar
        actionBar!!.title = "Update Event"
        actionBar.elevation = 4.0F

        mAuth = FirebaseAuth.getInstance()
        firebaseDataBase = FirebaseDatabase.getInstance()
        dbReference = firebaseDataBase!!.getReference("Events")

        event= intent.getParcelableExtra("clickedEventTobeUpdated")

        UaddEventStartTime.text = event.startTime
        UaddEventEndTime.text = event.endTime
        UAddEventTitle.append(event.title)
        UAddEventDetails.append(event.details)
        UaddEventStartDate.text = event.startDate
        UaddEventEndDate.text=event.endDate
        UaddLocation.text = event.location

        mId = event.id
        mDate = event.mDate

        privacy = event.privacy


        UpublicButton.background = resources.getDrawable(R.drawable.public_clicked)
        customUsr = ArrayList()
        UpublicButton.setOnClickListener {
            privacy = "public"
            UpublicButton.background = resources.getDrawable(R.drawable.public_clicked)
            UprivateButton.background = resources.getDrawable(R.drawable.private_unclicked)
            UgroupButton.background = resources.getDrawable(R.drawable.custom_unclicked)

        }
        UprivateButton.setOnClickListener {
            privacy = "private"
            UpublicButton.background = resources.getDrawable(R.drawable.public_unclick)
            UprivateButton.background = resources.getDrawable(R.drawable.private_clicked)
            UgroupButton.background = resources.getDrawable(R.drawable.custom_unclicked)
        }
        UgroupButton.setOnClickListener {

            UpublicButton.background = resources.getDrawable(R.drawable.public_unclick)
            UprivateButton.background = resources.getDrawable(R.drawable.private_unclicked)
            UgroupButton.background = resources.getDrawable(R.drawable.custom_clicked)

            privacy = "CustomUsers"
            var i = Intent(this,CustomUsers::class.java)
            startActivityForResult(i,UPDATE_REQUEST_CODE_FOR_CUSTOM_USERS)
        }


        UaddLocation.setOnClickListener {
            val builder = PlacePicker.IntentBuilder()
            startActivityForResult(builder.build(this),UPDATE_PLACE_PICKER_REQUEST)
        }


        UAddEventAdd.setOnClickListener {
            updateFireBase()
            finish()
        }
        UaddEventStartTime.setOnClickListener {
            val now = Calendar.getInstance()
            val timePickerDialog = TimePickerDialog(this,
                TimePickerDialog.OnTimeSetListener { view, hourOfDay, minute ->

                    UaddEventStartTime.text = "$hourOfDay:$minute"
                    startTime = "$hourOfDay:$minute"
                },
                now.get(Calendar.HOUR_OF_DAY),
                now.get(Calendar.SECOND),
                DateFormat.is24HourFormat(applicationContext))

            timePickerDialog.show()
        }
        UaddEventEndTime.setOnClickListener {

            val now = Calendar.getInstance()

            val timePickerDialog = TimePickerDialog(this,
                TimePickerDialog.OnTimeSetListener { view, hourOfDay, minute ->

                    UaddEventEndTime.text = "$hourOfDay:$minute"
                    endTime = "$hourOfDay:$minute"
                },
                now.get(Calendar.HOUR_OF_DAY),
                now.get(Calendar.SECOND),
                DateFormat.is24HourFormat(applicationContext))

            timePickerDialog.show()
        }
        UsetAlarmButton.setOnClickListener {
            val formater = SimpleDateFormat("HH:mm")
            val parsTime = formater.parse(startTime)

            val hoursformater = SimpleDateFormat("HH")
            val hours = hoursformater.format(parsTime)

            val minutesformater = SimpleDateFormat("mm")
            val minutes = minutesformater.format(parsTime)

            val intent = Intent(AlarmClock.ACTION_SET_ALARM)
            intent.putExtra(AlarmClock.EXTRA_MESSAGE,UAddEventTitle.text.toString())
            intent.putExtra(AlarmClock.EXTRA_HOUR,hours.toInt())
            intent.putExtra(AlarmClock.EXTRA_MINUTES,minutes.toInt())
            startActivity(intent)
        }
        UaddEventStartDate.setOnClickListener {
            val now = Calendar.getInstance()
            val datePickerDialog = DatePickerDialog(this,
                DatePickerDialog.OnDateSetListener{ datePicker, year, month, day ->


                    val sdf = SimpleDateFormat("MM dd yyyy", Locale.ENGLISH)
                    val parsedDate = sdf.parse("$month $day $year")
                    val date1 = SimpleDateFormat("MMM dd, yyyy")
                    var lDAte = date1.format(parsedDate)
                    startDate = lDAte

                    UaddEventStartDate.text = lDAte



                },now.get(Calendar.YEAR),now.get(Calendar.MONTH),now.get(Calendar.DAY_OF_MONTH))
            datePickerDialog.show()

        }
        UaddEventEndDate.setOnClickListener {
            val now = Calendar.getInstance()
            val datePickerDialog = DatePickerDialog(this,
                DatePickerDialog.OnDateSetListener{ datePicker, year, month, day ->

                    val sdf = SimpleDateFormat("MM dd yyyy", Locale.ENGLISH)
                    val parsedDate = sdf.parse("$month $day $year")
                    val date1 = SimpleDateFormat("MMM dd, yyyy")
                    var lDAte = date1.format(parsedDate)
                    endDate = lDAte

                    UaddEventEndDate.text = lDAte
                },now.get(Calendar.YEAR),now.get(Calendar.MONTH),now.get(Calendar.DAY_OF_MONTH))
            datePickerDialog.show()

        }
    }
    fun updateFireBase()
    {
        val ev : EventFireBase = EventFireBase()
        ev.id = mId
        ev.location = mLocation
        ev.privacy = privacy
        ev.mTitle = UAddEventTitle.text.toString()
        ev.mDetails = UAddEventDetails.text.toString()
        ev.mStartTime = UaddEventStartTime.text.toString()
        ev.mEndTime = UaddEventEndTime.text.toString()
        ev.mEventCreator = mAuth!!.currentUser!!.email.toString()
        ev.mDate = mDate
        ev.startDate = startDate
        ev.endDate = endDate
        ev.customUsrs = customUsr
        var childRef = dbReference!!.child(mId)
        childRef.setValue(ev)
    }
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == UPDATE_PLACE_PICKER_REQUEST && resultCode == Activity.RESULT_OK)
        {
            var place = PlacePicker.getPlace(this,data)
            UaddLocation.text = place.name.toString()
            mLocation = UaddLocation.text.toString()
        }else if (requestCode ==UPDATE_REQUEST_CODE_FOR_CUSTOM_USERS && resultCode == Activity.RESULT_OK )
        {
            if (data != null)
            {
                customUsr = data.extras!!.getStringArrayList("listString")
                Toast.makeText(applicationContext,"size is of returned${customUsr!!.size}",Toast.LENGTH_LONG ).show()
            }
        }
    }


}
