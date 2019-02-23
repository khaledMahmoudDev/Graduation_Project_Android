 package com.example.graduationproject.mainPac

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import com.example.graduationproject.calender.Calender
import com.example.graduationproject.R
import com.example.graduationproject.email.Email
import com.example.graduationproject.location.Location
import com.example.graduationproject.note.Note
import com.example.graduationproject.toDo.ToDo
import com.example.graduationproject.weather.Weather
import kotlinx.android.synthetic.main.activity_main.*

 class MainActivity : AppCompatActivity(){

     override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)






         mainCalender.setOnClickListener { startActivity(Intent(this, Calender::class.java)) }
         mainSendMail.setOnClickListener { startActivity(Intent(this,Email::class.java)) }
         mainToDo.setOnClickListener { startActivity(Intent(this,ToDo::class.java)) }
         mainNote.setOnClickListener { startActivity(Intent(this,Note::class.java)) }
         mainWeather.setOnClickListener { startActivity(Intent(this,Weather::class.java)) }
         mainMap.setOnClickListener { startActivity(Intent(this,Location::class.java)) }

    }

 }
