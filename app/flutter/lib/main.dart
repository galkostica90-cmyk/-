import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _checkedIn = false;
  late SharedPreferences _prefs;
  List<AttendanceEntry> _recentEntries = [];
  static const String _buildMarker = 'DASHBOARD_VER_1';

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _checkedIn = _prefs.getBool('checked_in') ?? false;
    });
    await _loadEntries();
  }

  Future<void> _loadEntries() async {
    final rows = await DB.allEntries();
    setState(() => _recentEntries = rows.reversed.take(5).toList());
  }

  Future<void> _toggleCheck() async {
    setState(() {
      _checkedIn = !_checkedIn;
    });
    await _prefs.setBool('checked_in', _checkedIn);
    // record to DB
    await DB.insertEntry(AttendanceEntry(timestamp: DateTime.now(), checkedIn: _checkedIn));
    await _loadEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _checkedIn ? 'מצב: נכנס' : 'מצב: לא נכנס',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _toggleCheck,
                    child: Text(_checkedIn ? 'Check out' : 'Check in'),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HistoryPage())),
                  child: const Text('History'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text('Recent activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _recentEntries.isEmpty
                        ? const Center(child: Text('No recent entries'))
                        : ListView.builder(
                            itemCount: _recentEntries.length,
                            itemBuilder: (context, i) {
                              final e = _recentEntries[i];
                              return ListTile(
                                leading: Icon(e.checkedIn ? Icons.login : Icons.logout),
                                title: Text(e.checkedIn ? 'Check in' : 'Check out'),
                                subtitle: Text(e.timestamp.toLocal().toString()),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      _buildMarker,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<AttendanceEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final rows = await DB.allEntries();
    setState(() => _entries = rows);
  }

  Future<void> _exportCsv() async {
    final rows = [<String>['id', 'timestamp', 'checked_in']]
      ..addAll(_entries.map((e) => [e.id?.toString() ?? '', e.timestamp.toIso8601String(), e.checkedIn ? 'in' : 'out']));
    final csvStr = const ListToCsvConverter().convert(rows);
    // share CSV text
    await Share.share(csvStr, subject: 'Attendance CSV');
  }

  Future<void> _clear() async {
    await DB.clear();
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History'), actions: [
        IconButton(onPressed: _exportCsv, icon: const Icon(Icons.share)),
        IconButton(onPressed: _clear, icon: const Icon(Icons.delete_forever)),
      ]),
      body: ListView.builder(
        itemCount: _entries.length,
        itemBuilder: (context, i) {
          final e = _entries[i];
          return ListTile(
            title: Text(e.checkedIn ? 'Check in' : 'Check out'),
            subtitle: Text(e.timestamp.toLocal().toString()),
          );
        },
      ),
    );
  }
}
