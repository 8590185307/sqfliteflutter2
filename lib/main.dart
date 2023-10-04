import 'package:flutter/material.dart';

import 'MyDBManager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DBStudentManager dbStudentManager = DBStudentManager();
  final _nameController = TextEditingController();
  final _courseController = TextEditingController();
  final _bloodgrpController=TextEditingController();
  final _placeController=TextEditingController();
  final _formkey = GlobalKey<FormState>();
  Student? student;
  late int updateindex;

  late List<Student> studlist;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Sqflite Example"),
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: "Name"),
                    controller: _nameController,
                    validator: (val) =>
                    val!.isNotEmpty ? null : "Name Should not be Empty",
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "Course"),
                    controller: _courseController,
                    validator: (val) =>
                    val!.isNotEmpty ? null : "Course Should not be Empty",
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "bloodgrp"),
                    controller: _bloodgrpController,
                    validator: (val) =>
                    val!.isNotEmpty ? null : "bloodgrp Should not be Empty",
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: "place"),
                    controller: _placeController,
                    validator: (val) =>
                    val!.isNotEmpty ? null : "place Should not be Empty",
                  ),
                  ElevatedButton(

                    child: Container(
                        width: width * 0.9,
                        child: Text(
                          "Submit",
                          textAlign: TextAlign.center,
                        )),
                    onPressed: () {
                      submitStudent(context);
                    },
                  ),
                  FutureBuilder(
                    future: dbStudentManager.getStudentList(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        studlist = snapshot.data as List<Student>;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: studlist == null ? 0 : studlist.length,
                          itemBuilder: (BuildContext context, int index) {
                            Student st = studlist[index];
                            return Card(
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: SizedBox(
                                      width: width * 0.50,
                                      child: Column(
                                        children: <Widget>[
                                          Text('ID: ${st.id}'),
                                          Text('Name: ${st.name}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _nameController.text = st.name;
                                      _courseController.text = st.course;
                                      _bloodgrpController.text=st.bloodgrp;
                                      _placeController.text=st.place;
                                      student = st;
                                      updateindex = index;
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      dbStudentManager.deleteStudent(st.id);
                                      setState(() {
                                        studlist.removeAt(index);
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void submitStudent(BuildContext context) {
    if (_formkey.currentState!.validate()) {
      if (student == null) {
        Student st =  Student(
            name: _nameController.text, course: _courseController.text, bloodgrp: _bloodgrpController.text, place: _placeController.text);
        dbStudentManager.insertStudent(st).then((value) => {
          _nameController.clear(),
          _courseController.clear(),
          _bloodgrpController.clear(),
          _placeController.clear(),
          print("Student Data Add to database $value"),
        });
      }
      else {
        student?.name = _nameController.text;
        student?.course = _courseController.text;
        student?.bloodgrp=_bloodgrpController.text;
        student?.place=_placeController.text;

        dbStudentManager.updateStudent(student!).then((value) {
          setState(() {
            studlist[updateindex].name = _nameController.text;
            studlist[updateindex].course = _courseController.text;
            studlist[updateindex].bloodgrp = _bloodgrpController.text;
            studlist[updateindex].place = _placeController.text;
          });
          _nameController.clear();
          _courseController.clear();
          _bloodgrpController.clear();
          _placeController.clear();
          student=null;
        });
      }
    }
  }
}
