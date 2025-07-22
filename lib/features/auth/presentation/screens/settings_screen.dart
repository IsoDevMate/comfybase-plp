import 'package:flutter/material.dart';

class NotificationSettings {
  bool events;
  bool reminders;
  bool updates;
  bool marketing;

  NotificationSettings({
    this.events = true,
    this.reminders = true,
    this.updates = false,
    this.marketing = false,
  });
}

class SubscriptionPlan {
  final String id;
  final String name;
  final String price;
  final String period;
  final List<String> features;
  final bool current;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.period,
    required this.features,
    this.current = false,
  });
}

class Integration {
  final String id;
  final String name;
  final bool connected;
  final IconData icon;

  Integration({
    required this.id,
    required this.name,
    required this.connected,
    required this.icon,
  });
}

// Main Settings Page
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 0;
  late NotificationSettings _notificationSettings;
  late List<SubscriptionPlan> _plans;
  late List<Integration> _integrations;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _notificationSettings = NotificationSettings();

    _plans = [
      SubscriptionPlan(
        id: 'free',
        name: 'Free Plan',
        price: '\$0',
        period: 'forever',
        features: ['Basic features', '1 project', '1 user'],
      ),
      SubscriptionPlan(
        id: 'pro',
        name: 'Pro Plan',
        price: '\$19',
        period: 'monthly',
        features: [
          'All features',
          'Unlimited projects',
          'Up to 5 users',
          'Priority support',
        ],
        current: true,
      ),
      SubscriptionPlan(
        id: 'enterprise',
        name: 'Enterprise',
        price: '\$99',
        period: 'monthly',
        features: [
          'All features',
          'Unlimited projects',
          'Unlimited users',
          'Dedicated support',
          'Custom integrations',
        ],
      ),
    ];

    _integrations = [
      Integration(
        id: 'slack',
        name: 'Slack',
        connected: true,
        icon: Icons.chat,
      ),
      Integration(
        id: 'github',
        name: 'GitHub',
        connected: true,
        icon: Icons.code,
      ),
      Integration(
        id: 'google',
        name: 'Google Calendar',
        connected: false,
        icon: Icons.calendar_today,
      ),
      Integration(
        id: 'dropbox',
        name: 'Dropbox',
        connected: false,
        icon: Icons.cloud_upload,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sidebar
              Container(
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: _buildSidebar(),
              ),
              // Content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: _buildContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    final items = [
      {'icon': Icons.mail, 'label': 'Account', 'index': 0},
      {'icon': Icons.shield, 'label': 'Security', 'index': 1},
      {'icon': Icons.notifications, 'label': 'Notifications', 'index': 2},
      {'icon': Icons.credit_card, 'label': 'Billing', 'index': 3},
      {'icon': Icons.language, 'label': 'Integrations', 'index': 4},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: items.map((item) {
          final isSelected = _selectedIndex == item['index'];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () =>
                    setState(() => _selectedIndex = item['index'] as int),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.indigo[50] : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        size: 20,
                        color: isSelected
                            ? Colors.indigo[700]
                            : Colors.grey[700],
                      ),
                      const SizedBox(width: 12),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.indigo[700]
                              : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildAccountSettings();
      case 1:
        return _buildSecuritySettings();
      case 2:
        return _buildNotificationSettings();
      case 3:
        return _buildBillingSettings();
      case 4:
        return _buildIntegrationsSettings();
      default:
        return _buildAccountSettings();
    }
  }

  Widget _buildAccountSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        _buildSettingCard(
          'Profile Information',
          'Update your name, email, and other personal details',
          'Update',
          Colors.indigo,
          () => print('Update profile'),
        ),
        const SizedBox(height: 16),
        _buildSettingCard(
          'Email Preferences',
          'Manage the emails you receive from us',
          'Manage',
          Colors.indigo,
          () => print('Manage emails'),
        ),
        const SizedBox(height: 16),
        _buildSettingCard(
          'Delete Account',
          'Permanently delete your account and all data',
          'Delete',
          Colors.red,
          () => _showDeleteAccountDialog(),
        ),
      ],
    );
  }

  Widget _buildSecuritySettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Security Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        _buildSettingCard(
          'Change Password',
          'Update your password for enhanced security',
          'Change',
          Colors.indigo,
          () => print('Change password'),
          icon: Icons.vpn_key,
        ),
        const SizedBox(height: 16),
        _buildSettingCard(
          'Two-Factor Authentication',
          'Add an extra layer of security to your account',
          'Enable',
          Colors.indigo,
          () => print('Enable 2FA'),
          icon: Icons.lock,
        ),
        const SizedBox(height: 16),
        _buildSettingCard(
          'Active Sessions',
          'Manage and logout from active devices',
          'Manage',
          Colors.indigo,
          () => print('Manage sessions'),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notification Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        const Text(
          'Email Notifications',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        _buildNotificationToggle(
          'Event Updates',
          'Receive notifications about your events',
          _notificationSettings.events,
          (value) => setState(() => _notificationSettings.events = value),
        ),
        _buildNotificationToggle(
          'Reminders',
          'Get reminders for upcoming events',
          _notificationSettings.reminders,
          (value) => setState(() => _notificationSettings.reminders = value),
        ),
        _buildNotificationToggle(
          'Product Updates',
          'Stay updated with the latest features',
          _notificationSettings.updates,
          (value) => setState(() => _notificationSettings.updates = value),
        ),
        _buildNotificationToggle(
          'Marketing Emails',
          'Receive promotional emails from us',
          _notificationSettings.marketing,
          (value) => setState(() => _notificationSettings.marketing = value),
        ),
      ],
    );
  }

  Widget _buildBillingSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Billing Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        _buildSettingCard(
          'Payment Info',
          'Check your payment method for billing',
          'Check',
          Colors.indigo,
          () => print('Check payment'),
          icon: Icons.credit_card,
        ),
        const SizedBox(height: 16),
        _buildSettingCard(
          'Billing History',
          'View your past invoices and transactions',
          'View',
          Colors.indigo,
          () => print('View history'),
          icon: Icons.open_in_new,
        ),
        const SizedBox(height: 24),
        const Text(
          'Subscription Plan',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        const Text(
          'Manage your subscription plan',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        ..._plans.map((plan) => _buildPlanCard(plan)).toList(),
      ],
    );
  }

  Widget _buildIntegrationsSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Integrations',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const Text(
          'Connect your account with these services to enhance your workflow',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 24),
        ..._integrations
            .map((integration) => _buildIntegrationCard(integration))
            .toList(),
      ],
    );
  }

  Widget _buildSettingCard(
    String title,
    String subtitle,
    String actionText,
    Color actionColor,
    VoidCallback onTap, {
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onTap,
            icon: icon != null
                ? Icon(icon, size: 16, color: actionColor)
                : const SizedBox.shrink(),
            label: Text(
              actionText,
              style: TextStyle(color: actionColor, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.indigo,
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: plan.current ? Colors.indigo : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(8),
        color: plan.current ? Colors.indigo[50] : Colors.white,
      ),
      child: Row(
        children: [
          // Make this Expanded so it takes available space
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        plan.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis, // Prevent overflow
                        ),
                      ),
                    ),
                    if (plan.current) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.indigo[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Current',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.indigo[800],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: plan.price,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                        text: ' ${plan.period}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ...plan.features
                    .map(
                      (feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.flash_on,
                              size: 12,
                              color: Colors.indigo[600],
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                feature,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
          // Wrap button in Flexible to avoid overflow
          Flexible(
            child: ElevatedButton(
              onPressed: () =>
                  print('${plan.current ? 'Manage' : 'Upgrade'} ${plan.name}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: plan.current
                    ? Colors.grey[200]
                    : Colors.indigo,
                foregroundColor: plan.current ? Colors.grey[700] : Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: Text(plan.current ? 'Manage' : 'Upgrade'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntegrationCard(Integration integration) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(integration.icon, size: 32, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  integration.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  integration.connected ? 'Connected' : 'Not connected',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: () => setState(() {
              final index = _integrations.indexOf(integration);
              _integrations[index] = Integration(
                id: integration.id,
                name: integration.name,
                connected: !integration.connected,
                icon: integration.icon,
              );
            }),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: integration.connected ? Colors.red : Colors.indigo,
              ),
              foregroundColor: integration.connected
                  ? Colors.red
                  : Colors.indigo,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Text(integration.connected ? 'Disconnect' : 'Connect'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                print('Account deleted');
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
