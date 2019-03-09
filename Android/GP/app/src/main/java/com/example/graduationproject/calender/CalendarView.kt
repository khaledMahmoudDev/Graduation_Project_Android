package com.example.graduationproject.calender

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.view.Menu
import android.view.MenuInflater
import android.view.MenuItem
import com.example.graduationproject.R
import com.example.graduationproject.event.Event
import kotlinx.android.synthetic.main.activity_calendar_view.*

class CalendarView : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_calendar_view)

        val event: Event = intent.getParcelableExtra("clickedEvent")

        show_start_time.text = event.startTime
        show_end_time.text = event.endTime
        show_title.text = event.title
        show_details.text = event.details




    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        val inflater: MenuInflater = menuInflater
        inflater.inflate(R.menu.edit_menu, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        // Handle item selection
        return when (item.itemId) {
            R.id.edit_menu_button -> {


                true
            }

            else -> super.onOptionsItemSelected(item)
        }
    }


}
