import 'package:flutter/material.dart';
import 'package:money_track/features/group/presentation/widgets/add_group_page.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Groups"),
      ),
      body: const Center(
        child: Text("Group List"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        label: Row(
          children: const [
            Icon(Icons.add),
            Text("Add Group"),
          ],
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(AddGroupPage.routeName);
        },
      ),
    );
  }
}
