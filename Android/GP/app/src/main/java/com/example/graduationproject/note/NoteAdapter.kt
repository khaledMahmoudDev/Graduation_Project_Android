package com.example.graduationproject.note

import android.content.Context
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.example.graduationproject.R
import com.example.graduationproject.model.NoteModel
import kotlinx.android.synthetic.main.note_row_item.view.*

class NoteAdapter(var notes : ArrayList<NoteModel>, val context: Context) :RecyclerView.Adapter<NoteAdapter.NoteViewHolder>(){
    var onItemClick: ((NoteModel) -> Unit)? = null
    override fun onCreateViewHolder(p0: ViewGroup, p1: Int): NoteViewHolder {
        return NoteViewHolder(LayoutInflater.from(context).inflate(R.layout.note_row_item,p0,false))
    }

    override fun getItemCount()= notes.size

    override fun onBindViewHolder(p0: NoteViewHolder, p1: Int) {
        p0.title.text =notes[p1].noteName
        p0.details.text = notes[p1].noteContent

    }


    inner class NoteViewHolder(v:View) : RecyclerView.ViewHolder(v)
    {
        private var view: View = v
        var title =view.row_note_title
        var details = view.row_note_note
        init {
            view.setOnClickListener{
                onItemClick?.invoke(notes[adapterPosition])
            }
        }

    }
}