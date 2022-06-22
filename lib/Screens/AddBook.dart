import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Classes/Book.dart';
import '../Validation/BookValidator.dart';

class addBook extends StatefulWidget {
  int lid;
  addBook(this.lid);
  @override
  State<StatefulWidget> createState() {
    return _addStudentState(lid);
  }
}

class _addStudentState extends State with BookValidationMixin {
var db = FirebaseFirestore.instance;
  int lid;
  _addStudentState(this.lid);
  var book = Book.zero();
  var formKey = GlobalKey<FormState>();

  initState(){


  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Add Book"),
        ),
        body: Container(
          margin: EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                BuildTextFormName(),
                BuildTextFormAuthor(),
                BuildTextFormTopic(),
                BuildTextFormPageNumber(),
                BuildSendButton()
              ],
            ),
          ),
        ));
  }

  Widget BuildTextFormName() {
    return TextFormField(
      decoration:
      InputDecoration(labelText: "Book Name", hintText: "Name here.."),
      validator: validateBookName,
      onSaved: (String? value) {
        book.name = value!;
      },//controller: txtName,

    );
  }

  Widget BuildTextFormAuthor() {
    return TextFormField(
      decoration:
      InputDecoration(labelText: "Author Name", hintText: "Author here.."),
      validator: validateAuthorName,
      onSaved: (String? value) {
        book.author = value!;
      }

     ,// controller: txtAuthor,
    );
  }

  Widget BuildTextFormTopic() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Topic", hintText: "Topic here.."),
      validator: validateTopic,
      onSaved: (String? value) {
        book.topic = value!;
      }
      ,// controller: txtTopic,
    );
  }

  Widget BuildTextFormPageNumber() {
    return TextFormField(
      initialValue: 0.toString(),
      decoration:
      InputDecoration(labelText: "Page Number", hintText: "Number here.."),
      validator: validatePageNumber,
      onSaved: (String? value) {
        book.pageNumber = int.parse(value!);
      }
      ,// controller: txtPage,
    );
  }

  Widget BuildSendButton() {
    return ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            book.id = lid;
            insertBook(book);
          }

        },
        child: Text("Save"));
  }
  void insertBook(Book book)  {
    Map<String,dynamic> addBook() {
      return {
        'id': book.id,
        'name': book.name,
        'author': book.author,
        'topic': book.topic,
        'pageNumber': book.pageNumber,
      };
    }
    addBook();
    db.collection("books")
        .doc(book.id.toString())
        .set(addBook());
    Navigator.pop(context);

  }
}
