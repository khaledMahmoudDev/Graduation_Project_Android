package com.example.graduationproject.fragment


import android.content.Intent
import android.os.Bundle
import android.support.v4.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import com.example.graduationproject.AdapterForEventList

import com.example.graduationproject.R
import com.example.graduationproject.calender.CalendarView
import com.example.graduationproject.model.Event
import com.example.graduationproject.model.EventFireBase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.*
import kotlinx.android.synthetic.main.fragment_browse_event.*
import java.util.ArrayList

// TODO: Rename parameter arguments, choose names that match
// the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
private const val ARG_PARAM1 = "param1"
private const val ARG_PARAM2 = "param2"

/**
 * A simple [Fragment] subclass.
 *
 */
class BrowseEventFragment : Fragment() {
    var listEvent : ArrayList<Event>?= null
    lateinit var adapterForEventList : AdapterForEventList
    private var firebaseDataBase : FirebaseDatabase? = null
    private var dbReference : DatabaseReference? = null
    private var mAuth : FirebaseAuth? = null


    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment

        return inflater.inflate(R.layout.fragment_browse_event, container, false)
    }

    override fun onStart() {
        super.onStart()
        firebaseDataBase = FirebaseDatabase.getInstance()
        dbReference = firebaseDataBase!!.getReference("Events")
        mAuth = FirebaseAuth.getInstance()
        listEvent = ArrayList()


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
                    mEv.startDate = ev.startDate
                    mEv.endDate = ev.endDate

                    if (ev.mEventCreator == mAuth!!.currentUser!!.email.toString())
                    {
                        listEvent!!.add(mEv)
                    }else
                    {
                        if(mEv.privacy == "public")
                        {
                            listEvent!!.add(mEv)

                        }else if (mEv.privacy == "CustomUsers")
                        {
                            for (n in mEv.customUsrs!!)
                            {
                                if (n == mAuth!!.currentUser!!.email.toString())
                                {
                                    listEvent!!.add(mEv)
                                }
                            }

                        }

                    }
                }
                adapterForEventList = AdapterForEventList(context!!,listEvent!!)
                PublicList.adapter = adapterForEventList
            }

        })

    }
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        PublicList.onItemClickListener =
            AdapterView.OnItemClickListener { p0, p1, p2, p3 ->
                var eve = listEvent!!.get(p2)
                val intent = Intent(context, CalendarView::class.java)
                intent.putExtra("clickedEvent",eve)
                startActivity(intent)
            }
    }

}
