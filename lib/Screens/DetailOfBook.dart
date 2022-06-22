import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Classes/Book.dart';
import 'UpdateBook.dart';

class detailBook extends StatefulWidget{
  @override
    late Book book;
    detailBook(this.book);
    @override
    State<StatefulWidget> createState() {
      return _detailBook(book);
    }
}

class _detailBook extends State{
  late Book book;
  _detailBook(this.book);
  var db = FirebaseFirestore.instance;
  var txtName = TextEditingController();
  var txtAuthor = TextEditingController();
  var txtTopic = TextEditingController();
  var txtPage = TextEditingController();

  initState(){
    txtName.text = book.name;
    txtAuthor.text = book.author;
    txtTopic.text = book.topic;
    txtPage.text = book.pageNumber.toString();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Detail of  '${book.name}'",textScaleFactor: 0.8),
          actions: [
            IconButton(onPressed: onUpdate, icon: Icon(Icons.wifi_protected_setup_rounded,color: Colors.white,)),
            IconButton(onPressed: onDelete, icon: Icon(Icons.delete_forever,color: Colors.white))

          ],

    ),
    body: Container(
    margin: EdgeInsets.all(10.0),
    child: Form(
    child: Column(
    children: [
      Flexible(child:Container(
            child: Image.asset("lib/images/book.jpeg"),),
          fit: FlexFit.tight,flex:4),
      Flexible(child:BuildTextFormName(),fit: FlexFit.tight,flex:1),
      Flexible(child:BuildTextFormAuthor(),fit: FlexFit.tight,flex:1),
      Flexible(child:BuildTextFormTopic(),fit: FlexFit.tight,flex:1),
      Flexible(child:BuildTextFormPageNumber(),fit: FlexFit.tight,flex:1),

    ],
    ),
    ),
    ));
  }
  Widget BuildTextFormName() {
    return TextFormField(
       // initialValue: book.name,
      controller: txtName,
      decoration:
      InputDecoration(prefixIcon: Icon(Icons.book),labelText: "Book Name",border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue))),
    readOnly: true,

    );
  }

  Widget BuildTextFormAuthor() {
    return TextFormField(
        //initialValue: book.author,
        controller: txtAuthor,
      decoration:
      InputDecoration(prefixIcon: Icon(Icons.person),labelText: "Author Name",border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue))),
    readOnly: true,
    );
  }

  Widget BuildTextFormTopic() {
    return TextFormField(
       // initialValue: book.topic,
        controller: txtTopic,
      decoration: InputDecoration(prefixIcon: Icon(Icons.topic),labelText: "Topic",border: OutlineInputBorder(borderSide: BorderSide(color: Colors.indigo))),
    readOnly: true,
    );
  }

  Widget BuildTextFormPageNumber() {
    return TextFormField(
     // initialValue: book.pageNumber.toString(),
      controller: txtPage,
      decoration:
      InputDecoration(prefixIcon: Icon(Icons.pages_outlined),labelText: "Page Number",border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue))),
      readOnly: true,

    );
  }

  void onUpdate() async {
     Book result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => updateBook(book)));

     setState((){
       txtName.text = result.name;
       txtAuthor.text = result.author;
       txtTopic.text = result.topic;
       txtPage.text = result.pageNumber.toString();

     });

  }

  void onDelete() async {
    db.collection("books").doc(book.id.toString()).delete().then(
          (doc) => print("Document deleted"),
      onError: (e) => print("Error updating document $e"),
    );
  Navigator.pop(context,true);
  }
}