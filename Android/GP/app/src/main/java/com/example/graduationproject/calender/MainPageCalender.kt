package com.example.graduationproject.calender

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import com.example.graduationproject.R
import kotlinx.android.synthetic.main.content_main_page_calender.*

class MainPageCalender : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.content_main_page_calender)


        var mScrollAdapter = ScrollableTabeAdapter(supportFragmentManager,this)
        myViewPager.adapter = mScrollAdapter

    }

}
