package com.example.graduationproject.fragment


import android.content.Intent
import android.os.Bundle
import android.support.v4.app.Fragment
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.TextView
import android.widget.Toast
import com.bumptech.glide.Glide
import com.example.graduationproject.AdapterForEventList
import com.example.graduationproject.R
import com.example.graduationproject.calender.CalendarView
import com.example.graduationproject.model.Event
import com.example.graduationproject.model.EventFireBase
import com.example.graduationproject.model.WeatherModel
import com.example.graduationproject.weather.WeatherResponse
import com.example.graduationproject.weather.WeatherService
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.*
import kotlinx.android.synthetic.main.activity_calender.*
import kotlinx.android.synthetic.main.activity_calender.CalendarList
import kotlinx.android.synthetic.main.activity_calender.floatingActionButton
import kotlinx.android.synthetic.main.activity_calender.mCalendar
import kotlinx.android.synthetic.main.activity_profile.*
import kotlinx.android.synthetic.main.fragment_calender2.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList

// TODO: Rename parameter arguments, choose names that match
// the fragment initialization parameters, e.g. ARG_ITEM_NUMBER
private const val ARG_PARAM1 = "param1"
private const val ARG_PARAM2 = "param2"

/**
 * A simple [Fragment] subclass.
 *
 */
class CalenderFragment : Fragment() {
          var mDateOfTheDay :String? = null
           lateinit var adapterForEventList : AdapterForEventList
         private var mAuth : FirebaseAuth? = null
         private var firebaseDataBase : FirebaseDatabase? = null
         private var dbReference : DatabaseReference? = null

          override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
         ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_calender2, container, false)
      }

    override fun onResume() {
          super.onResume()
           val now = Calendar.getInstance()
          var year = now.get(Calendar.YEAR)
          var month = now.get(Calendar.MONTH)
           var day = now.get(Calendar.DAY_OF_MONTH)
        initWeather()




        var list1 = ArrayList<Event>()
           var DateOfTheDay = "$month $day $year"
           val sdf = SimpleDateFormat("MM dd yyyy", Locale.ENGLISH)
           val parsedDate = sdf.parse(DateOfTheDay)
           val date1 = SimpleDateFormat("MMM dd, yyyy")
            var getDate = date1.format(parsedDate)

          dbReference!!.addListenerForSingleValueEvent(object : ValueEventListener{
            override fun onCancelled(p0: DatabaseError) {
            }
            override fun onDataChange(p0: DataSnapshot) {
                for (n in p0.children) {
                    var ev = n.getValue(EventFireBase::class.java)
                    var mEv = Event()
                    mEv.title = ev!!.mTitle
                    mEv.mDate = ev.mDate
                    mEv.startTime = ev.mStartTime
                    mEv.endTime = ev.mEndTime
                    mEv.details = ev.mDetails
                    mEv.eventCreator = ev.mEventCreator
                    mEv.id = ev.id
                    mEv.privacy = ev.privacy
                    mEv.location = ev.location
                    mEv.startDate = ev.startDate
                    mEv.endDate = ev.endDate

                    if(mEv.eventCreator == mAuth!!.currentUser!!.email.toString())
                    {
                        if (mEv.mDate == getDate )
                        {
                            list1.add(mEv)
                        }
                    }
                }
                if (list1.size == 0)
                {
                    CalendarList.visibility = View.INVISIBLE
                }else{
                    adapterForEventList = AdapterForEventList(context!!,list1)
                    CalendarList.adapter = adapterForEventList
                    CalendarList.visibility = View.VISIBLE
                }
            }
             })



             CalendarList.onItemClickListener =
            AdapterView.OnItemClickListener { p0, p1, p2, p3 ->
                var eve = list1.get(p2)
                val intent = Intent(context, CalendarView::class.java)
                intent.putExtra("clickedEvent",eve)
                startActivity(intent)
            }


             mCalendar.setOnDateChangeListener { view, year, month, dayOfMonth ->
                 mDateOfTheDay = "$month $dayOfMonth $year"


                 ////////////
                 val sdf = SimpleDateFormat("MM dd yyyy", Locale.ENGLISH)
                 val parsedDate = sdf.parse(mDateOfTheDay)
                 val date1 = SimpleDateFormat("MMM dd, yyyy")
                 var LDate = date1.format(parsedDate)

                 list1.clear()
                 dbReference!!.addListenerForSingleValueEvent(object : ValueEventListener {
                     override fun onCancelled(p0: DatabaseError) {}
                     override fun onDataChange(p0: DataSnapshot) {
                         for (n in p0.children) {
                             var ev = n.getValue(EventFireBase::class.java)
                             var mEv = Event()
                             mEv.title = ev!!.mTitle
                             mEv.mDate = ev.mDate
                             mEv.startTime = ev.mStartTime
                             mEv.endTime = ev.mEndTime
                             mEv.details = ev.mDetails
                             mEv.eventCreator = ev.mEventCreator
                             mEv.id = ev.id
                             mEv.privacy = ev.privacy
                             mEv.location = ev.location
                             mEv.startDate = ev.startDate
                             mEv.endDate = ev.endDate
                             if (mEv.eventCreator == mAuth!!.currentUser!!.email.toString()) {
                                 if (mEv.mDate == LDate) { list1.add(mEv) } } }
                         if (list1.size == 0) { CalendarList.visibility = View.INVISIBLE }
                         else {
                             adapterForEventList = AdapterForEventList(context!!, list1)
                             CalendarList.adapter = adapterForEventList
                             CalendarList.visibility = View.VISIBLE
                         }
                     }
                 })
             }
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

/////////////////////////////
        mAuth = FirebaseAuth.getInstance()
        firebaseDataBase = FirebaseDatabase.getInstance()
        dbReference = firebaseDataBase!!.getReference("Events")
        dbReference!!.keepSynced(true)


        val now = Calendar.getInstance()
        var year = now.get(Calendar.YEAR)
        var month = now.get(Calendar.MONTH)
        var day = now.get(Calendar.DAY_OF_MONTH)
        mDateOfTheDay = "$month $day $year"


        floatingActionButton.setOnClickListener {
            var i = Intent("com.gb.action.addEvent")
            i.putExtra("dateOfTheDay",mDateOfTheDay)
            startActivity(i)
        }
    }
    fun initWeather()
    {
        var BaseUrl = "http://api.openweathermap.org/"
        var AppId = "fdc8115c1fce92ca4bceb4eab91185fb"
        var lat = "30"
        var lon = "32"
        val retrofit = Retrofit.Builder()
            .baseUrl(BaseUrl)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
        val service = retrofit.create(WeatherService::class.java)
        val call = service.getCurrentWeatherData(lat, lon, AppId)


        call.enqueue(object : Callback<WeatherModel> {
            override fun onResponse(call: Call<WeatherModel>, response: Response<WeatherModel>) {
                if (response.code() == 200) {
                    val weatherResponse = response.body()!!


                    var mainTemp1 = weatherResponse.weather[0].main
                    var desc = weatherResponse.weather[0].description
                    var maxTemp = weatherResponse.main.temp_max - 273
                    var minTemp = weatherResponse.main.temp_min - 273


                    var icoq = "http://openweathermap.org/img/w/" + weatherResponse.weather[0].icon+ ".png"

                    Glide.with(context).load(icoq).into(ico)
                    mainTemp.text = mainTemp1
                    temp1.text = desc
                    hum1.text = "${maxTemp.toInt()} C"
                    press1.text = "${minTemp.toInt()} C"

                }
            }

            override fun onFailure(call: Call<WeatherModel>, t: Throwable) {

            }
        })


    }

}
