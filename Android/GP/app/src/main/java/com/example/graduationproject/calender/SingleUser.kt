package com.example.graduationproject.calender

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.AdapterView
import android.widget.Toast
import com.bumptech.glide.Glide
import com.example.graduationproject.AdapterForEventList
import com.example.graduationproject.R
import com.example.graduationproject.model.Event
import com.example.graduationproject.model.EventFireBase
import com.example.graduationproject.model.User
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.*
import kotlinx.android.synthetic.main.activity_calender.*
import kotlinx.android.synthetic.main.activity_single_user.*
import kotlinx.android.synthetic.main.fragment_browse_event.*
import java.util.ArrayList

class SingleUser : AppCompatActivity() {
    lateinit var inUser : User

    var listEvent : ArrayList<Event>?= null
    lateinit var adapterForEventList : AdapterForEventList
    private var firebaseDataBase : FirebaseDatabase? = null
    private var dbReference : DatabaseReference? = null


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_single_user)

        listEvent = ArrayList()
        inUser= intent.getParcelableExtra("ClickedUser")
        showUserName.text = inUser.firstName
        showUserEmail.text = inUser.email
        Glide.with(applicationContext).load(inUser.imageLink).into(showUserImage)

        firebaseDataBase = FirebaseDatabase.getInstance()
        dbReference = firebaseDataBase!!.getReference("Events")

        dbReference!!.addListenerForSingleValueEvent(object : ValueEventListener {
            override fun onCancelled(p0: DatabaseError) {
                TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
            }

            override fun onDataChange(p0: DataSnapshot) {

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
                    mEv.privacy = ev.privacy
                    mEv.location = ev.location

                    if (ev.mEventCreator == inUser.email )
                    {
                        if (ev.privacy)
                        {
                            listEvent!!.add(mEv)

                        }
                    }

                }
                Toast.makeText(applicationContext,"list contains ${listEvent!!.size}",Toast.LENGTH_SHORT).show()
                adapterForEventList = AdapterForEventList(applicationContext!!,listEvent!!)
                showUserListEvent.adapter = adapterForEventList
            }

        })
        showUserListEvent.onItemClickListener =
            AdapterView.OnItemClickListener { p0, p1, p2, p3 ->
                var eve = listEvent!!.get(p2)
                val intent = Intent(applicationContext, CalendarView::class.java)
                intent.putExtra("clickedEvent",eve)
                startActivity(intent)
            }



    }
}
