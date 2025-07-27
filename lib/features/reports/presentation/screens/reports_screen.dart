import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/reports_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch event summaries when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReportsProvider>().fetchEventSummaries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Event Reports'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Event Summaries'),
              Tab(text: 'Attendees'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEventSummariesTab(),
            _buildAttendeesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildEventSummariesTab() {
    return Consumer<ReportsProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading && provider.eventSummaries.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${provider.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: provider.fetchEventSummaries,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (provider.eventSummaries.isEmpty) {
          return const Center(child: Text('No event summaries available'));
        }

        return ListView.builder(
          itemCount: provider.eventSummaries.length,
          itemBuilder: (context, index) {
            final summary = provider.eventSummaries[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                title: Text(
                  summary.eventTitle,
                  style: AppTextStyles.titleMedium,
                ),
                subtitle: Text(
                  '${summary.attendeeCount} / ${summary.capacity} attendees',
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Date',
                            '${_formatDate(summary.startDate)} - ${_formatDate(summary.endDate)}'),
                        _buildInfoRow('Location', summary.location),
                        _buildInfoRow('Type', summary.type),
                        _buildInfoRow('Status', summary.status),
                        _buildInfoRow('Ticket Price', summary.ticketPrice),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: summary.capacity > 0
                              ? summary.attendeeCount / summary.capacity
                              : 0,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            summary.attendeeCount >= summary.capacity
                                ? Colors.red
                                : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAttendeesTab() {
    // This would be implemented similarly to _buildEventSummariesTab
    // but for displaying event attendees
    return const Center(
      child: Text('Select an event to view attendees'),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }
}
