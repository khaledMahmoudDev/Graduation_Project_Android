package com.example.graduationproject.fragment


import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.support.v4.app.Fragment
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.Toast
import com.example.graduationproject.AdapterForEventList

import com.example.graduationproject.R
import com.example.graduationproject.calender.CalendarView
import com.example.graduationproject.model.Event
import com.example.graduationproject.model.EventDb
import com.example.graduationproject.model.EventFireBase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.*
import io.realm.Realm
import kotlinx.android.synthetic.main.activity_calender.*
import java.util.*

// TODO: Rename parameter arguments, choose names that match
// the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
private const val ARG_PARAM1 = "param1"
private const val ARG_PARAM2 = "param2"

/**
 * A simple [Fragment] subclass.
 *
 */
class CalenderFragment : Fragment() {
    var mDateOfTheDay :String? = null
    var listEvent : ArrayList<Event>?= null
    lateinit var eventDb : EventDb
    val REQUEST_CODE_FOR_ADDING = 2
    lateinit var adapterForEventList : AdapterForEventList
    private var mAuth : FirebaseAuth? = null
    private var firebaseDataBase : FirebaseDatabase? = null
    private var dbReference : DatabaseReference? = null


    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_calender2, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        mAuth = FirebaseAuth.getInstance()
        firebaseDataBase = FirebaseDatabase.getInstance()
        dbReference = firebaseDataBase!!.getReference("Events")



        Log.i("lifesycle","oncreate Calendar")

        Realm.init(context)
        eventDb = EventDb(context!!)
        eventDb.configuration()

        eventDb.cleareDB()

        val now = Calendar.getInstance()
        var year = now.get(Calendar.YEAR)
        var month = now.get(Calendar.MONTH)
        var day = now.get(Calendar.DAY_OF_MONTH)
        mDateOfTheDay = "$year$month$day"



        floatingActionButton.setOnClickListener {
            var i = Intent("com.gb.action.addEvent")
            i.putExtra("dateOfTheDay",mDateOfTheDay)
            startActivityForResult(i,REQUEST_CODE_FOR_ADDING)
        }

    }
    override fun onStart() {
        super.onStart()



        dbReference!!.addListenerForSingleValueEvent(object : ValueEventListener {
            override fun onCancelled(p0: DatabaseError) {
                TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
            }

            override fun onDataChange(p0: DataSnapshot) {
                eventDb.cleareDB()
                for (n in p0.children)
                {
                    var ev = n.getValue(EventFireBase::class.java)
                    var mEv = Event()
                    mEv.title = ev!!.mTitle
                    mEv.mDate = ev!!.mDate
                    mEv.startTime = ev!!.mStartTime
                    mEv.endTime = ev!!.mEndTime
                    mEv.details = ev!!.mDetails
                    mEv.eventCreator = ev.mEventCreator
                    mEv.id = ev.id

                    if (mEv.eventCreator == mAuth!!.currentUser!!.email.toString())
                    {
                        eventDb.addEvent(mEv)
                    }

                }
            }

        })


        dbReference?.child("Events")!!.orderByChild("mEventCreator").equalTo(mAuth!!.currentUser!!.email).
            addValueEventListener(object : ValueEventListener {



                override fun onCancelled(p0: DatabaseError) {
                    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
                }

                override fun onDataChange(p0: DataSnapshot) {


                    eventDb.cleareDB()

                    for (n in p0.children )
                    {
                        var ev = n.getValue(EventFireBase::class.java)
                        var mEv = Event()
                        mEv.title = ev!!.mTitle
                        mEv.mDate = ev!!.mDate
                        mEv.startTime = ev!!.mStartTime
                        mEv.endTime = ev!!.mEndTime
                        mEv.details = ev!!.mDetails
                        mEv.eventCreator = ev.mEventCreator
                        if (mEv.eventCreator == mAuth!!.currentUser!!.email.toString())
                        {
                            eventDb.addEvent(mEv)
                        }


                    }
                }

            })



        CalendarList.onItemClickListener =
            AdapterView.OnItemClickListener { p0, p1, p2, p3 ->
                var eve = listEvent!!.get(p2)
                val intent = Intent(context, CalendarView::class.java)
                intent.putExtra("clickedEvent",eve)
                startActivity(intent)
            }
        listEvent = eventDb.returnEvents(mDateOfTheDay!!)

        Toast.makeText(context," count = ${listEvent!!.size}", Toast.LENGTH_SHORT).show()

        if (listEvent!!.size == 0)
        {
            Toast.makeText(context,"no data available", Toast.LENGTH_LONG).show()
            CalendarList.visibility = View.INVISIBLE
        }else{
            adapterForEventList = AdapterForEventList(context!!,listEvent!!)
            CalendarList.adapter = adapterForEventList
            CalendarList.visibility = View.VISIBLE
        }
        mCalendar.setOnDateChangeListener { view, year, month, dayOfMonth ->
            mDateOfTheDay = "$year$month$dayOfMonth"

            listEvent = eventDb.returnEvents(mDateOfTheDay!!)
            if (listEvent!!.size == 0)
            {
                Toast.makeText(context,"no data available", Toast.LENGTH_LONG).show()
                CalendarList.visibility = View.INVISIBLE
            }else{
                adapterForEventList = AdapterForEventList(context!!,listEvent!!)
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
                eventToBeAdded.eventCreator = mAuth!!.currentUser!!.email.toString()

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
