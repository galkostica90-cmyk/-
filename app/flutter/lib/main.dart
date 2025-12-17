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
  }

  Future<void> _toggleCheck() async {
    setState(() {
      _checkedIn = !_checkedIn;
    });
    await _prefs.setBool('checked_in', _checkedIn);
    // record to DB
    await DB.insertEntry(AttendanceEntry(timestamp: DateTime.now(), checkedIn: _checkedIn));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _checkedIn ? 'Checked in' : 'Checked out',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleCheck,
              child: Text(_checkedIn ? 'Check out' : 'Check in'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HistoryPage())),
              child: const Text('History'),
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
