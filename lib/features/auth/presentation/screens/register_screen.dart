import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/register_request.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String firstName = '';
  String lastName = '';
  String role = 'attendee';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (val) => email = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter email' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (val) => password = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter password' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'First Name'),
                onChanged: (val) => firstName = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter first name' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Last Name'),
                onChanged: (val) => lastName = val,
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter last name' : null,
              ),
              DropdownButtonFormField<String>(
                value: role,
                items: const [
                  DropdownMenuItem(value: 'attendee', child: Text('Attendee')),
                  DropdownMenuItem(
                    value: 'organizer',
                    child: Text('Organizer'),
                  ),
                ],
                onChanged: (val) => setState(() => role = val ?? 'attendee'),
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              const SizedBox(height: 16),
              if (authProvider.isLoading) const CircularProgressIndicator(),
              if (authProvider.error != null)
                Text(
                  authProvider.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ElevatedButton(
                onPressed: authProvider.isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          final request = RegisterRequest(
                            email: email,
                            password: password,
                            firstName: firstName,
                            lastName: lastName,
                            role: role,
                          );
                          await authProvider.register(request);
                          if (authProvider.error == null) {
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        }
                      },
                child: const Text('Register'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
