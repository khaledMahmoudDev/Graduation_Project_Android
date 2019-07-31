package com.example.graduationproject.note

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import com.example.graduationproject.R
import com.example.graduationproject.model.NoteModelFireBase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import kotlinx.android.synthetic.main.activity_add_note.*


class AddNote : AppCompatActivity() {
    private var mAuth : FirebaseAuth? = null
    private var firebaseDataBase : FirebaseDatabase? = null
    private var dbReference : DatabaseReference? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_add_note)

        val actionBar = supportActionBar
        actionBar!!.title = "Add Note"
        actionBar.elevation = 4.0F


        mAuth = FirebaseAuth.getInstance()
        firebaseDataBase = FirebaseDatabase.getInstance()
        dbReference = firebaseDataBase!!.reference
        dbReference!!.keepSynced(true)



        addNoteButton.setOnClickListener {
            var note = NoteModelFireBase()
            note.noteName =addNoteTitle.text.toString()
            note.noteContent = addNoteDetails.text.toString()
            note.noteId = dbReference!!.child("UserNotes")
                .child(mAuth!!.currentUser!!.uid.toString())
                .push().key.toString()

            dbReference!!.child("UserNotes")
                .child(mAuth!!.currentUser!!.uid.toString())
                .child(note.noteId).setValue(note)
            finish()
        }
    }
}
