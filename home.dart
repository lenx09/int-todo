import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/Task.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  var user;
  late String _etask;
  late String uid;
  late String _task;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  void signin() async {
    user = await _auth.signInAnonymously();
    uid = user.user!.uid;
    print(user.user!.uid);
  }

  Future<void> add() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    Task task = Task(_task, '0', uid, '0');
    await _databaseReference.child('task').push().set(task.toJson());
  }

  void delete(String key) {
    _databaseReference.child('task').child(key).remove();
  }

  void done(String key, String taskd) {
    Task task = Task(taskd, '1', uid, '0');
    _databaseReference.child('task').child(key).set(task.toJson());
  }

  void undone(String key, String taskd) {
    Task task = Task(taskd, '0', uid, '0');
    _databaseReference.child('task').child(key).set(task.toJson());
  }
 void edit(String key, String taskd,String done){
      Task task = Task(taskd,done, uid, '1');
    _databaseReference.child('task').child(key).set(task.toJson());
 }
 void editd(String key,String done){
   if (_formKey1.currentState!.validate()) {
      _formKey1.currentState!.save();
    }
 Task task = Task(_etask,done, uid, '0');
    _databaseReference.child('task').child(key).set(task.toJson());
 }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    signin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        title: Row(
          children: [
          Image(image:AssetImage('assets/splash.png'),
          width:30,
          height:30,

          ),
            Text(
              'Todo',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    padding: EdgeInsets.fromLTRB(5, 30, 5, 0),
                    child: TextFormField(
                      validator: (input) {
                        if (input!.isEmpty) {
                          return 'Provide task';
                        }
                        return null;
                      },
                      onSaved: (input) => _task = input!,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: 'Type something here',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        add();
                      },
                      icon: Icon(
                        Icons.add_circle,
                        color: Colors.black,
                        size: 60,
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: FirebaseAnimatedList(
                  query: _databaseReference.child('task'),
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    if (uid == snapshot.value['uid']) {
                      return Card(
                          margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                          shape: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey.shade300, width: 0.5),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Container(
                              height: 70,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    snapshot.value['done'] != "1"
                                        ? IconButton(
                                            onPressed: () {
                                              done(snapshot.key.toString(),
                                                  snapshot.value['task']);
                                            },
                                            icon: Icon(
                                              Icons.check_circle_outline,
                                              size: 30,
                                            ))
                                        : IconButton(
                                            onPressed: () {
                                              undone(snapshot.key.toString(),
                                                  snapshot.value['task']);
                                            },
                                            icon: Icon(
                                              Icons.check_circle_outline,
                                              size: 30,
                                              color: Colors.green[800],
                                            )),
                                  snapshot.value['edit']=='0'?
                                    Text(
                                      snapshot.value['task'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ):Container(
                                      width:180,
                                      child: Form(
                                        key: _formKey1,
                                        child: TextFormField(
                                                            validator: (input) {
                                                              if (input!.isEmpty) {
                                                                return 'Provide task';
                                                              }
                                                              return null;
                                                            },
                                                            onSaved: (input) => _etask = input!,
                                                            obscureText: false,
                                                            decoration: InputDecoration(
                                                              hintText: snapshot.value['task'],
                                                              
                                                              labelStyle: TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w700,
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(color: Colors.grey.shade300, width: 0.4),
                                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                              ),
                                                              enabledBorder: OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(color: Colors.black, width: 1.0),
                                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                              ),
                                                            ),
                                                          ),
                                      ),
                                    ),













                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        snapshot.value['edit']=='0'?
                                        IconButton(
                                            onPressed: () {
                                              edit(snapshot.key.toString(),
                                              snapshot.value['task'],
                                               snapshot.value['done']
                                              );
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              size: 30,
                                            )):
                                           IconButton(
                                            onPressed: () {
                                              editd(snapshot.key.toString(),
                                               snapshot.value['done']
                                              );
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.green.shade400,
                                              size: 30,
                                            )),



                                        IconButton(
                                            onPressed: () {
                                              delete(snapshot.key.toString());
                                            },
                                            icon: Icon(
                                              Icons.delete_forever,
                                              size: 30,
                                            )),
                                      ],
                                    ),
                                  ])));
                    }
                    return SizedBox(
                      height: 0,
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
