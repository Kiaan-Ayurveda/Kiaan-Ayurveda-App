import 'package:flutter/material.dart';

import '../../controllers/bills.dart';
import '../../models/bill.dart';
import '../pages.dart';
import '../widgets/bill_card.dart';

class HomePage extends StatefulWidget {
  static const String route = '/home';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<KiaanAyurvedaBill> bills = [];

  @override
  void initState() {
    super.initState();
    getBills();
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    getBills();
  }

  void getBills() async {
    setState(() {
      isLoading = true;
    });

    final List<KiaanAyurvedaBill>? _bills = await BillsController.getBills();
    if (_bills != null) {
      setState(() {
        bills = _bills;
        isLoading = false;
      });

      return;
    }

    setState(() {
      isLoading = false;
    });

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to fetch bills'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: const Text(
          'Kiaan Ayurveda - Bills',
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Pages.editBill).then((value) {
                getBills();
              });
            },
            heroTag: null,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              getBills();
            },
            heroTag: null,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          getBills();
        },
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        ' Invoices',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: bills.length,
                        itemBuilder: (BuildContext context, int index) {
                          final KiaanAyurvedaBill bill = bills[index];
                          return BillCard(
                              index: index, bill: bill, getBills: getBills);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 12);
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
