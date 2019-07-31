package com.example.graduationproject.calender

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.app.AlertDialog
import android.view.Menu
import android.view.MenuInflater
import android.view.MenuItem
import android.widget.Toast
import com.example.graduationproject.R
import com.example.graduationproject.model.Event
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import kotlinx.android.synthetic.main.activity_calendar_view.*

class CalendarView : AppCompatActivity() {
    private var firebaseDataBase : FirebaseDatabase? = null
    private var dbReference : DatabaseReference? = null

    lateinit var  event: Event
    private var mAuth : FirebaseAuth? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_calendar_view)

        val actionBar = supportActionBar
        actionBar!!.title = "Show Event"
        actionBar.elevation = 4.0F

        event= intent.getParcelableExtra("clickedEvent")
        mAuth = FirebaseAuth.getInstance()
        firebaseDataBase = FirebaseDatabase.getInstance()
        dbReference = firebaseDataBase!!.getReference("Events")


        showStartAt.append(" ${event.startDate} at ${event.startTime}")
        showEndAt.append(" ${event.endDate} at ${event.endTime}")
        showTitle.text = event.title
        showLocation.text = event.location
        showDetails.append(event.details)
        showCreator.append(event.eventCreator)

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
                if(mAuth!!.currentUser!!.email != event.eventCreator)
                {
                    Toast.makeText(applicationContext,"u Can not update this event ", Toast.LENGTH_SHORT).show()
                }else
                {
                    val intent = Intent(this, UpdateThisEvent::class.java)
                    intent.putExtra("clickedEventTobeUpdated",event)
                    startActivity(intent)
                    finish()
                }
                true
            }
            R.id.Delete_menu_button ->
            {
                val builder = AlertDialog.Builder(this)
                builder.setMessage("Are you want to delete this Event?")

                builder.setPositiveButton("YES"){dialog, which ->
                    if(mAuth!!.currentUser!!.email != event.eventCreator)
                    {
                        Toast.makeText(applicationContext,"u Can not Delete this event ", Toast.LENGTH_SHORT).show()
                    }else
                    {
                        var childRef = dbReference!!.child(event.id)
                        childRef.removeValue()
                        Toast.makeText(this,"Event was deleted", Toast.LENGTH_LONG).show()
                        finish()
                    }

                }

                builder.setNeutralButton("Cancel"){_,_ ->
                    Toast.makeText(this,"Cancel", Toast.LENGTH_LONG).show()
                }
                val dialog: AlertDialog = builder.create()
                dialog.show()

                true

            }
            else -> super.onOptionsItemSelected(item)
        }
    }


}
