import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/models/job.dart';

class JobListTile extends StatelessWidget {
  final Job job;
  final VoidCallback? onTap;

  const JobListTile({super.key, required this.job, this.onTap});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
