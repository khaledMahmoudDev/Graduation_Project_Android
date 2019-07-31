package com.example.graduationproject.model

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize

@Parcelize
class NoteModel(
    var noteId:String = "",
    var noteName : String = "",
    var noteContent : String = ""): Parcelable {
}