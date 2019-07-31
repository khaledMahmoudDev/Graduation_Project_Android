package com.example.graduationproject.note

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.app.AlertDialog
import android.view.Menu
import android.view.MenuInflater
import android.view.MenuItem
import android.widget.Toast
import com.example.graduationproject.R
import com.example.graduationproject.calender.UpdateThisEvent
import com.example.graduationproject.model.NoteModel
import com.example.graduationproject.model.NoteModelFireBase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import kotlinx.android.synthetic.main.activity_edit_note.*

class EditNote : AppCompatActivity() {
    private var mAuth : FirebaseAuth? = null
    private var firebaseDataBase : FirebaseDatabase? = null
    private var dbReference : DatabaseReference? = null
    lateinit var note : NoteModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_edit_note)

        val actionBar = supportActionBar
        actionBar!!.title = "Show Note"
        actionBar.elevation = 4.0F
        val data = intent.extras
        note=data.getParcelable("clickedNote")
        EditNoteTitle.append(note.noteName)
        EditNoteDetails.append(note.noteContent)

        mAuth = FirebaseAuth.getInstance()
        firebaseDataBase = FirebaseDatabase.getInstance()
        dbReference = firebaseDataBase!!.reference
        dbReference!!.keepSynced(true)

        EditNoteButton.setOnClickListener {
            var newNote = NoteModelFireBase()
            newNote.noteId = note.noteId
            newNote.noteName = EditNoteTitle.text.toString()
            newNote.noteContent = EditNoteDetails.text.toString()
            var childRef = dbReference!!.child("UserNotes").
                child(mAuth!!.currentUser!!.uid).child(note.noteId)
            childRef.setValue(newNote)
            finish()

        }
       }
    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        val inflater: MenuInflater = menuInflater
        inflater.inflate(R.menu.delete_menu, menu)
        return true
    }
    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        // Handle item selection
        return when (item.itemId) {
            R.id.Delete_menu_button1 ->
            {
                val builder = AlertDialog.Builder(this)
                builder.setMessage("Are you want to delete this note?")

                builder.setPositiveButton("YES"){dialog, which ->
                    dbReference!!.child("UserNotes")
                        .child(mAuth!!.currentUser!!.uid.toString())
                        .child(note.noteId).removeValue()
                    Toast.makeText(this,"Note was deleted", Toast.LENGTH_LONG).show()
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
