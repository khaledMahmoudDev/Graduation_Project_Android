package com.example.graduationproject.toDo

import android.content.Context
import android.os.Build
import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import com.example.graduationproject.R
import com.example.graduationproject.model.ToDoModel
import kotlinx.android.synthetic.main.todo_row_item.view.*

class ToDoAdapterList(var mTodos : ArrayList<ToDoModel>, val context: Context) :RecyclerView.Adapter<ToDoAdapterList.ToDoViewHolder>() {
    var onItemClick: ((ToDoModel) -> Unit)? = null
    override fun onCreateViewHolder(p0: ViewGroup, p1: Int): ToDoViewHolder {
        return ToDoViewHolder(LayoutInflater.from(context).inflate(R.layout.todo_row_item,p0,false))
    }

    override fun getItemCount() = mTodos.size

    override fun onBindViewHolder(p0: ToDoViewHolder, p1: Int) {
        p0.title.text = mTodos[p1].title
        p0.endTime.text = mTodos[p1].endTime
        p0.startTime.text = mTodos[p1].startTime
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            if (mTodos[p1].priority == "High")
            {
                p0.backGround.background = context.getDrawable(R.color.priority_high)
            }else if (mTodos[p1].priority == "Medium")
            {
                p0.backGround.background = context.getDrawable(R.color.priority_medium)
            }else if(mTodos[p1].priority == "Low")
            {
                p0.backGround.background = context.getDrawable(R.color.priority_low)
            }

        }
    }

    inner class ToDoViewHolder(v: View) : RecyclerView.ViewHolder(v)
    {
        private var view: View = v
        var title =view.todo_row_item_title
        var startTime =view.todo_row_item_start_time
        var endTime =view.todo_row_item_end_time
        var backGround = view.LinearBackGround

        init {
            view.setOnClickListener{
                onItemClick?.invoke(mTodos[adapterPosition])
            }
        }

    }
}