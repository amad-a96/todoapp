import 'package:flutter/material.dart';
import 'model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

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

  saveData(t, c, d, s) {
    List<String> lis = [t, c, d, s];
    mylist.addAll(lis);
    sharedPreferences!.setStringList("mylist", mylist);

    dataList.add(DataModel(t, c, DateTime.parse(d), DateTime.parse(s)));
    setState(() {});
  }

  loadData() {
    final m = sharedPreferences!.getStringList("mylist");

    mylist.addAll(m!);

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
      appBar: AppBar(title: const Center(child: Text("Todo or NotTodo"))),
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
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
      ),
    );
  }

  Widget Mycard(index) {
    return Card(
      color: Colors.teal[300],
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
              Text(dataList[index].submitDate.toString()),
              Text(dataList[index].dueDate.toString()),
            ],
          ),
          const SizedBox(
            height: 4,
          )
        ],
      ),
    );
  }
}
