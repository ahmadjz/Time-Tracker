import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker/services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key? key, required this.database, this.job})
      : super(key: key);

  final Database database;
  final Job? job;

  static Future<void> show(BuildContext context,
      {required Database database, Job? job}) async {
    await Navigator.of(
      context,
      rootNavigator: true,
    ).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(
          job: job,
          database: database,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<EditJobPage> createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final FocusNode _jobNameFocusNode = FocusNode();
  final FocusNode _ratePerHourFocusNode = FocusNode();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String? _name;
  int? _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job!.name;
      _ratePerHour = widget.job!.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _jobNameEditingComplete() {
    FocusScope.of(context).requestFocus(_ratePerHourFocusNode);
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        setState(() {
          _isLoading = true;
        });
        final jobs = await widget.database
            .jobsStream()
            .first; // .first is to use stream is future
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job!.name);
        }
        if (allNames.contains(_name)) {
          const PlatformAlertDialog(
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(id: id, name: _name!, ratePerHour: _ratePerHour!);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseAuthException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _jobNameFocusNode.dispose();
    _ratePerHourFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job != null ? "Edit Job" : "New Job"),
        actions: <Widget>[
          TextButton(
            onPressed: _submit,
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
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
        decoration: const InputDecoration(labelText: 'Job name'),
        initialValue: _name,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
        focusNode: _jobNameFocusNode,
        onEditingComplete: _jobNameEditingComplete,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Rate per hour'),
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        validator: (value) =>
            value!.isNotEmpty ? null : 'Password can\'t be empty',
        keyboardType: const TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) {
          if (value == null) {
            _ratePerHour = 0;
          } else {
            _ratePerHour = int.tryParse(value);
          }
        },
        focusNode: _ratePerHourFocusNode,
        onEditingComplete: _submit,
      ),
    ];
  }
}
