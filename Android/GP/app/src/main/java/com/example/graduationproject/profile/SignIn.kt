package com.example.graduationproject.profile

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import android.widget.Toast
import com.example.graduationproject.R
import com.example.graduationproject.mainPac.MainActivity
import com.google.android.gms.tasks.OnCompleteListener
import com.google.android.gms.tasks.Task
import com.google.firebase.auth.AuthResult
import com.google.firebase.auth.FirebaseAuth
import kotlinx.android.synthetic.main.activity_sign_in.*
import kotlinx.android.synthetic.main.activity_signup.*

class SignIn : AppCompatActivity() {

    var mAuth : FirebaseAuth? = null


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_sign_in)


        mAuth = FirebaseAuth.getInstance()

        btn_login.setOnClickListener { login() }

        btn_register_account.setOnClickListener {startActivity(Intent(this,Signup::class.java)) }


    }

    fun verifyEmail()
    {
        val user = mAuth?.currentUser
        if (user!!.isEmailVerified)
        {
            startActivity(Intent(this,MainActivity::class.java))
            finish()

        }
        else{
            Toast.makeText(applicationContext,"please verify your email",Toast.LENGTH_SHORT).show()
        }
    }

    fun login()
    {
        if (logInEmail1.text.toString().isNotEmpty()&&logInPassword.text.toString().isNotEmpty())
        {
            progressBar2.visibility = View.VISIBLE
            mAuth?.signInWithEmailAndPassword(logInEmail1.text.toString(),logInPassword.text.toString())
                ?.addOnCompleteListener {
                    progressBar2.visibility = View.INVISIBLE

                    if (it.isSuccessful)
                    {
                        verifyEmail()

                    }else
                    {
                        Toast.makeText(applicationContext,"failed ${it.exception}", Toast.LENGTH_SHORT).show()
                    }

                }

        }else
        {
            Toast.makeText(this,"email or password is empty",Toast.LENGTH_SHORT).show()
        }

    }


}
