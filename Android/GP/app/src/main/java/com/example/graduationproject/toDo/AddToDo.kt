package com.example.graduationproject.toDo

import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.text.format.DateFormat
import com.example.graduationproject.R
import com.example.graduationproject.model.ToDoModelFireBase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import kotlinx.android.synthetic.main.activity_add_to_do.*
import java.text.SimpleDateFormat
import java.util.*

class AddToDo : AppCompatActivity() {
    var startTime:String = "00:00"
    var endTime:String = "00:00"
    var startDate : String = ""
    var endDate : String = ""
    var title : String = ""
    var details :String = ""
    var status : String = "ToDo"
    var priority : String = "Medium"
    private var mAuth : FirebaseAuth? = null
    private var firebaseDataBase : FirebaseDatabase? = null
    private var dbReference : DatabaseReference? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_add_to_do)
        val actionBar = supportActionBar
        actionBar!!.title = "Add Todo"
        actionBar.elevation = 4.0F

        mAuth = FirebaseAuth.getInstance()
        firebaseDataBase = FirebaseDatabase.getInstance()
        dbReference = firebaseDataBase!!.reference
        dbReference!!.keepSynced(true)

        btnToDo.background = resources.getDrawable(R.drawable.status_todo_clicked)
        btnInProgress.background = resources.getDrawable(R.drawable.status_inprogress_unclicked)
        btnDone.background = resources.getDrawable(R.drawable.status_done_unclicked)

        todoAddHighButton.background = resources.getDrawable(R.drawable.priority_high_unclicked)
        todoAddMediumButton.background = resources.getDrawable(R.drawable.priority_medium_clicked)
        todoAddLowButton.background = resources.getDrawable(R.drawable.priority_low_unclicked)


        todoAddStartTime.setOnClickListener{
            val now = Calendar.getInstance()


            val timePickerDialog = TimePickerDialog(this,
                TimePickerDialog.OnTimeSetListener { view, hourOfDay, minute ->

                    todoAddStartTime.text = "$hourOfDay:$minute"
                    startTime = "$hourOfDay:$minute"
                },
                now.get(Calendar.HOUR_OF_DAY),
                now.get(Calendar.SECOND),
                DateFormat.is24HourFormat(applicationContext))

            timePickerDialog.show()
        }
        todoAddStartDate.setOnClickListener {
            val now = Calendar.getInstance()
            val datePickerDialog = DatePickerDialog(this,
                DatePickerDialog.OnDateSetListener{ datePicker, year, month, day ->


                    val sdf = SimpleDateFormat("MM dd yyyy", Locale.ENGLISH)
                    val parsedDate = sdf.parse("$month $day $year")
                    val date1 = SimpleDateFormat("MMM dd, yyyy")
                    var lDAte = date1.format(parsedDate)
                    startDate = lDAte

                    todoAddStartDate.text = lDAte

                },now.get(Calendar.YEAR),now.get(Calendar.MONTH),now.get(Calendar.DAY_OF_MONTH))
            datePickerDialog.show()
        }
        todoAddEndTime.setOnClickListener {
            val now = Calendar.getInstance()

            val timePickerDialog = TimePickerDialog(this,
                TimePickerDialog.OnTimeSetListener { view, hourOfDay, minute ->
                    todoAddEndTime.text = "$hourOfDay:$minute"
                    endTime = "$hourOfDay:$minute"
                },
                now.get(Calendar.HOUR_OF_DAY),
                now.get(Calendar.SECOND),
               DateFormat.is24HourFormat(applicationContext))
            timePickerDialog.show()
        }
        todoAddEndDate.setOnClickListener {
            val now = Calendar.getInstance()
            val datePickerDialog = DatePickerDialog(this,
                DatePickerDialog.OnDateSetListener{ datePicker, year, month, day ->

                    val sdf = SimpleDateFormat("MM dd yyyy", Locale.ENGLISH)
                    val parsedDate = sdf.parse("$month $day $year")
                    val date1 = SimpleDateFormat("MMM dd, yyyy")
                    var lDAte = date1.format(parsedDate)
                    endDate = lDAte

                    todoAddEndDate.text = lDAte
                },now.get(Calendar.YEAR),now.get(Calendar.MONTH),now.get(Calendar.DAY_OF_MONTH))
            datePickerDialog.show()
        }



        btnToDo.setOnClickListener {
            status = "ToDo"
            btnToDo.background = resources.getDrawable(R.drawable.status_todo_clicked)
            btnInProgress.background = resources.getDrawable(R.drawable.status_inprogress_unclicked)
            btnDone.background = resources.getDrawable(R.drawable.status_done_unclicked)

        }
        btnInProgress.setOnClickListener {
            status = "InProgress"
            btnToDo.background = resources.getDrawable(R.drawable.status_todo_unclicked)
            btnInProgress.background = resources.getDrawable(R.drawable.status_inprogress_clicked)
            btnDone.background = resources.getDrawable(R.drawable.status_done_unclicked)
        }
        btnDone.setOnClickListener {
            status = "Done"
            btnToDo.background = resources.getDrawable(R.drawable.status_todo_unclicked)
            btnInProgress.background = resources.getDrawable(R.drawable.status_inprogress_unclicked)
            btnDone.background = resources.getDrawable(R.drawable.status_done_clicked)
        }
        /////////////////////////////////////////////*/////////////////////////////////*///////////////////////
        todoAddHighButton.setOnClickListener {
            priority = "High"
            todoAddHighButton.background = resources.getDrawable(R.drawable.priority_high_clicked)
            todoAddMediumButton.background = resources.getDrawable(R.drawable.priority_medium_unclicked)
            todoAddLowButton.background = resources.getDrawable(R.drawable.priority_low_unclicked)
        }
        todoAddMediumButton.setOnClickListener {
            priority = "Medium"
            todoAddHighButton.background = resources.getDrawable(R.drawable.priority_high_unclicked)
            todoAddMediumButton.background = resources.getDrawable(R.drawable.priority_medium_clicked)
            todoAddLowButton.background = resources.getDrawable(R.drawable.priority_low_unclicked)
        }
        todoAddLowButton.setOnClickListener {
            priority = "Low"
            todoAddHighButton.background = resources.getDrawable(R.drawable.priority_high_unclicked)
            todoAddMediumButton.background = resources.getDrawable(R.drawable.priority_medium_unclicked)
            todoAddLowButton.background = resources.getDrawable(R.drawable.priority_low_clicked)
        }




        TodoAdd.setOnClickListener {
            var mTodo = ToDoModelFireBase()
            mTodo.title = todoAddTitle.text.toString()
            mTodo.datails = todoAddDetails.text.toString()
            mTodo.startTime = startTime
            mTodo.startDate = startDate
            mTodo.endTime = endTime
            mTodo.endDate = endDate
            mTodo.priority = priority
            mTodo.status = status
            mTodo.id = dbReference!!.child("ToDo")
                .child(mAuth!!.currentUser!!.uid)
                .push().key.toString()

            dbReference!!.child("ToDo")
                .child(mAuth!!.currentUser!!.uid)
                .child(mTodo.id).setValue(mTodo)
            finish()
        }
    }
}
