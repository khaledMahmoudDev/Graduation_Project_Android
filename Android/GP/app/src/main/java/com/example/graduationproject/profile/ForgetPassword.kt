package com.example.graduationproject.profile

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Toast
import kotlinx.android.synthetic.main.activity_forget_password.*
import com.google.firebase.auth.FirebaseAuth



class ForgetPassword : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(com.example.graduationproject.R.layout.activity_forget_password)

        val actionBar = supportActionBar
        actionBar!!.title = "Forget Password"
        actionBar.elevation = 4.0F
        SendResetEmail.setOnClickListener {
            if(editTextResetmail.text.toString().isNotEmpty())
            {
                FirebaseAuth.getInstance().sendPasswordResetEmail(editTextResetmail.text.toString())
                    .addOnCompleteListener { task ->
                        if (task.isSuccessful) {
                            Toast.makeText(applicationContext,"Reset Password Email was Sent to you",Toast.LENGTH_LONG).show()
                            finish()
                        }else
                        {
                            Toast.makeText(applicationContext,"Please enter valid email",Toast.LENGTH_LONG).show()
                        }
                    }
            }
        }
    }
}
