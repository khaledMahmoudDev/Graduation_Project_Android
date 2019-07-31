 package com.example.graduationproject.mainPac

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.app.AlertDialog
import android.view.Menu
import android.view.MenuItem
import android.widget.Toast
import com.example.graduationproject.R
import com.example.graduationproject.calender.MainPageCalender
import com.example.graduationproject.email.Email
import com.example.graduationproject.note.Note
import com.example.graduationproject.profile.Profile
import com.example.graduationproject.profile.SignIn
import com.example.graduationproject.toDo.ToDo
import com.google.firebase.auth.FirebaseAuth
import kotlinx.android.synthetic.main.activity_main.*

 class MainActivity : AppCompatActivity(){

     var mAuth : FirebaseAuth? = null

     override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

         val actionBar = supportActionBar
         actionBar!!.title = "Personal Assistant"
         actionBar.elevation = 4.0F

         mAuth = FirebaseAuth.getInstance()

         mainCalender.setOnClickListener { startActivity(Intent(this, MainPageCalender::class.java)) }
         mainSendMail.setOnClickListener { startActivity(Intent(this,Email::class.java)) }
         mainToDo.setOnClickListener { startActivity(Intent(this,ToDo::class.java)) }
         mainNote.setOnClickListener { startActivity(Intent(this,Note::class.java)) }
         logOutNow.setOnClickListener {
             val builder = AlertDialog.Builder(this)
             builder.setMessage("Are you sure you want to LogOut?")

             builder.setPositiveButton("YES"){dialog, which ->
                 FirebaseAuth.getInstance().signOut()
                 startActivity(Intent(applicationContext, SignIn::class.java))
                 finish()
             }
             builder.setNeutralButton("Cancel"){_,_ ->
                 Toast.makeText(this,"Cancel", Toast.LENGTH_LONG).show()
             }
             val dialog: AlertDialog = builder.create()
             dialog.show()
           }
         profileNow.setOnClickListener {
             startActivity(Intent(this,Profile::class.java))
         }



    }

     override fun onStart() {
         super.onStart()
         if(mAuth?.currentUser == null)
         {
             startActivity(Intent(this,SignIn::class.java))
             finish()
         }

     }





 }






