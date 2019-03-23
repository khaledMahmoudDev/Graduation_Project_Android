 package com.example.graduationproject.mainPac

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import com.example.graduationproject.calender.Calender
import com.example.graduationproject.R
import com.example.graduationproject.email.Email
import com.example.graduationproject.location.Location
import com.example.graduationproject.note.Note
import com.example.graduationproject.profile.Profile
import com.example.graduationproject.profile.SignIn
import com.example.graduationproject.profile.Signup
import com.example.graduationproject.toDo.ToDo
import com.example.graduationproject.weather.Weather
import com.google.firebase.auth.FirebaseAuth
import kotlinx.android.synthetic.main.activity_main.*

 class MainActivity : AppCompatActivity(){

     var mAuth : FirebaseAuth? = null

     override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

         mAuth = FirebaseAuth.getInstance()

         mainCalender.setOnClickListener { startActivity(Intent(this, Calender::class.java)) }
         mainSendMail.setOnClickListener { startActivity(Intent(this,Email::class.java)) }
         mainToDo.setOnClickListener { startActivity(Intent(this,ToDo::class.java)) }
         mainNote.setOnClickListener { startActivity(Intent(this,Note::class.java)) }
         mainWeather.setOnClickListener { startActivity(Intent(this,Weather::class.java)) }
         mainMap.setOnClickListener { startActivity(Intent(this,Location::class.java)) }



    }

     override fun onStart() {
         super.onStart()
         if(mAuth?.currentUser == null)
         {
             startActivity(Intent(this,SignIn::class.java))
             finish()
         }

     }

     override fun onCreateOptionsMenu(menu: Menu?): Boolean {

         menuInflater.inflate(R.menu.main_menu,menu)
         return true
     }

     override fun onOptionsItemSelected(item: MenuItem?): Boolean {
         var id = item?.itemId
         if (id == R.id.signOut )
         {
             FirebaseAuth.getInstance().signOut()
             startActivity(Intent(applicationContext, SignIn::class.java))
             finish()
         }else if (id == R.id.menuProfile)
         {
             startActivity(Intent(this,Profile::class.java))
         }


         return true

     }


 }






