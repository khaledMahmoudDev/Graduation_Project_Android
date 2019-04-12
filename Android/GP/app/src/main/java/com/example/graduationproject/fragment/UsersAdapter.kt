package com.example.graduationproject.fragment

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ArrayAdapter
import com.bumptech.glide.Glide
import com.example.graduationproject.R
import com.example.graduationproject.model.User
import kotlinx.android.synthetic.main.row_event_list.view.*
import kotlinx.android.synthetic.main.users_row.view.*

class UsersAdapter (context: Context,usersList : ArrayList<User>) :ArrayAdapter<User>(context,0,usersList) {


    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {


        val view = LayoutInflater.from(context).inflate(R.layout.users_row, parent,false)


        val mUsers = getItem(position)
        view.usersRowName.text = mUsers.firstName
        Glide.with(context).load(mUsers.imageLink).into(view.usersRowImage)
        return view
    }
}