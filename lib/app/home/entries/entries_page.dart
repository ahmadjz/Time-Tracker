import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/entries/entries_bloc.dart';
import 'package:time_tracker/app/home/entries/entries_list_tile.dart';
import 'package:time_tracker/app/home/jobs/list_items_builder.dart';
import 'package:time_tracker/services/database.dart';

class EntriesPage extends StatelessWidget {
  const EntriesPage({super.key});

  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Provider<EntriesBloc>(
      create: (_) => EntriesBloc(database: database),
      child: const EntriesPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entries'),
        elevation: 2.0,
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final bloc = Provider.of<EntriesBloc>(context);
    return StreamBuilder<List<EntriesListTileModel>>(
      stream: bloc.entriesTileModelStream,
      builder: (context, snapshot) {
        return ListItemsBuilder<EntriesListTileModel>(
          snapshot: snapshot,
          itemBuilder: (context, model) => EntriesListTile(model: model),
        );
      },
    );
  }
}
