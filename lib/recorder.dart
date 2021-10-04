import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoneyRecorder extends StatefulWidget {
  const MoneyRecorder({Key? key}) : super(key: key);

  @override
  State<MoneyRecorder> createState() => _MoneyRecorderState();
}

class _MoneyRecorderState extends State<MoneyRecorder> {
  final TextEditingController _controllerSpending = TextEditingController();
  final TextEditingController _controllerCosts = TextEditingController();
  bool _showSpendingClear = false;
  bool _showCostsClear = false;

  @override
  void initState() {
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

  void _clearSpending() {
    debugPrint('clear spending');
    _controllerSpending.clear();
    setState(() {});
  }

  void _clearCosts() {
    debugPrint('clear costs');
    _controllerCosts.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 5, right: 5),
      child: Column(
        children: [
          TextField(
            controller: _controllerSpending,
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
              FilteringTextInputFormatter.digitsOnly
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
            child: SizedBox(
              child: ListView(
                children: const [
                  ListTile(
                    title: Text('Banana'),
                    subtitle: Text('01-12-2022'),
                    trailing: Text('2 €'),
                  ),
                  ListTile(
                    title: Text('Jetski'),
                    subtitle: Text('01-09-2022'),
                    trailing: Text('1999 €'),
                  ),
                  ListTile(
                    title: Text('Tesla'),
                    subtitle: Text('01-05-2022'),
                    trailing: Text('30000 €'),
                  ),
                  ListTile(
                    title: Text('More banana'),
                    subtitle: Text('01-01-2022'),
                    trailing: Text('20 €'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
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

  Function? _addSpending() {
    debugPrint('Add spending: ' +
        _controllerSpending.text +
        ' ' +
        _controllerCosts.text);
  }
}
