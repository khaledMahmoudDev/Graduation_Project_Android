package com.example.graduationproject.toDo


import android.content.Intent
import android.os.Bundle
import android.support.v4.app.Fragment
import android.support.v7.widget.LinearLayoutManager
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup

import com.example.graduationproject.R
import com.example.graduationproject.model.ToDoModel
import com.example.graduationproject.model.ToDoModelFireBase
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.*
import kotlinx.android.synthetic.main.fragment_to_do_review.*

// TODO: Rename parameter arguments, choose names that match
// the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
private const val ARG_PARAM1 = "param1"
private const val ARG_PARAM2 = "param2"

/**
 * A simple [Fragment] subclass.
 *
 */
class ToDoReview : Fragment() {
    private var mAuth: FirebaseAuth? = null
    private var firebaseDataBase: FirebaseDatabase? = null
    private var dbReference: DatabaseReference? = null
    lateinit var todoAdapter: ToDoAdapterList
    lateinit var mTodos: ArrayList<ToDoModel>

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_to_do_review, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)



        floatingActionButtonInProgress.setOnClickListener {
            var i = Intent(context,AddToDo::class.java)
            startActivity(i)
        }
    }
    override fun onResume() {
        super.onResume()
        mAuth = FirebaseAuth.getInstance()
        firebaseDataBase = FirebaseDatabase.getInstance()
        dbReference = firebaseDataBase!!.getReference("ToDo").child(mAuth!!.currentUser!!.uid)
        dbReference!!.keepSynced(true)
        mTodos = ArrayList()


        todoAdapter = ToDoAdapterList(mTodos, context!!)
        toDoListInProgress.layoutManager = LinearLayoutManager(context)
        toDoListInProgress.adapter = todoAdapter

        todoAdapter.onItemClick= {
                toDoModel ->
            var i = Intent(context,ShowTodo::class.java)
            i.putExtra("clickedTodo",toDoModel)
            startActivity(i)
        }

        dbReference!!.addListenerForSingleValueEvent(object : ValueEventListener {
            override fun onCancelled(p0: DatabaseError) {
                TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
            }

            override fun onDataChange(p0: DataSnapshot) {
                mTodos.clear()
                for (n in p0.children) {
                    var nn = n.getValue(ToDoModelFireBase::class.java)
                    if (nn!!.status == "InProgress") {
                        mTodos.add(
                            ToDoModel(
                                nn.id
                                , nn.title
                                , nn.datails
                                , nn.startTime
                                , nn.startDate
                                , nn.endTime
                                , nn.endDate
                                , nn.priority
                                , nn.status
                            )
                        )
                    }
                }
                todoAdapter.notifyDataSetChanged()
            }
        })


    }



}
