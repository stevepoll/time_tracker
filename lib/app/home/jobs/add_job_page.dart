import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/services/database.dart';

// ignore: use_key_in_widget_constructors
class AddJobPage extends StatefulWidget {
  const AddJobPage({Key? key, required this.database}) : super(key: key);

  static Future<void> show(BuildContext context) async {
    final database = context.read<Database>();
    await Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => AddJobPage(database: database),
      ),
    );
  }

  final Database database;

  @override
  State<AddJobPage> createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late double _ratePerHour;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      final job = Job(name: _name, ratePerHour: _ratePerHour);
      await widget.database.createJob(job);
    }
    // TODO: submit data to firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Job'),
        elevation: 2,
        actions: [
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onPressed: _submit,
          )
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: _buildContents(),
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job name'),
        validator: (value) =>
            value != null && value.isNotEmpty ? null : "Name can't be empty",
        onSaved: (value) => _name = value ?? '',
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate per hour'),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: true,
        ),
        onSaved: ((value) => _ratePerHour = double.tryParse(value!) ?? 0.0),
      ),
    ];
  }
}
