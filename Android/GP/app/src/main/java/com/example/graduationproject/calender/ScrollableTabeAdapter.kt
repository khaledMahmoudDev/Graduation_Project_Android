package com.example.graduationproject.calender

import android.content.Context
import android.content.res.Resources
import android.graphics.drawable.Drawable
import android.support.v4.app.Fragment
import android.support.v4.app.FragmentManager
import android.support.v4.app.FragmentPagerAdapter
import android.text.SpannableStringBuilder
import android.text.Spanned
import android.text.style.DynamicDrawableSpan
import android.text.style.ImageSpan
import com.example.graduationproject.R
import com.example.graduationproject.fragment.BrowseEventFragment
import com.example.graduationproject.fragment.CalenderFragment
import com.example.graduationproject.fragment.UsersView

class ScrollableTabeAdapter (fm: FragmentManager?, val context: Context) : FragmentPagerAdapter(fm) {

    override fun getItem(p0: Int): Fragment? {


        var mFragment: Fragment? = null

        when(p0)
        {
            0 -> mFragment = CalenderFragment()
            1 -> mFragment = BrowseEventFragment()
            2 -> mFragment = UsersView()
        }
        return mFragment
    }

    override fun getCount(): Int {
        return 3
    }


    var drawable : Drawable? = null
    var title : String? = null
    override fun getPageTitle(position: Int): CharSequence? {

        when(position)
        {
            0 ->{
                drawable = context.resources.getDrawable(R.drawable.ic_home_black_24dp)
                title = "Home"
            }
            1 -> {
                drawable = context.resources.getDrawable(R.drawable.ic_event_black_24dp)
                title = "Events"
            }
            2 -> {
                drawable = context.resources.getDrawable(R.drawable.users)
                title = "Users"}

        }

        var sp : SpannableStringBuilder = SpannableStringBuilder(" $title")
        drawable?.setBounds(5,5, drawable!!.intrinsicHeight,drawable!!.intrinsicWidth)
        var imgSpan : ImageSpan = ImageSpan(drawable!!,DynamicDrawableSpan.ALIGN_BASELINE)
        sp.setSpan(imgSpan,0,1,Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)

        return sp
    }




}