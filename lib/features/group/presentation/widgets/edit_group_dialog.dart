import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/features/group/domain/entity/group.dart';
import 'package:money_track/features/group/presentation/bloc/bloc/group_bloc.dart';

class EditGroupDialog extends StatefulWidget {
  final GroupEntity group;

  const EditGroupDialog({Key? key, required this.group}) : super(key: key);

  @override
  State<EditGroupDialog> createState() => _EditGroupDialogState();
}

class _EditGroupDialogState extends State<EditGroupDialog> {
  late TextEditingController _groupNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _budgetController;

  @override
  void initState() {
    super.initState();
    _groupNameController = TextEditingController(text: widget.group.groupName);
    _descriptionController =
        TextEditingController(text: widget.group.groupDescription);
    _budgetController =
        TextEditingController(text: widget.group.budget.toString());
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _submitChanges() {
    final updatedGroup = widget.group.copyWith(
      groupName: _groupNameController.text,
      groupDescription: _descriptionController.text,
      budget: _budgetController.text,
    );

    context.read<GroupBloc>().add(GroupEdit(
          id: widget.group.id!,
          groupName: updatedGroup.groupName,
          groupDescription: updatedGroup.groupDescription,
          budget: updatedGroup.budget,
        ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Edit Group Details",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _groupNameController,
              decoration: const InputDecoration(labelText: "Group Name"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _budgetController,
              decoration: const InputDecoration(labelText: "Budget"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: _submitChanges,
                  child: const Text("Save"),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
