import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class TodoScreen extends StatefulWidget {
  TodoScreen({Key? key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  SharedPreferences? sharedPreferences;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  DateTime? due;

  List<DataModel> dataList = [];
  List<String> mylist = [];

  @override
  void initState() {
    initsharedPreferences();

    super.initState();
  }

  initsharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();

    loadData();
  }

  saveData(t, c, d, s) async {
    List<String> lis = [t, c, d, s];
    mylist.addAll(lis);
    dataList.add(DataModel(t, c, DateTime.parse(d), DateTime.parse(s)));

    sharedPreferences!.setStringList("mylist4", mylist);
    print(mylist);
    setState(() {});
  }

  Future<void> saveDataToFirestore() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (!isConnected) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                actions: [
                  Center(
                      child: Column(
                    children: const [
                      Icon(
                        Icons.signal_wifi_connected_no_internet_4,
                        size: 50,
                        color: Colors.red,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "please check your network connection",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, 'ok'),
                      child: const Text('ok'),
                    ),
                  )
                ],
              ));
    } else {
      mylist.clear();
      final m = sharedPreferences!.getStringList("mylist4");
      mylist.addAll(m!);
      Map<String, dynamic> h = {"todo": mylist};
      await FirebaseFirestore.instance
          .collection('todo')
          .doc('n1YLKY3rOO5Q7GMSHHwT')
          .set(h)
          .then((value) => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    actions: [
                      const Center(
                        child: Icon(
                          Icons.check_circle_outline_rounded,
                          size: 50,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Center(
                          child: Text(
                        "data successfully uploaded to firestore",
                        style: TextStyle(fontSize: 15),
                      )),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, 'ok'),
                          child: const Text('ok'),
                        ),
                      )
                    ],
                  )));
    }
  }

  Future<void> loadDataFromFirestore() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    if (!isConnected) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                actions: [
                  Center(
                      child: Column(
                    children: const [
                      Icon(
                        Icons.signal_wifi_connected_no_internet_4,
                        size: 50,
                        color: Colors.red,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "please check your network connection",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, 'ok'),
                      child: const Text('ok'),
                    ),
                  )
                ],
              ));
    } else {
      List l = [];
      final a = await FirebaseFirestore.instance
          .collection('todo')
          .doc('n1YLKY3rOO5Q7GMSHHwT')
          .get()
          .then((value) {
        l.addAll(value.data()!.values);
        final len = l[0].length;
        dataList.clear();
        mylist.clear();
        for (var i = 0; i < len; i += 4) {
          var aa = DataModel(l[0][i], l[0][i + 1], DateTime.parse(l[0][i + 2]),
              DateTime.parse(l[0][i + 3]));
          mylist.add(l[0][i]);
          mylist.add(l[0][i+1]);
          mylist.add(l[0][i+2]);
          mylist.add(l[0][i+3]);
          dataList.add(aa);
        }

        sharedPreferences!.setStringList("mylist4", mylist);
      }).then((value) => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    actions: [
                      const Center(
                        child: Icon(
                          Icons.check_circle_outline_rounded,
                          size: 50,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const Center(
                          child: Text(
                        "data successfully loaded from firestore",
                        style: TextStyle(fontSize: 15),
                      )),
                      const SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, 'ok');
                          },
                          child: const Text('ok'),
                        ),
                      )
                    ],
                  )));
    }

    setState(() {});
  }

  loadData() {
    final m = sharedPreferences!.getStringList("mylist4");
    mylist.addAll(m ?? []);

    final len = mylist.length;
//? DateTime dateTime = DateTime.parse(mylist[i + 2]);
    for (var i = 0; i < len; i += 4) {
      final aa = DataModel(mylist[i], mylist[i + 1],
          DateTime.parse(mylist[i + 2]), DateTime.parse(mylist[i + 3]));
      dataList.add(aa);
    }
    print(dataList);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 255, 255, 255),
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: saveDataToFirestore,
                icon: const Icon(
                  Icons.upload_rounded,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: loadDataFromFirestore,
                icon: const Icon(
                  Icons.download,
                  color: Colors.black,
                )),
          ],
          backgroundColor: Colors.white,
          title: const Center(
              child: Text(
            "Todo or NotTodo",
            style: TextStyle(color: Colors.black),
          ))),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return Mycard(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          titleController.text = "";
          contentController.text = "";

          showDialog<String>(
            context: context,
            builder: (BuildContext context) => Center(
              child: AlertDialog(
                title: const Center(child: Text('Add a new task')),
                actions: <Widget>[
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: "Title",
                            border: OutlineInputBorder(),
                          ),
                          controller: titleController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: "Content",
                            contentPadding: EdgeInsets.symmetric(vertical: 40),
                            border: OutlineInputBorder(),
                          ),
                          controller: contentController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: () => showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2022),
                                    lastDate: DateTime(2025))
                                .then((value) => {
                                      setState(() {
                                        due = value;
                                      }),
                                    }),
                            child: Text("pick a Due date"))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          saveData(titleController.text, contentController.text,
                              due.toString(), DateTime.now().toString());
                          Navigator.pop(context, 'Add');
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[900],
      ),
    );
  }

  Widget Mycard(index) {
    DateTime? a = dataList[index].dueDate;
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 5,
        color: (DateTime.now().isAfter(dataList[index].dueDate!))
            ? Colors.red[300]
            : Colors.teal[300],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ListTile(
              title: Text(
                dataList[index].title.toString(),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
              ),
              subtitle: Text(dataList[index].contend.toString()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("added: " +
                    DateFormat('dd-MM-yy ')
                        .format(dataList[index].submitDate!)
                        .toString()),
                Text("due: " +
                    DateFormat('dd-MM-yy')
                        .format(dataList[index].dueDate!)
                        .toString()),
              ],
            ),
            const SizedBox(
              height: 4,
            )
          ],
        ),
      ),
    );
  }
}
