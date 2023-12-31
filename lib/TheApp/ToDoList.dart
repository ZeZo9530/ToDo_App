// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/TheApp/DoneTasks.dart';
import 'package:flutter_application_1/TheApp/InProgress.dart';
import 'package:flutter_application_1/TheApp/taskBuilder.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

TextEditingController inputController = TextEditingController();
bool? isChecked = false;

List todoList = [
  // ["make tea", false],
  // ['do task', false],
  // ['call mom', false],
  // ["take break", false],
  // ['make food', false]
];

class _ToDoScreenState extends State<ToDoScreen> {
  void inprogrezz() {
    InProgress.todolists = todoList;
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 100,
              child: Column(
                children: [
                  TextField(
                    controller: inputController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            todoList.add([inputController.text, false]);
                            Navigator.of(context).pop();
                            inputController.clear();
                            inprogrezz();
                          });
                        },
                        color: Colors.deepPurple[200],
                        child: const Text("save"),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Colors.deepPurple[200],
                        child: const Text("cancel"),
                      )
                    ],
                  )
                ],
              ),
            ),
            backgroundColor: Colors.grey[200],
          );
        });
  }

  void deleteTask(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      todoList[index][1] = !todoList[index][1];
      if (todoList[index][1] == true) {
        DoneTasks.todolistz.add(todoList[index]);
        InProgress.todolists.remove(todoList[index]);
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text(
          "To Do List",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple[400],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.grey[300],
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return taskBuilder(
                deleteFunction: (context) => deleteTask(index),
                taskName: todoList[index][0],
                taskCompleted: todoList[index][1],
                onChanged: (value) => checkBoxChanged(value, index),
              );
            },
            itemCount: todoList.length,
            separatorBuilder: (context, index) => const Divider()),
      ),
    );
  }
}
