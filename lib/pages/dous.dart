import 'package:flutter/material.dart';
//
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
//
import 'package:dous/models/dous_task.dart';
import 'package:dous/services/dous_service.dart';
import 'package:dous/utils/images_urls.dart';
import 'package:dous/services/user_service.dart';

class DoUs extends StatefulWidget {
  const DoUs({super.key});

  @override
  State<DoUs> createState() => _DoUsState();
}

class _DoUsState extends State<DoUs> {
  final List<Widget> tasks = [];
  final TextEditingController textController = TextEditingController();
  late String currentUser;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  late DateTime? date;
  late TimeOfDay? time;
  late DateTime toUTC;

  FocusNode currentFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    currentUser =
        Provider.of<UserService>(context, listen: false).currentUser.userName;

    var dousList = Provider.of<DousService>(context, listen: true).todos;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            imgUrl,
          ),
        ),
      ),
      child: DefaultTabController(
        animationDuration: const Duration(milliseconds: 600),
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              leadingWidth: 25,
              title: Text(
                'DoUs',
                style: GoogleFonts.oxygen(),
              ),
              backgroundColor:
                  Theme.of(context).colorScheme.surface.withOpacity(0.65),
              bottom: const PreferredSize(
                preferredSize: Size(double.infinity, 30),
                child: TabBar(
                  tabs: [
                    Tab(
                      text: 'Tasks',
                    ),
                    Tab(
                      text: 'Important',
                    ),
                    Tab(
                      text: 'Completed',
                    ),
                  ],
                ),
              )),
          body: TabBarView(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: dousList.length,
                      itemBuilder: (context, index) {
                        if (!dousList[index].done) {
                          return DousCard(
                            dous: dousList[index],
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  SafeArea(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: TextField(
                        controller: textController,
                        focusNode: currentFocus,
                        cursorColor: Theme.of(context).indicatorColor,
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).cardColor,
                          filled: true,
                          // HINT STYLE
                          hintText: 'Add new task...',
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(255, 253, 228, 0.75),
                          ),
                          // BORDERs
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).indicatorColor,
                              width: 2,
                            ),
                          ),
                          // ICONS
                          prefixIcon: Icon(
                            Icons.add,
                            color: Theme.of(context).indicatorColor,
                          ),
                          // GET THE DATE AND TIME
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.calendar_month,
                              color: Theme.of(context).indicatorColor,
                            ),
                            onPressed: () async {
                              // DATE PICKER
                              date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 356),
                                ),
                              );
                              // TIME PICKER
                              time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              // Convert to A suitable format
                              toUTC = DateTime(date!.year, date!.month,
                                  date!.day, time!.hour, time!.minute);
                            },
                          ),
                        ),
                        // When the user press done
                        onSubmitted: (value) async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          if (value.isNotEmpty) {
                            final task = DoUsTask(
                              userName: currentUser,
                              created: DateTime.now(),
                              dueDate: toUTC,
                              title: value,
                            );
                            // ADD NEW TASK TO DATABASE
                            final result = await Provider.of<DousService>(
                                    context,
                                    listen: false)
                                .createDous(task);
                            // SHOW MESSAGE TO USER
                            if (mounted) {
                              Fluttertoast.showToast(
                                msg: result == 'OK'
                                    ? 'Task added successfuly'
                                    : '$result\nFailed to add new task',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 2,
                                backgroundColor: Theme.of(context).cardColor,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                            // CLEAR TEXTFIELD
                            textController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              // This is Redundant: Only to show Consumer
              Consumer<DousService>(
                builder: (context, value, child) => ListView.builder(
                  itemCount: value.todos.length,
                  itemBuilder: (context, index) {
                    if (value.todos[index].important) {
                      return DousCard(
                        dous: value.todos[index],
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              // This is Redundant: Only to show Consumer
              Consumer<DousService>(
                builder: (context, value, child) => ListView.builder(
                  itemCount: value.todos.length,
                  itemBuilder: (context, index) {
                    if (value.todos[index].done) {
                      return DousCard(
                        dous: value.todos[index],
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DousCard extends StatefulWidget {
  const DousCard({
    super.key,
    required this.dous,
  });

  final DoUsTask dous;

  @override
  State<DousCard> createState() => _DousCardState();
}

class _DousCardState extends State<DousCard> {
  bool isImportant = false;
  bool isTaskCompleted = false;
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor.withOpacity(0.65),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ListTile(
            onTap: () {
              showDialog(
                // Whether you can dismiss this route by tapping the modal barrier.
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      'Edit your DoUs tasks',
                      style: TextStyle(color: Colors.teal),
                    ),
                    content: TextField(
                      controller: controller,
                      cursorColor: Colors.teal,
                      decoration: InputDecoration(
                        hintText: 'Edit your DoUs task',
                        labelText: widget.dous.title,
                        labelStyle: const TextStyle(color: Colors.teal),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal),
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.teal),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text('Delete',
                            style: TextStyle(color: Colors.teal)),
                        onPressed: () {
                          Provider.of<DousService>(context, listen: false)
                              .deleteDoUs(widget.dous);
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text('Save',
                            style: TextStyle(color: Colors.teal)),
                        onPressed: () async {
                          // Create an alias since DoUsTask attributes are final
                          DoUsTask task = DoUsTask(
                            id: widget.dous.id,
                            userName: widget.dous.userName,
                            title: controller.value.text,
                            created: widget.dous.created,
                            dueDate: widget.dous.dueDate,
                          );
                          // Update
                          Provider.of<DousService>(context, listen: false)
                              .updateDoUs(task);

                          controller.clear();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            leading: Checkbox(
              value: widget.dous.done,
              activeColor: widget.dous.done
                  ? Theme.of(context).colorScheme.surface
                  : Colors.white70,
              onChanged: (isDone) {
                Provider.of<DousService>(context, listen: false)
                    .toggleIsComplete(widget.dous);
              },
              shape: const CircleBorder(),
            ),
            title: Text(
              widget.dous.title,
              style: TextStyle(
                decoration:
                    widget.dous.done ? TextDecoration.lineThrough : null,
                decorationColor: Theme.of(context).colorScheme.surface,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.star_outline,
                color: widget.dous.important
                    ? Theme.of(context).colorScheme.surface
                    : Colors.white70,
              ),
              isSelected: widget.dous.important,
              selectedIcon: Icon(
                Icons.star,
                color: widget.dous.important
                    ? Theme.of(context).colorScheme.surface
                    : Colors.white70,
              ),
              onPressed: () {
                Provider.of<DousService>(context, listen: false)
                    .toggleIsImportant(widget.dous);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Text(
              DateFormat().format(widget.dous.dueDate),
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
