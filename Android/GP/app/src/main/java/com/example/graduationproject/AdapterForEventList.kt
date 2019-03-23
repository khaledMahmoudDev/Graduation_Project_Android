package com.example.graduationproject

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import com.example.graduationproject.model.Event
import kotlinx.android.synthetic.main.row_event_list.view.*

class AdapterForEventList(context: Context, events: ArrayList<Event>) : ArrayAdapter<Event>(context,0,events){


    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {

        val view = LayoutInflater.from(context).inflate(R.layout.row_event_list, parent,false)


        val mEvent = getItem(position)

        view.row_item_start_time.text = mEvent.startTime
        view.row_item_end_time.text = mEvent.endTime
        view.row_item_title.text = mEvent.title


        return view
    }

}