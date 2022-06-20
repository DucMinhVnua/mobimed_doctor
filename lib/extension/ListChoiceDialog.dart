import '../model/SelectedDialogData.dart';
import 'package:flutter/material.dart';

Future<int> showSelectionDialog(BuildContext context, String dialogTitle,
    List<SelectionDialogData> optionItems) async {
  return await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          title: Text(dialogTitle),
          children: optionItems.map((value) {
            return new SimpleDialogOption(
              onPressed: () {
//                  return completer.future;
//                  _listener.popupClickOK(value);
//                  Navigator.of(context).pop(value);
                int selectedIndex = optionItems.indexOf(value);
                Navigator.of(context).pop(selectedIndex);
//                  Navigator.pop( context,  selectedIndex); //here passing the index to be return on item selection
//                  completer.complete(value);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(
                    height: 1,
                    indent: 0,
                    endIndent: 20,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  new Text(value.itemTitle),
                  SizedBox(
                    height: 0,
                  ),
                ],
              ), //item value
            );
          }).toList(),
        );
      });
  /*  setState(() {
      _selectedCountryIndex = selected;
    });*/
}
