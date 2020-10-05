import 'package:flutter/material.dart';
import 'package:habits_tracker/repository/local/model/choose_model.dart';
import 'package:habits_tracker/ui/widgets/row_text.dart';

class SettingsChoose extends StatefulWidget {
  final int selectedItem;
  final List<ChooseModel> options;
  final Function(ChooseModel) changeValue;
  final String label;

  SettingsChoose({this.selectedItem, this.options, this.changeValue, this.label});

  @override
  _SettingsChooseState createState() => _SettingsChooseState();
}

class _SettingsChooseState<T> extends State<SettingsChoose> {

  int _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.selectedItem;
  }

  Widget _itemRow(ChooseModel data, int index) {
    return RowText(
      title: data.title,
      next: false,
      isDivider: true,
      icons: Icon(data.icon),
      iconRight: _selectedItem == data.value ? Icon(Icons.check) : Container(),
      onTap: () {
        if (_selectedItem != data.value) {
          setState(() {
            _selectedItem = data.value;
          });
          widget.changeValue(data);
        }
      },
    );
  }

  Widget get _content {
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      itemBuilder: (context, index) => _itemRow(widget.options[index], index),
      itemCount: widget.options.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).textTheme.headline6.color,
        ),
        title: Text(widget.label, style: Theme.of(context).textTheme.headline6,),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: _content,
    );
  }
}
