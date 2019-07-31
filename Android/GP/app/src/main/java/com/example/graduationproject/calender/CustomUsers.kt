package com.example.graduationproject.calender

import android.app.Activity
import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.AdapterView
import android.widget.Toast
import com.example.graduationproject.R
import com.example.graduationproject.fragment.UsersAdapter
import com.example.graduationproject.model.User
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.*
import kotlinx.android.synthetic.main.activity_custom_users.*
import kotlinx.android.synthetic.main.fragment_users_view.*
import java.util.ArrayList

class CustomUsers : AppCompatActivity() {
    var listUsers : ArrayList<User>?= null
    var usrListName : ArrayList<String>? = null
    lateinit var usersAdapter: UsersAdapter
    private var firebaseDataBase : FirebaseDatabase? = null
    private var dbReference : DatabaseReference? = null

    var mAuth : FirebaseAuth? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_custom_users)
        usrListName = ArrayList()
        mAuth = FirebaseAuth.getInstance()

        custom_user_listView.onItemClickListener = AdapterView.OnItemClickListener{ p0, p1, p2, p3 ->
            var eve = listUsers!!.get(p2)
            usrListName!!.add(eve.email!!)
            custom_user_text.append(eve.email)
            custom_user_text.append(" , ")
            listUsers!!.remove(listUsers!!.get(p2))
            usersAdapter.notifyDataSetChanged()


        }
        custom_usr_done.setOnClickListener {
            var i = Intent()
            Toast.makeText(applicationContext,"count of this is ${usrListName!!.size}",Toast.LENGTH_LONG).show()
            i.putExtra("listString",usrListName)
            setResult(Activity.RESULT_OK,i)
            finish()

        }
    }
    override fun onStart() {
        super.onStart()
        firebaseDataBase = FirebaseDatabase.getInstance()
        dbReference = firebaseDataBase!!.getReference("USERS")
        listUsers = ArrayList()


        dbReference!!.addListenerForSingleValueEvent(object : ValueEventListener {
            override fun onCancelled(p0: DatabaseError) {
                TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
            }

            override fun onDataChange(p0: DataSnapshot) {
                for (n in p0.children)
                {
                    var users = n.getValue(User::class.java)
                    if (users != null) {
                        if(users.email == mAuth!!.currentUser!!.email )
                        {
                        }else
                        {
                            listUsers!!.add(users)
                        }

                    }
                }
                usersAdapter = UsersAdapter(applicationContext,listUsers!!)
                custom_user_listView.adapter = usersAdapter

            }

        })

    }
}
