package com.example.graduationproject.toDo

import android.app.DatePickerDialog
import android.app.TimePickerDialog
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.text.format.DateFormat
import com.example.graduationproject.R
import com.example.graduationproject.model.ToDoModel
import com.example.graduationproject.model.ToDoModelFireBase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import kotlinx.android.synthetic.main.activity_update_to_do.*
import java.text.SimpleDateFormat
import java.util.*

class UpdateToDo : AppCompatActivity() {

    lateinit var mTodo : ToDoModel

    private var mAuth : FirebaseAuth? = null
    private var firebaseDataBase : FirebaseDatabase? = null
    private var dbReference : DatabaseReference? = null


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_update_to_do)

        val actionBar = supportActionBar
        actionBar!!.title = "Update Todo"
        actionBar.elevation = 4.0F

        mAuth = FirebaseAuth.getInstance()
        firebaseDataBase = FirebaseDatabase.getInstance()
        dbReference = firebaseDataBase!!.reference
        dbReference!!.keepSynced(true)


        mTodo = intent.getParcelableExtra("clickedTodoTobeUpdated")
        todoUpdateAddStartTime.text = mTodo.startTime
        todoUpdateAddStartDate.text = mTodo.startDate
        todoUpdateAddEndTime.text = mTodo.endTime
        todoUpdateAddEndDate.text = mTodo.endDate
        todoUpdateAddTitle.append(mTodo.title)
        todoUpdateAddDetails.append(mTodo.datails)

        if (mTodo.status == "ToDo")
        {
            btnUpdateToDo.background = resources.getDrawable(R.drawable.status_todo_clicked)
            btnUpdateInProgress.background = resources.getDrawable(R.drawable.status_inprogress_unclicked)
            btnUpdateDone.background = resources.getDrawable(R.drawable.status_done_unclicked)
        }else if (mTodo.status == "InProgress")
        {
            btnUpdateToDo.background = resources.getDrawable(R.drawable.status_todo_unclicked)
            btnUpdateInProgress.background = resources.getDrawable(R.drawable.status_inprogress_clicked)
            btnUpdateDone.background = resources.getDrawable(R.drawable.status_done_unclicked)
        }else if (mTodo.status == "Done")
        {
            btnUpdateToDo.background = resources.getDrawable(R.drawable.status_todo_unclicked)
            btnUpdateInProgress.background = resources.getDrawable(R.drawable.status_inprogress_unclicked)
            btnUpdateDone.background = resources.getDrawable(R.drawable.status_done_clicked)
        }

        if (mTodo.priority == "High")
        {
            todoUpdateAddHighButton.background = resources.getDrawable(R.drawable.priority_high_clicked)
            todoUpdateAddMediumButton.background = resources.getDrawable(R.drawable.priority_medium_unclicked)
            todoUpdateAddLowButton.background = resources.getDrawable(R.drawable.priority_low_unclicked)
        }else if (mTodo.priority == "Medium")
        {
            todoUpdateAddHighButton.background = resources.getDrawable(R.drawable.priority_high_unclicked)
            todoUpdateAddMediumButton.background = resources.getDrawable(R.drawable.priority_medium_clicked)
            todoUpdateAddLowButton.background = resources.getDrawable(R.drawable.priority_low_unclicked)

        }else if (mTodo.priority == "Low")
        {
            todoUpdateAddHighButton.background = resources.getDrawable(R.drawable.priority_high_unclicked)
            todoUpdateAddMediumButton.background = resources.getDrawable(R.drawable.priority_medium_unclicked)
            todoUpdateAddLowButton.background = resources.getDrawable(R.drawable.priority_low_clicked)

        }
        todoUpdateAddStartTime.setOnClickListener {
            val now = Calendar.getInstance()


            val timePickerDialog = TimePickerDialog(this,
                TimePickerDialog.OnTimeSetListener { view, hourOfDay, minute ->

                    todoUpdateAddStartTime.text = "$hourOfDay:$minute"
                    mTodo.startTime = "$hourOfDay:$minute"
                },
                now.get(Calendar.HOUR_OF_DAY),
                now.get(Calendar.SECOND),
                DateFormat.is24HourFormat(applicationContext))
            timePickerDialog.show()
        }


        todoUpdateAddStartDate.setOnClickListener {
            val now = Calendar.getInstance()
            val datePickerDialog = DatePickerDialog(this,
                DatePickerDialog.OnDateSetListener{ datePicker, year, month, day ->


                    val sdf = SimpleDateFormat("MM dd yyyy", Locale.ENGLISH)
                    val parsedDate = sdf.parse("$month $day $year")
                    val date1 = SimpleDateFormat("MMM dd, yyyy")
                    var lDAte = date1.format(parsedDate)
                    mTodo.startDate = lDAte

                    todoUpdateAddStartDate.text = lDAte

                },now.get(Calendar.YEAR),now.get(Calendar.MONTH),now.get(Calendar.DAY_OF_MONTH))
            datePickerDialog.show()
        }
        todoUpdateAddEndTime.setOnClickListener {
            val now = Calendar.getInstance()

            val timePickerDialog = TimePickerDialog(this,
                TimePickerDialog.OnTimeSetListener { view, hourOfDay, minute ->
                    todoUpdateAddEndTime.text = "$hourOfDay:$minute"
                    mTodo.endTime = "$hourOfDay:$minute"
                },
                now.get(Calendar.HOUR_OF_DAY),
                now.get(Calendar.SECOND),
                DateFormat.is24HourFormat(applicationContext))
            timePickerDialog.show()
        }
        todoUpdateAddEndDate.setOnClickListener {
            val now = Calendar.getInstance()
            val datePickerDialog = DatePickerDialog(this,
                DatePickerDialog.OnDateSetListener{ datePicker, year, month, day ->

                    val sdf = SimpleDateFormat("MM dd yyyy", Locale.ENGLISH)
                    val parsedDate = sdf.parse("$month $day $year")
                    val date1 = SimpleDateFormat("MMM dd, yyyy")
                    var lDAte = date1.format(parsedDate)
                    mTodo.endDate = lDAte

                    todoUpdateAddEndDate.text = lDAte
                },now.get(Calendar.YEAR),now.get(Calendar.MONTH),now.get(Calendar.DAY_OF_MONTH))
            datePickerDialog.show()
        }
        //////////////////////
        btnUpdateToDo.setOnClickListener {
            mTodo.status = "ToDo"
            btnUpdateToDo.background = resources.getDrawable(R.drawable.status_todo_clicked)
            btnUpdateInProgress.background = resources.getDrawable(R.drawable.status_inprogress_unclicked)
            btnUpdateDone.background = resources.getDrawable(R.drawable.status_done_unclicked)

        }
        btnUpdateInProgress.setOnClickListener {
            mTodo.status = "InProgress"
            btnUpdateToDo.background = resources.getDrawable(R.drawable.status_todo_unclicked)
            btnUpdateInProgress.background = resources.getDrawable(R.drawable.status_inprogress_clicked)
            btnUpdateDone.background = resources.getDrawable(R.drawable.status_done_unclicked)
        }
        btnUpdateDone.setOnClickListener {
            mTodo.status = "Done"
            btnUpdateToDo.background = resources.getDrawable(R.drawable.status_todo_unclicked)
            btnUpdateInProgress.background = resources.getDrawable(R.drawable.status_inprogress_unclicked)
            btnUpdateDone.background = resources.getDrawable(R.drawable.status_done_clicked)
        }
        /////////////////////////////////////////////*/////////////////////////////////*///////////////////////
        todoUpdateAddHighButton.setOnClickListener {
            mTodo.priority = "High"
            todoUpdateAddHighButton.background = resources.getDrawable(R.drawable.priority_high_clicked)
            todoUpdateAddMediumButton.background = resources.getDrawable(R.drawable.priority_medium_unclicked)
            todoUpdateAddLowButton.background = resources.getDrawable(R.drawable.priority_low_unclicked)
        }
        todoUpdateAddMediumButton.setOnClickListener {
            mTodo.priority = "Medium"
            todoUpdateAddHighButton.background = resources.getDrawable(R.drawable.priority_high_unclicked)
            todoUpdateAddMediumButton.background = resources.getDrawable(R.drawable.priority_medium_clicked)
            todoUpdateAddLowButton.background = resources.getDrawable(R.drawable.priority_low_unclicked)
        }
        todoUpdateAddLowButton.setOnClickListener {
            mTodo.priority = "Low"
            todoUpdateAddHighButton.background = resources.getDrawable(R.drawable.priority_high_unclicked)
            todoUpdateAddMediumButton.background = resources.getDrawable(R.drawable.priority_medium_unclicked)
            todoUpdateAddLowButton.background = resources.getDrawable(R.drawable.priority_low_clicked)
        }
        TodoUpdateAdd.setOnClickListener {
            var mTodo1 = ToDoModelFireBase()
            mTodo1.title = todoUpdateAddTitle.text.toString()
            mTodo1.datails = todoUpdateAddDetails.text.toString()
            mTodo1.startTime = mTodo.startTime
            mTodo1.startDate = mTodo.startDate
            mTodo1.endTime = mTodo.endTime
            mTodo1.endDate = mTodo.endDate
            mTodo1.priority = mTodo.priority
            mTodo1.status = mTodo.status

            mTodo1.id = mTodo.id

            dbReference!!.child("ToDo")
                .child(mAuth!!.currentUser!!.uid)
                .child(mTodo1.id).setValue(mTodo1)
            finish()
        }
    }
}
