class History {
  String? status;


  History({this.status});

  History.fromJson(Map<String, dynamic> json) {
    status = json['status'];

  }
}