class DataModel {
  String? title;
  String? contend;
  DateTime? dueDate;
  DateTime? submitDate;

  DataModel(this.title, this.contend, this.dueDate, this.submitDate);

  Map<String, dynamic> toMap() => {
        "title": title,
        "contend": contend,
        "dueDate": dueDate,
        "submitDate": submitDate,
      };
}
