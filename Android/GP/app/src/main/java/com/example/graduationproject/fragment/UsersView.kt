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
import com.example.graduationproject.calender.SingleUser
import com.example.graduationproject.model.Event
import com.example.graduationproject.model.User
import com.google.firebase.database.*
import kotlinx.android.synthetic.main.fragment_browse_event.*
import kotlinx.android.synthetic.main.fragment_users_view.*
import java.util.ArrayList

// TODO: Rename parameter arguments, choose names that match
// the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
private const val ARG_PARAM1 = "param1"
private const val ARG_PARAM2 = "param2"

/**
 * A simple [Fragment] subclass.
 *
 */
class UsersView : Fragment() {
    var listUsers : ArrayList<User>?= null
    lateinit var usersAdapter: UsersAdapter
    private var firebaseDataBase : FirebaseDatabase? = null
    private var dbReference : DatabaseReference? = null

    override fun onStart() {
        super.onStart()
        firebaseDataBase = FirebaseDatabase.getInstance()
        dbReference = firebaseDataBase!!.getReference("USERS")
        listUsers = ArrayList()


        dbReference!!.addListenerForSingleValueEvent(object : ValueEventListener{
            override fun onCancelled(p0: DatabaseError) {
                TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
            }

            override fun onDataChange(p0: DataSnapshot) {
                for (n in p0.children)
                {
                    var users = n.getValue(User::class.java)
                    if (users != null) {
                        listUsers!!.add(users)
                    }
                }

                usersAdapter = UsersAdapter(context!!,listUsers!!)
                UsersList.adapter = usersAdapter


            }

        })

    }


    override fun onCreateView(

        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment


        return inflater.inflate(R.layout.fragment_users_view, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        UsersList.onItemClickListener =
            AdapterView.OnItemClickListener { p0, p1, p2, p3 ->
                var eve = listUsers!!.get(p2)
                val intent = Intent(context, SingleUser::class.java)
                intent.putExtra("ClickedUser",eve)
                startActivity(intent)
            }

        }
    }

