import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './expense.dart';

class MoneyRecorder extends StatefulWidget {
  const MoneyRecorder({Key? key}) : super(key: key);

  @override
  State<MoneyRecorder> createState() => _MoneyRecorderState();
}

class _MoneyRecorderState extends State<MoneyRecorder> {
  final storage = const FlutterSecureStorage();

  final TextEditingController _controllerSpending = TextEditingController();
  final TextEditingController _controllerCosts = TextEditingController();
  final focusNode = FocusNode();

  List<Expense> items = [];

  bool _showSpendingClear = false;
  bool _showCostsClear = false;

  @override
  void initState() {
    loadStorage();
    super.initState();

    _controllerSpending.addListener(() {
      setState(() {
        _showSpendingClear = _controllerSpending.text.isNotEmpty;
      });
    });

    _controllerCosts.addListener(() {
      setState(() {
        _showCostsClear = _controllerCosts.text.isNotEmpty;
      });
    });
  }

  void loadStorage() async {
    var expensesString = await storage.read(key: 'expenses');
    if (expensesString != null) {
      Iterable it = jsonDecode(expensesString);
      List<Expense> savedExpenses =
          List<Expense>.from(it.map((item) => Expense.fromJson(item)));
      items.addAll(savedExpenses);
    }
  }

  void _clearSpending() {
    _controllerSpending.clear();
    setState(() {});
  }

  void _clearCosts() {
    _controllerCosts.clear();
    setState(() {});
  }

  void _addSpending() async {
    setState(() {
      items.insert(
          0,
          Expense(
              name: _controllerSpending.text, value: _controllerCosts.text));
    });

    await storage.write(key: 'expenses', value: jsonEncode(items));
    debugPrint("test");
    _controllerSpending.clear();
    _controllerCosts.clear();
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 5, right: 5),
      child: Column(
        children: [
          TextField(
            controller: _controllerSpending,
            focusNode: focusNode,
            decoration: InputDecoration(
                labelText: 'Spending',
                prefixIcon: const Icon(Icons.catching_pokemon_outlined),
                suffixIcon: _clearSpendingInput(),
                border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controllerCosts,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
            ],
            decoration: InputDecoration(
              labelText: 'Costs',
              prefixIcon: const Icon(Icons.money_off),
              suffixIcon: _clearCostsInput(),
              border: const OutlineInputBorder(),
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  onPressed: !(_showCostsClear && _showSpendingClear)
                      ? null
                      : _addSpending,
                  child: const Text('Add'))),
          Expanded(
            child: SizedBox(child: _buildListView(context, items)),
          )
        ],
      ),
    );
  }

  Widget _buildListView(BuildContext context, List<Expense> items) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Dismissible(
            key: Key(item.id),
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
              }
              if (direction == DismissDirection.endToStart) {
                setState(() {
                  Expense deletedItem = items.removeAt(index);
                  storage.write(key: 'expenses', value: jsonEncode(items));
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                        content: Text('Delete "${item.name}"'),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: () {
                            setState(() => {items.insert(index, deletedItem)});
                          },
                        )));
                });
              }
            },
            background: Container(
              color: Colors.green,
              alignment: Alignment.centerLeft,
              child: const Icon(Icons.edit),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: const Icon(Icons.delete),
            ),
            child: ListTile(
              title: Text(items[index].name),
              subtitle: Text(items[index].time),
              trailing: Text('${items[index].value} €'),
            ),
          );
        });
  }

  Widget? _clearSpendingInput() {
    if (!_showSpendingClear) {
      return null;
    }

    return IconButton(icon: const Icon(Icons.clear), onPressed: _clearSpending);
  }

  Widget? _clearCostsInput() {
    if (!_showCostsClear) {
      return null;
    }

    return IconButton(icon: const Icon(Icons.clear), onPressed: _clearCosts);
  }
}
