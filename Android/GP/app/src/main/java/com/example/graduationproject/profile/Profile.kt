package com.example.graduationproject.profile

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Toast
import com.bumptech.glide.Glide
import com.example.graduationproject.R
import com.example.graduationproject.model.User
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.*
import com.squareup.picasso.Picasso
import kotlinx.android.synthetic.main.activity_profile.*

class Profile : AppCompatActivity() {
    private var mAuth : FirebaseAuth? = null
    private var firebaseDataBase : FirebaseDatabase? = null
    private var dbReference : DatabaseReference? = null
    var usr :User? = null


//    myref!!.child("USERS").child(auth!!.currentUser!!.uid)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_profile)
        usr = User()
        val actionBar = supportActionBar
        actionBar!!.title = "Profile"
        actionBar.elevation = 4.0F


        mAuth = FirebaseAuth.getInstance()
        firebaseDataBase = FirebaseDatabase.getInstance()
        dbReference = firebaseDataBase!!.getReference("USERS")



        btn_updateData.setOnClickListener {
            startActivity(Intent(this,UpdateProfile::class.java))
        }


        var uId = mAuth!!.currentUser!!.uid
        dbReference!!.child(uId).addValueEventListener(object :ValueEventListener{
            override fun onCancelled(p0: DatabaseError) {
                TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
            }

            override fun onDataChange(p0: DataSnapshot) {

                usr = p0.getValue(User::class.java)

                profileFirstName.text = usr!!.firstName
                profileEmail.text = usr!!.email
                if(usr!!.imageLink!!.isNotEmpty())
                {
                   Glide.with(applicationContext).load(usr!!.imageLink).into(profileImageView)
                }
            }
        })

    }
}
