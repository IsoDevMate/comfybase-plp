import 'package:kenyanvalley/features/reports/data/datasources/reports_service.dart';
import 'package:kenyanvalley/features/reports/presentation/providers/reports_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> getReportsProviders() {
  final reportsService = ReportsService();
  
  return [
    ChangeNotifierProvider(
      create: (context) => ReportsProvider(reportsService: reportsService),
    ),
  ];
}
