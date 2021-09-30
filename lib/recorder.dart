import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoneyRecorder extends StatefulWidget {
  const MoneyRecorder({Key? key}) : super(key: key);

  @override
  State<MoneyRecorder> createState() => _MoneyRecorderState();
}

class _MoneyRecorderState extends State<MoneyRecorder> {
  final TextEditingController _controller = TextEditingController();
  bool _showAdd = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _showAdd = _controller.text.isNotEmpty;
      });
    });
  }

  void _addMoney() {
    debugPrint(_controller.text);
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 5, right: 5),
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
          labelText: 'Spend Money',
          prefixIcon: const Icon(Icons.money_off),
          suffixIcon: _addButton(),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget? _addButton() {
    if (!_showAdd) {
      return null;
    }

    return IconButton(icon: const Icon(Icons.add), onPressed: _addMoney);
  }
}
