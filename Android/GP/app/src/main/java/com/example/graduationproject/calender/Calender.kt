package com.example.graduationproject.calender

import android.app.Activity
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.Toast
import com.example.graduationproject.AdapterForEventList
import com.example.graduationproject.R
import com.example.graduationproject.event.Event
import com.example.graduationproject.event.EventDb
import io.realm.Realm
import kotlinx.android.synthetic.main.activity_calender.*
import java.io.Serializable
import java.util.*
import kotlin.collections.ArrayList

class Calender : AppCompatActivity() {

    var mDateOfTheDay :String? = null
    var listEvent : ArrayList<Event>?= null
    lateinit var eventDb : EventDb
    val REQUEST_CODE_FOR_ADDING = 2
    lateinit var adapterForEventList :AdapterForEventList



    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_calender)
        Log.i("lifesycle","oncreate Calendar")

        Realm.init(this)
        eventDb = EventDb(this)
        eventDb.configuration()

        val now = Calendar.getInstance()
        var year = now.get(Calendar.YEAR)
        var month = now.get(Calendar.MONTH)
        var day = now.get(Calendar.DAY_OF_MONTH)
        mDateOfTheDay = "$year$month$day"








        floatingActionButton.setOnClickListener {
            var i = Intent("com.gb.action.addEvent")
            startActivityForResult(i,REQUEST_CODE_FOR_ADDING)
        }
    }

    override fun onStart() {
        super.onStart()
        Log.i("lifesycle","onStart Calendar")


        CalendarList.onItemClickListener =
            AdapterView.OnItemClickListener { p0, p1, p2, p3 ->
                var eve = listEvent!!.get(p2)
                val intent = Intent(this, CalendarView::class.java)
                intent.putExtra("clickedEvent",eve)
                startActivity(intent)

            }


        listEvent = eventDb.returnEvents(mDateOfTheDay!!)

        Toast.makeText(this," count = ${listEvent!!.size}",Toast.LENGTH_SHORT).show()

        if (listEvent!!.size == 0)
        {
            Toast.makeText(applicationContext,"no data available",Toast.LENGTH_LONG).show()
            CalendarList.visibility = View.INVISIBLE
        }else{

            adapterForEventList = AdapterForEventList(applicationContext,listEvent!!)
            CalendarList.adapter = adapterForEventList
            CalendarList.visibility = View.VISIBLE

        }



        mCalendar.setOnDateChangeListener { view, year, month, dayOfMonth ->

            mDateOfTheDay = "$year$month$dayOfMonth"

            //////////////////////////

            listEvent = eventDb.returnEvents(mDateOfTheDay!!)


            if (listEvent!!.size == 0)
            {
                Toast.makeText(applicationContext,"no data available",Toast.LENGTH_LONG).show()
                CalendarList.visibility = View.INVISIBLE
            }else{
                adapterForEventList = AdapterForEventList(applicationContext,listEvent!!)
                CalendarList.adapter = adapterForEventList
                CalendarList.visibility = View.VISIBLE

            }
        }

    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if(requestCode == REQUEST_CODE_FOR_ADDING )
        {
            if (resultCode == Activity.RESULT_OK)
            {
                var intent = data!!.extras

                var eventToBeAdded = Event()
                eventToBeAdded.mDate = this!!.mDateOfTheDay!!
                eventToBeAdded.title = intent.getString("AddEventTitle")
                eventToBeAdded.details = intent.getString("AddEventDetails")
                eventToBeAdded.startTime = intent.getString("AddEventStartTime")
                eventToBeAdded.endTime = intent.getString("AddEventEndTime")


                eventDb.addEvent(eventToBeAdded)

              //  adapterForEventList.notifyDataSetChanged()

            }
        }
    }


    override fun onDestroy() {
        super.onDestroy()
        eventDb.closeRealm()
    }
}
