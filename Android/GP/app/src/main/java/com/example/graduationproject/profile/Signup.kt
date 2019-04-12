package com.example.graduationproject.profile

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.BitmapDrawable
import android.net.Uri
import android.os.Build
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.provider.MediaStore
import android.support.v4.app.ActivityCompat
import android.view.View
import android.widget.Toast
import com.example.graduationproject.R
import com.example.graduationproject.model.User
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.storage.FirebaseStorage
import com.google.firebase.storage.StorageReference
import kotlinx.android.synthetic.main.activity_signup.*
import java.io.ByteArrayOutputStream
import java.text.SimpleDateFormat
import java.util.*

class Signup : AppCompatActivity() {
    var auth : FirebaseAuth? = null
    private var database1:FirebaseDatabase?= null
    private var myref:DatabaseReference? = null
    private var storage : FirebaseStorage? = null
    private var storageRef : StorageReference? = null
    var imageUri:Uri ? = null
    var imageLink1 : String? = null



    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_signup)

        auth = FirebaseAuth.getInstance()
        database1 = FirebaseDatabase.getInstance()
        storage = FirebaseStorage.getInstance()
        myref = database1!!.reference
        storageRef = storage!!.reference

        


        btn_register.setOnClickListener {signUpNow()}
        accountImage.setOnClickListener { checkPermissions() }

    }

    var READ_IMAGE  = 22
    fun checkPermissions()
    {
        if (Build.VERSION.SDK_INT >= 23)
        {
            if (ActivityCompat.checkSelfPermission(this, android.Manifest.permission.READ_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED)
            {
                requestPermissions(arrayOf(android.Manifest.permission.READ_EXTERNAL_STORAGE),READ_IMAGE)
                return
            }

        }
        loadImage()
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        when(requestCode)
        {
            READ_IMAGE -> {
                if (grantResults[0] == PackageManager.PERMISSION_GRANTED)
                {
                    loadImage()
                }else
                {
                    Toast.makeText(this,"can not access images", Toast.LENGTH_SHORT).show()
                }
            }
        }
    }


    val PICK_IMAGE_CODE = 11

    private fun loadImage() {
        var i = Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI)
        startActivityForResult(i, PICK_IMAGE_CODE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == PICK_IMAGE_CODE && resultCode == Activity.RESULT_OK && data!= null)
        {
            val selectedImage = data.data
            imageUri = selectedImage

            val filepath = arrayOf(MediaStore.Images.Media.DATA)
            val cursor = contentResolver.query(selectedImage,filepath,null,null,null)
            cursor.moveToFirst()
            val coulomEindex = cursor.getColumnIndex(filepath[0])
            val picturePath = cursor.getString(coulomEindex)
            cursor.close()
            accountImage.setImageBitmap(BitmapFactory.decodeFile(picturePath))



        }
    }


    fun saveImage2()
    {
        val filePath = storageRef?.child("profileImages/"+Calendar.getInstance().time.toString())
        if (imageUri != null)
        {
            filePath?.putFile(imageUri!!)?.addOnSuccessListener (){
                taskSnapshot ->
                filePath.downloadUrl.addOnCompleteListener(){
                    task ->
                    imageLink1 = task.result.toString()
                    myref!!.child("USERS").child(auth!!.currentUser!!.uid).child("imageLink").setValue(imageLink1)
                    Toast.makeText(applicationContext,"image uploaded", Toast.LENGTH_SHORT).show()


                }
            }!!.addOnFailureListener{
               Toast.makeText(applicationContext,"failure form on failure",Toast.LENGTH_SHORT).show()
            }

        }else{
            Toast.makeText(applicationContext,"image is null", Toast.LENGTH_SHORT).show()
        }




    }
//    fun saveimage()
//    {
//        var currentUser = auth?.currentUser
//        val storage = FirebaseStorage.getInstance()
//        val email2 = currentUser?.email?.toString()
//        val storageRef = storage.getReferenceFromUrl("gs://ajenda-a702f.appspot.com")
//        val df = SimpleDateFormat("ddMMyyHHss")
//        val dataObj = Date()
//        val imagepath = email2+df.format(dataObj)+".jpg"
//        val imageRef = storageRef.child("profileImages/$imagepath")
//        accountImage.isDrawingCacheEnabled = true
//        accountImage.buildDrawingCache()
//        val img = accountImage.drawable as BitmapDrawable
//        val bitmap = img.bitmap
//        val baos = ByteArrayOutputStream()
//        bitmap.compress(Bitmap.CompressFormat.JPEG,100,baos)
//        val data = baos.toByteArray()
//        val uploadTask = imageRef.putBytes(data).addOnFailureListener {  }.addOnSuccessListener (){
//            taskSnapshot ->
//            imageRef.downloadUrl.addOnCompleteListener (){
//                task ->
//                val downUrl = task.result.toString()
//                Toast.makeText(applicationContext,"url is $downUrl", Toast.LENGTH_SHORT).show()
//
//                with(myref) {
//                    child("Users").run {
//                        child(currentUser!!.uid).child("email").setValue(currentUser.email)
//                        child(currentUser.uid).child("profileImage").setValue(downUrl)
//                    }
//                }
//
//            }
//        }
//    }
    fun signUpNow()
    {
        if (editEmail1.text.toString().isNotEmpty() && EditPassword1.text.toString().isNotEmpty())
        {
            progressBar.visibility = View.VISIBLE

            auth?.createUserWithEmailAndPassword(editEmail1.text.toString(),EditPassword1.text.toString())
                ?.addOnCompleteListener {

                    progressBar.visibility = View.INVISIBLE

                    if (it.isSuccessful)
                    {
                        var uId = auth!!.currentUser!!.uid
                        var usr = User()
                        usr.email = auth!!.currentUser!!.email
                        usr.firstName = et_first_name.text.toString()
                        usr.imageLink = imageLink1
                        usr.userId = uId

                        myref!!.child("USERS").child(uId).setValue(usr)




//                        myref!!.child("USERS").child(auth!!.currentUser!!.uid).child("email").setValue(auth!!.currentUser!!.email)
//                        myref!!.child("USERS").child(auth!!.currentUser!!.uid).child("userName").setValue(et_first_name.text.toString())
                        //myref!!.child("USERS").child(auth!!.currentUser!!.uid).child("Id").setValue(auth!!.currentUser!!.uid)


//                        myref!!.child("Events").push().child("em").setValue("no way")
//                        myref!!.child("Events").push().child("em").setValue("no way")
//                        myref!!.child("Events").push().child("em").setValue("no way")
//                        myref!!.child("Events").push().child("em").setValue("no way")
                        saveImage2()
                        sendEmailVerification()

                    }else
                    {
                        Toast.makeText(applicationContext,"failed ${it.exception}", Toast.LENGTH_SHORT).show()
                    }

                }
        }else
        {
            Toast.makeText(applicationContext,"email or password is empty",Toast.LENGTH_SHORT).show()
        }
    }

    fun sendEmailVerification()
    {
        val user = auth!!.currentUser
        user!!.sendEmailVerification().addOnCompleteListener {
            if(it.isSuccessful)
            {

                Toast.makeText(applicationContext,"verification email was send ... pleas check your email",Toast.LENGTH_SHORT).show()
                startActivity(Intent(applicationContext,SignIn::class.java))
                finish()
            }else
            {
                Toast.makeText(applicationContext,"failed to verify this email",Toast.LENGTH_SHORT).show()

            }
        }
    }
}
