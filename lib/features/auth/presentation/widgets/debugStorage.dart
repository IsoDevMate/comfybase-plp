import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../../core/services/storage_service_factory.dart';

class StorageDebugWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DEBUG INFO:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Is Logged In: ${authProvider.isLoggedIn}'),
              Text('User: ${authProvider.user?.email ?? 'null'}'),
              Text('Error: ${authProvider.error ?? 'none'}'),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  await authProvider.debugStorage();
                },
                child: Text('Debug Storage'),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  await authProvider.checkAuthStatus();
                },
                child: Text('Check Auth Status'),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  final storage = getStorageService();

                  // Test storage directly
                  await storage.write(key: 'test_key', value: 'test_value');
                  final testValue = await storage.read(key: 'test_key');

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Test storage result: $testValue')),
                  );
                },
                child: Text('Test Storage'),
              ),
            ],
          ),
        );
      },
    );
  }
}
