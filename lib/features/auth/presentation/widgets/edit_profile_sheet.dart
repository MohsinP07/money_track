import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/entity/user.dart';
import 'package:money_track/core/themes/app_pallete.dart';
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
  bool _isSaveButtonVisible = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);

    _nameController.addListener(_checkForChanges);
    _phoneController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    setState(() {
      _isSaveButtonVisible = _nameController.text.trim() != widget.user.name ||
          _phoneController.text.trim() != widget.user.phone;
    });
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
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _phoneController.dispose();

    _nameController.addListener(_checkForChanges);
    _phoneController.addListener(_checkForChanges);
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
            Navigator.pop(context); // Close the bottom sheet
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppPallete.boxColor,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _isSaveButtonVisible,
                        child: SizedBox(
                          width: 80,
                          child: CustomButton(
                            text: 'Edit',
                            onTap: () => _onEditProfile(context),
                          ),
                        ),
                      ),
                    ],
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
