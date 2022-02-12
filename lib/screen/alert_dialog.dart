import 'package:flutter/material.dart';

enum AlertDialogType {
  success,
  error,
  warning,
  info,
}

class CustomAlertDialog extends StatelessWidget {
  final AlertDialogType type;
  final String title;
  final String content;
  final String buttonLabel;
  final TextStyle titleStyle = const TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold);

  const CustomAlertDialog(
      {Key? key,
      this.title = "Successful",
      required this.content,
      this.type = AlertDialogType.info,
      this.buttonLabel = "OK"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
          alignment: Alignment.center,
          child: Container(
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 10.0),
                Icon(
                  _getIconForType(type),
                  color: _getColorForType(type),
                  size: 50,
                ),
                const SizedBox(height: 10.0),
                Text(
                  title.toUpperCase(),
                  style: titleStyle,
                  textAlign: TextAlign.center,
                ),
                const Divider(),
                Text(
                  content,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    //padding: const EdgeInsets.all(5.0),
                    child: Text(
                      buttonLabel,
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  IconData _getIconForType(AlertDialogType type) {
    switch (type) {
      case AlertDialogType.warning:
        return Icons.warning;
      case AlertDialogType.success:
        return Icons.check_circle;
      case AlertDialogType.error:
        return Icons.error;
      case AlertDialogType.info:
      default:
        return Icons.info_outline;
    }
  }

  Color _getColorForType(AlertDialogType type) {
    switch (type) {
      case AlertDialogType.warning:
        return Colors.orange;
      case AlertDialogType.success:
        return Colors.green;
      case AlertDialogType.error:
        return Colors.red;
      case AlertDialogType.info:
      default:
        return Colors.blue;
    }
  }
}

class BeautifulAlertDialog extends StatelessWidget {
  final String title;

  const BeautifulAlertDialog({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.only(right: 16.0),
          height: 150,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(75),
                  bottomLeft: Radius.circular(75),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 20.0),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(
                  Icons.help,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Pytanie",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(height: 10.0),
                    Flexible(
                      child: Text(title),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            child: const Text("NIE"),
                            //color: Colors.red,
                            //colorBrightness: Brightness.dark,
                            onPressed: () {
                              Navigator.pop(context, 'Mo');
                            },
                            //shape: RoundedRectangleBorder(
                            //    borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: ElevatedButton(
                            child: const Text("TAK"),
                            //color: Colors.green,
                            //colorBrightness: Brightness.dark,
                            onPressed: () {
                              Navigator.pop(context, 'Yes');
                            },
                            //shape: RoundedRectangleBorder(
                            //    borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<String> alertDialogYesNo(BuildContext context, String title) async {
  final result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return BeautifulAlertDialog(
        title: title,
      );
    },
  );
  return result;
}
