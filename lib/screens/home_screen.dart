import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final TextEditingController _titleController=TextEditingController();
final TextEditingController _descriptionController=TextEditingController();
class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive All Task'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        //dialogue open
        _showAddDialog(context);
      },
      child: Icon(Icons.add),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                //Edit dialogue
              },
              title: Text('mm'),
              subtitle: Text('Tdo Description'),
              trailing: Checkbox(
                value: true,
                onChanged: (value) {
                  setState(() {
                    //Set toggle value update hive db

                  });
                },
              ),
            );
          },
        ),
      ),
    );
  }
}


Future<void> _showAddDialog(context) async{
  await showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: Text('Add New Task '),
      content: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Title'
              ),
              controller: _titleController,
            ),
            TextField(
              decoration: const InputDecoration(
                  hintText: 'Description'
              ),
              controller: _descriptionController,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(onPressed: () {

        }, child: const Text('Add')),
        ElevatedButton(onPressed: () {

        }, child: const Text('Cancel')),
      ],
    );
  },);

}