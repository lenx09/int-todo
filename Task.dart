import 'package:firebase_database/firebase_database.dart';

class Task {
  late String _id;
  late String _task;
  late String _done;
  late String _uid;
  late String _edit;

  Task(this._task, this._done, this._uid, this._edit);
  Task.withId(this._task, this._done, this._uid, this._id, this._edit);

  String get task => this._task;
  String get uid => this._uid;
  String get done => this._done;
  String get id => this._id;
  String get edit => this._edit;
  set task(String task) {
    this._task = task;
  }

  set id(String id) {
    this._id = id;
  }

  set done(String done) {
    this._done = done;
  }

  set uid(String uid) {
    this._uid = uid;
  }

  set edit(String edit) {
    this._edit = edit;
  }

  Task.fromSnapshot(DataSnapshot snapshot) {
    this._id = snapshot.key!;
    this._uid = snapshot.value['uid'];
    this._task = snapshot.value['task'];
    this._done = snapshot.value['done'];
    this._edit = snapshot.value['edit'];
  }

  Map<String, dynamic> toJson() {
    return {"task": _task, "done": _done, "uid": _uid, "edit": _edit};
  }
}
