import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../providers/settings_provider.dart';
import '../providers/calculator_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();
    final settings = provider.settings;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // Precision Setting
          ListTile(
            title: const Text('Decimal Precision'),
            subtitle: Text('${settings.precision} digits'),
            trailing: DropdownButton<int>(
              value: settings.precision,
              items: [2, 4, 6, 8, 10, 12, 16].map((e) => DropdownMenuItem(value: e, child: Text(e.toString()))).toList(),
              onChanged: (val) {
                if (val != null) provider.setPrecision(val);
              },
            ),
          ),
          const Divider(),
          
          // Default Mode
          ListTile(
            title: const Text('Default Start Mode'),
            subtitle: Text(settings.defaultMode.name.toUpperCase()),
            trailing: DropdownButton<CalculatorMode>(
              value: settings.defaultMode,
              items: CalculatorMode.values.map((m) => DropdownMenuItem(value: m, child: Text(m.name))).toList(),
              onChanged: (val) {
                if (val != null) provider.setDefaultMode(val);
              },
            ),
          ),
          const Divider(),

          // Vibration
          SwitchListTile(
            title: const Text('Haptic Feedback'),
            subtitle: const Text('Vibrate on key press'),
            value: settings.vibrationEnabled,
            onChanged: (val) => provider.setVibration(val),
          ),
          const Divider(),

          // Backup / Restore
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Data Management', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text('Backup Settings (Copy to Clipboard)'),
                  onPressed: () {
                    String json = provider.exportSettings();
                    Clipboard.setData(ClipboardData(text: json));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings copied to clipboard!')));
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.upload),
                  label: const Text('Restore Settings'),
                  onPressed: () {
                    _showRestoreDialog(context, provider);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _showRestoreDialog(BuildContext context, SettingsProvider provider) {
    final TextEditingController ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Restore Settings'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            labelText: 'Paste JSON here',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              try {
                provider.importSettings(ctrl.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings restored!')));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid JSON')));
              }
            }, 
            child: const Text('Restore')
          ),
        ],
      ),
    );
  }
}
