package com.example.graduationproject.toDo

import android.support.v4.app.Fragment
import android.support.v4.app.FragmentManager
import android.support.v4.app.FragmentPagerAdapter

class ToDoAdapter(fm: FragmentManager?) : FragmentPagerAdapter(fm) {
    override fun getItem(p0: Int): Fragment {
        var mFragment : Fragment? = null

        when(p0)
        {
            0 -> mFragment = ToDoList()
            1 -> mFragment = ToDoReview()
            2 -> mFragment = ToDoDone()
        }
        return mFragment!!

    }

    override fun getCount(): Int {
        return 3
    }

    override fun getPageTitle(position: Int): CharSequence? {
        var title:String?  = null
        when(position)
        {
            0 -> title = "ToDo"
            1 -> title = "Review"
            2 -> title = "Done"
        }
        return title
    }
}