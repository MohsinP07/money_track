import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/entity/user.dart';
import 'package:money_track/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:money_track/features/expenses/presentation/widgets/sheet_textfield.dart';

class EditProfileSheet extends StatefulWidget {
  final User user;
  const EditProfileSheet({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  final GlobalKey<FormState> _sheetKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _phoneController.dispose();
  }

  void _onEditProfile(BuildContext context) {
  if (_sheetKey.currentState!.validate()) {
    context.read<AuthBloc>().add(AuthEditProfile(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
        ));
  }
}

@override
Widget build(BuildContext context) {
  return BlocListener<AuthBloc, AuthState>(
    listener: (context, state) {
      if (state is AuthLoading) {
        setState(() {
          _isLoading = true;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        if (state is AuthSuccess) {
          Navigator.pop(context);  // Close the bottom sheet
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      }
    },
    child: StatefulBuilder(builder: (context, setState) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _sheetKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 12),
                SheetTextField(
                  controller: _nameController,
                  label: 'Name',
                ),
                const SizedBox(height: 8),
                SheetTextField(
                  controller: _phoneController,
                  label: 'Phone',
                ),
                const SizedBox(height: 8),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: 80,
                        child: CustomButton(
                          text: 'Edit',
                          onTap: () => _onEditProfile(context),
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
    }),
  );
}
}