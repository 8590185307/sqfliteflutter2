import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBStudentManager {
  late Database _datebase;

  Future openDB() async {
    _datebase = await openDatabase(join(await getDatabasesPath(), "blood.db"),
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE bloodtable(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,course TEXT,bloodgrp TEXT,place TEXT)");
        });
  }



  Future<int> insertStudent(Student student) async {
    await openDB();
    return await _datebase.insert('bloodtable', student.toMap());

  }




  Future<List<Student>> getStudentList() async {
    await openDB();
    final List<Map<String, dynamic>> maps = await _datebase.query('bloodtable');
    return List.generate(maps.length, (index) {
      return Student(id: maps[index]['id'], name: maps[index]['name'], course: maps[index]['course'],bloodgrp:maps[index]['bloodgrp'], place: maps[index]['place']);
    });
  }


  Future<int> updateStudent(Student student) async {
    await openDB();
    return await _datebase.update('bloodtable', student.toMap(), where: 'id=?', whereArgs: [student.id]);
  }

  Future<void> deleteStudent(int? id) async {
    await openDB();
    await _datebase.delete("bloodtable", where: "id = ? ", whereArgs: [id]);
  }
}

class Student {
  int? id;
  String name;
  String course;
  String bloodgrp;
  String place;
  Student({ this.id,required this.name, required this.course, required this.bloodgrp,required this.place});
  Map<String, dynamic> toMap() {
    return {'name': name, 'course': course ,'bloodgrp':bloodgrp,'place':place};
  }
}