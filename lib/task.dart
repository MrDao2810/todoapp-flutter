
List<Task> listTask = <Task>[];

class Task{ //modal class for Person object
  bool status;
  String content;
  Task({required this.status, required this.content});

  Map toJson() =>
      {'status': status, 'content': content};

  void fromJson(dynamic data) {
   status = data['status'];
   content = data['content'];
  }
}
