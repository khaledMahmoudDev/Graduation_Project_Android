package com.example.graduationproject.email

import android.content.Intent
import android.net.Uri
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import com.example.graduationproject.R
import kotlinx.android.synthetic.main.activity_email.*

class Email : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_email)

        val actionBar = supportActionBar
        actionBar!!.title = "Email"
        actionBar.elevation = 4.0F

        var from = emailFrom.text.toString()
        var to = emailTo.text.toString()
        var subject = emailSubject.text.toString()
        var body = emailBody.text.toString()

        emailSend.setOnClickListener {

            var i = Intent(Intent.ACTION_SENDTO)
            i.data = Uri.parse("mailto:$to")
            i.putExtra(Intent.EXTRA_EMAIL, from)
            i.putExtra(Intent.EXTRA_SUBJECT,subject)
            i.putExtra(Intent.EXTRA_TEXT,body)
            startActivity(Intent.createChooser(i, "Choose your preferred email"))

        }
    }
}
