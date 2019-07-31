package com.example.graduationproject.note

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.widget.GridLayoutManager
import android.support.v7.widget.LinearLayoutManager
import com.example.graduationproject.R
import com.example.graduationproject.model.NoteModel
import com.example.graduationproject.model.NoteModelFireBase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.*
import kotlinx.android.synthetic.main.activity_note.*

class Note : AppCompatActivity() {
    private var mAuth : FirebaseAuth? = null
    private var firebaseDataBase : FirebaseDatabase? = null
    private var dbReference : DatabaseReference? = null
    lateinit var noteAdapter : NoteAdapter
    lateinit var notes : ArrayList<NoteModel>

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_note)
        val actionBar = supportActionBar
        actionBar!!.title = "Notes"
        actionBar.elevation = 4.0F
        addnotefab.setOnClickListener {
            startActivity(Intent(this,AddNote::class.java))
        }

        mAuth = FirebaseAuth.getInstance()
        firebaseDataBase = FirebaseDatabase.getInstance()
        dbReference = firebaseDataBase!!.getReference("UserNotes").child(mAuth!!.currentUser!!.uid)
        dbReference!!.keepSynced(true)
        notes = ArrayList()
        noteAdapter = NoteAdapter(notes,applicationContext)
        noteRecyclerView.layoutManager = LinearLayoutManager(applicationContext)
        noteRecyclerView.adapter = noteAdapter

        noteAdapter.onItemClick =
            {
                noteModel ->
                var i : Intent = Intent(this,EditNote::class.java)
                i.putExtra("clickedNote",noteModel)
                startActivity(i)
            }
        dbReference!!.addListenerForSingleValueEvent(object : ValueEventListener{
            override fun onCancelled(p0: DatabaseError) {
                TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
            }

            override fun onDataChange(p0: DataSnapshot) {
                notes.clear()
                for (n in p0.children)
                {
                    var nn = n.getValue(NoteModelFireBase::class.java)
                    notes.add(NoteModel(nn!!.noteId,
                        nn.noteName,
                        nn.noteContent))
                }
                noteAdapter.notifyDataSetChanged()

            }
        } )
        dbReference!!.addValueEventListener(object : ValueEventListener{
            override fun onCancelled(p0: DatabaseError) {
                TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
            }

            override fun onDataChange(p0: DataSnapshot) {
                notes.clear()
                for (n in p0.children)
                {
                    var nn = n.getValue(NoteModelFireBase::class.java)
                    notes.add(NoteModel(nn!!.noteId,
                        nn.noteName,
                        nn.noteContent))
                }
                noteAdapter.notifyDataSetChanged()

            }
        } )






    }
}
