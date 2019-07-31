package com.example.graduationproject.toDo

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.app.AlertDialog
import android.view.Menu
import android.view.MenuInflater
import android.view.MenuItem
import android.widget.Toast
import com.example.graduationproject.R
import com.example.graduationproject.model.ToDoModel
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import kotlinx.android.synthetic.main.activity_show_todo.*

class ShowTodo : AppCompatActivity() {

    lateinit var mTodo : ToDoModel
    private var mAuth : FirebaseAuth? = null
    private var firebaseDataBase : FirebaseDatabase? = null
    private var dbReference : DatabaseReference? = null


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_show_todo)
        mAuth = FirebaseAuth.getInstance()
        firebaseDataBase = FirebaseDatabase.getInstance()
        dbReference = firebaseDataBase!!.reference
        dbReference!!.keepSynced(true)
        val actionBar = supportActionBar
        actionBar!!.title = "Show Todo"
        actionBar.elevation = 4.0F



        mTodo = intent.getParcelableExtra("clickedTodo")

        todoShowStartAt.append(" ${mTodo.startDate} at ${mTodo.startTime}")
        todoShowEndAt.append(" ${mTodo.endDate} at ${mTodo.endTime}")
        todoShowTitle.text = mTodo.title
        todoShowPriority.append(mTodo.priority)
        todoShowDetails.append(mTodo.datails)
        todoShowStatus.append(mTodo.status)
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

                    val intent = Intent(this, UpdateToDo::class.java)
                    intent.putExtra("clickedTodoTobeUpdated",mTodo)
                    startActivity(intent)
                    finish()
                true
            }
            R.id.Delete_menu_button ->
            {
                val builder = AlertDialog.Builder(this)
                builder.setMessage("Are you want to delete this ToDo?")

                builder.setPositiveButton("YES"){dialog, which ->
                    dbReference!!.child("ToDo")
                        .child(mAuth!!.currentUser!!.uid)
                        .child(mTodo.id).removeValue()

                    Toast.makeText(this,"ToDo was deleted", Toast.LENGTH_LONG).show()
                    finish()
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
