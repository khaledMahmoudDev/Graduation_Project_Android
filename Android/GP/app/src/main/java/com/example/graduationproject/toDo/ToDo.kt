package com.example.graduationproject.toDo

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import com.example.graduationproject.R
import kotlinx.android.synthetic.main.activity_to_do.*

class ToDo : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_to_do)
        val actionBar = supportActionBar
        actionBar!!.title = "Todo"
        actionBar.elevation = 4.0F
        var mToDOAdapter = ToDoAdapter(supportFragmentManager)
        TodoViewPager.adapter = mToDOAdapter
    }


}
