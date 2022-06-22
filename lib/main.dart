import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Classes/Book.dart';
import 'Screens/AddBook.dart';
import 'Screens/DetailOfBook.dart';
enum popup {About,Help}

void AboutDialog(BuildContext context) {
  var uyari = AlertDialog(
    title: Text("by Erensz.."),
     content:Text("ver :: 0.5") ,

  );

  showDialog(context: context, builder: (BuildContext context) => uyari);
}
void HelpDialog(BuildContext context) {
  var uyari = AlertDialog(
    title: Text("If you wanna add a new book just click add buton."),
    content: Text("And for see book details and operations just click the book card."),

  );

  showDialog(context: context, builder: (BuildContext context) => uyari);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: begin()));
}

class begin extends StatefulWidget {
  @override
  State<begin> createState() => _beginState();
}
class _beginState extends State<begin> {
  late List<Book> books;
  final Stream<QuerySnapshot> _booksStream =
  FirebaseFirestore.instance.collection('books').snapshots();
  int lbi=0;
  void initState()  {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("LIBRARY SYSTEM"),
      actions: [
        PopupMenuButton<popup >(
          onSelected: selectProcess,
          itemBuilder: (BuildContext context) =>  <PopupMenuEntry<popup>>[
            PopupMenuItem(child: Text("Help"),value: popup.Help),
            PopupMenuItem(child: Text("About"),value: popup.About)
          ]
        )]),
      body: buildBody(context),

    );
  }
  buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
      stream: _booksStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Connection Error!'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        else {
          return ListView(
            padding:EdgeInsets.only(top: 10.0),
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
              Map<String, dynamic> data =
              document.data()! as Map<String, dynamic>;
              lbi =data['id'];
              print(lbi);

              return buildListItem(context,data);

            })
                .toList()
                .cast(),
          );}},)

        ),
        buttonBuild(context)

      ],
    );
  }

  void selectProcess(popup value) {
    switch(value){
      case popup.About:
        AboutDialog(context);
        break;
      case popup.Help:
        HelpDialog(context);
        break;

    }
  }

  buttonBuild(BuildContext context) {
    return Row(
      children: [
        Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: RaisedButton(
              color: Colors.amberAccent,
              child: Row(
                children: [
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 3,
                      child:SizedBox(width: 5.0)),
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child:Icon(Icons.add_box)) ,
                  Flexible(
                      fit:FlexFit.tight,
                      flex: 1,
                      child: Text("Add")),
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 3,
                      child:SizedBox(width: 5.0))
                ],
              ),
              onPressed: ()  {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => addBook(lbi+1)));

              },
            )),

      ],
    );
  }
Widget buildListItem(BuildContext context, Map<String, dynamic> data,) {
  return Card(
      color: Colors.blueGrey,
      elevation: 2.0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.redAccent,
          child: const Text('📖'),
        ),
        title: Text(data['name']),
        subtitle: Text(data['author']),
        trailing: Icon(Icons.book_outlined),
        onTap: ()  {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => detailBook(Book.withId(data['id'], data['name'], data['author'], data['topic'], data['pageNumber']))));
        },
      ));


}
}
