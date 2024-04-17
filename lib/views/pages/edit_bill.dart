import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../controllers/bills.dart';
import '../../models/bill.dart';
import '../pages.dart';
import '../widgets/text_field.dart';
import '../widgets/wrapper.dart';

final DateFormat _dateFormat = DateFormat("dd/MM/yyyy");

class EditBillPage extends StatefulWidget {
  static const String route = '/edit-bill';

  final KiaanAyurvedaBill? bill;

  const EditBillPage({Key? key, this.bill}) : super(key: key);

  @override
  State<EditBillPage> createState() => _EditBillPageState();
}

class _EditBillPageState extends State<EditBillPage> {
  late KiaanAyurvedaBill? _bill;

  late TextEditingController _invoiceNoController;
  late DateTime _invoiceDate;
  bool _isGST = false;
  late TextEditingController _toController;
  late TextEditingController _toAddressController;
  late TextEditingController _toGSTINController;
  late TextEditingController _toEmailController;

  late List<KiaanAyurvedaBillItem> _items;

  @override
  void initState() {
    super.initState();

    _bill = widget.bill;

    initVars(_bill);
  }

  void initVars(
    KiaanAyurvedaBill? bill,
  ) {
    _invoiceNoController = TextEditingController(
      text: bill != null
          ? bill.invoiceNo
          : BillsController.newBillNo != null
              ? BillsController.newBillNo.toString()
              : '',
    );
    _invoiceDate =
        bill != null ? _dateFormat.parse(bill.invoiceDate) : DateTime.now();
    _toController = TextEditingController(
      text: bill != null ? bill.to : '',
    );
    _toAddressController = TextEditingController(
      text: bill != null ? bill.toAddress : '',
    );
    _toGSTINController = TextEditingController(
      text: bill != null ? bill.toGst ?? '' : '',
    );
    _toEmailController = TextEditingController(
      text: bill != null ? bill.toEmail ?? '' : '',
    );

    _items = bill != null ? bill.items : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        foregroundColor: Colors.black,
        title: Text(
          _bill == null
              ? 'New Invoice'
              : 'Edit Inovice No: ${_bill?.invoiceNo}',
        ),
        actions: [
          IconButton(
            onPressed: () {
              _bill == null ? _onCreate() : _onUpdate();
            },
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: () async {
              _bill == null ? await _onCreate() : await _onUpdate();

              Navigator.pushNamed(
                context,
                Pages.previewBill,
                arguments: {
                  'bill': _bill,
                },
              );
            },
            icon: const Icon(Icons.print),
          ),
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Invoice'),
                    content: const Text(
                        'Are you sure you want to delete this invoice?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (_bill == null) {
                            Navigator.pop(context);
                            return;
                          }

                          bool isDeleted =
                              await BillsController.deleteBill(_bill!.id!);

                          if (isDeleted) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to delete bill'),
                              ),
                            );
                          }
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildBillInfoField(),
              _buildIsGSTField(),
              _buildToField(),
              _buildItemsField(),
              _buildTotalField(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBillInfoField() {
    return Wrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Invoice Info",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          MyTextField(
            hintText: "Invoice No",
            controller: _invoiceNoController,
            keyboardType: TextInputType.number,
          ),
          MyTextField(
            hintText: "Date",
            controller: TextEditingController(
              text: _dateFormat.format(_invoiceDate),
            ),
            onTap: () {
              _showDatePicker(_invoiceDate, (pickedDate) {
                setState(() {
                  _invoiceDate = pickedDate;
                });
              });
            },
            suffixIcon: IconButton(
              onPressed: () {
                _showDatePicker(_invoiceDate, (pickedDate) {
                  setState(() {
                    _invoiceDate = pickedDate;
                  });
                });
              },
              icon: const Icon(Icons.calendar_today),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIsGSTField() {
    return Wrapper(
      child: Row(
        children: [
          Checkbox(
            value: _isGST,
            onChanged: (value) {
              setState(() {
                _isGST = value!;
              });
            },
          ),
          const SizedBox(width: 5),
          const Text(
            "Is GST Invoice",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToField() {
    return Wrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "To",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          MyTextField(
            hintText: "To company",
            controller: _toController,
            keyboardType: TextInputType.text,
            isAutoComplete: true,
            suggestions: BillsController.toList,
            onSuggestionSelected: (value) {
              _toController.text = value;
              _toAddressController.text = BillsController
                  .toAddressList[BillsController.toList.indexOf(value)];
              _toGSTINController.text = BillsController
                  .toGstList[BillsController.toList.indexOf(value)];
              _toEmailController.text = BillsController
                  .toEmailList[BillsController.toList.indexOf(value)];
            },
          ),
          MyTextField(
            hintText: "Address",
            controller: _toAddressController,
            keyboardType: TextInputType.multiline,
            maxLines: 2,
          ),
          MyTextField(
            hintText: "GSTIN",
            controller: _toGSTINController,
            keyboardType: TextInputType.text,
          ),
          MyTextField(
            hintText: "Email",
            controller: _toEmailController,
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildItemField(KiaanAyurvedaBillItem item, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              "Item $index",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_items.length > 1) ...[
              const Spacer(),
              IconButton(
                onPressed: () {
                  setState(() {
                    _items.removeAt(index - 1);
                  });
                },
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ],
        ),
        MyTextField(
          hintText: "Description",
          controller: TextEditingController(text: item.description),
          keyboardType: TextInputType.text,
          onChanged: (value) {
            _items[index - 1].description = value;
          },
        ),
        if (_isGST)
          MyTextField(
            hintText: "HSN/SAC Code",
            controller: TextEditingController(text: item.hsnSac),
            keyboardType: TextInputType.text,
            onChanged: (value) {
              _items[index - 1].hsnSac = value;
            },
          ),
        MyTextField(
          hintText: "Quantity",
          controller: TextEditingController(
              text: item.quantity != null ? item.quantity.toString() : ''),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            _items[index - 1].quantity = int.tryParse(value);
          },
          onEditingComplete: () {
            setState(() {});
          },
        ),
        MyTextField(
          hintText: "Rate/Unit",
          controller: TextEditingController(
              text: item.rate != null ? item.rate.toString() : ''),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            _items[index - 1].rate = double.tryParse(value);
          },
          onEditingComplete: () {
            setState(() {});
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildItemsField() {
    return Wrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Items",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          for (int i = 0; i < _items.length; i++)
            _buildItemField(_items[i], i + 1),
          // Add new item
          Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _items.add(KiaanAyurvedaBillItem());
                });
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  "Add Item",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.grey,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalField() {
    return Wrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Total",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          MyTextField(
            hintText: "Total",
            readOnly: true,
            initialValue: _items
                .fold(0, (prev, item) => prev + item.amount.toInt())
                .toString(),
          ),
          if (_isGST) ...[
            MyTextField(
              hintText: "CGST",
              readOnly: true,
              initialValue: _bill != null ? _bill!.cgstInRupees : 0.toString(),
            ),
            MyTextField(
              hintText: "SGST",
              readOnly: true,
              initialValue: _bill != null ? _bill!.cgstInRupees : 0.toString(),
            ),
            MyTextField(
              hintText: "Total Tax",
              readOnly: true,
              initialValue:
                  _bill != null ? _bill!.totalTaxInRupees : 0.toString(),
            ),
            MyTextField(
              hintText: "Grand Total",
              readOnly: true,
              initialValue:
                  _bill != null ? _bill!.grandTotalInRupees : 0.toString(),
            ),
          ],
        ],
      ),
    );
  }

  void _showDatePicker(
    DateTime? initialDate,
    void Function(DateTime) onDateSelected,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1000)),
      lastDate: DateTime.now().add(const Duration(days: 1000)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorConstants.primary,
              onPrimary: Colors.white,
              surface: ColorConstants.bg,
              onSurface: ColorConstants.primary,
            ),
            dialogBackgroundColor: ColorConstants.bg,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }

  Future<void> _onCreate() async {
    _items.removeWhere((item) => item.description == null);
    _items.removeWhere((item) => item.description?.trim() == '');
    _items.removeWhere((item) => item.quantity == 0);
    _items.removeWhere((item) => item.rate == 0);

    for (int i = 0; i < _items.length; i++) {
      if (_items[i].quantity == null) {
        _items[i].quantity = 0;
      }
      if (_items[i].rate == null) {
        _items[i].rate = 0;
      }
    }

    KiaanAyurvedaBill newBill = KiaanAyurvedaBill(
      invoiceNo: _invoiceNoController.text,
      invoiceDate: _dateFormat.format(_invoiceDate),
      isGstBill: _isGST,
      to: _toController.text,
      toAddress: _toAddressController.text,
      toGst: _toGSTINController.text != '' ? _toGSTINController.text : null,
      toEmail: _toEmailController.text != '' ? _toEmailController.text : null,
      items: _items,
    );

    KiaanAyurvedaBill? newBillCreated =
        await BillsController.createBill(newBill);

    if (newBillCreated != null) {
      setState(() {
        _bill = newBillCreated;
        initVars(_bill);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New bill created'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create new bill'),
        ),
      );
    }
  }

  Future<void> _onUpdate() async {
    _items.removeWhere((item) => item.description == null);
    _items.removeWhere((item) => item.description?.trim() == '');
    _items.removeWhere((item) => item.quantity == 0);
    _items.removeWhere((item) => item.rate == 0);

    for (int i = 0; i < _items.length; i++) {
      if (_items[i].quantity == null) {
        _items[i].quantity = 0;
      }
      if (_items[i].rate == null) {
        _items[i].rate = 0;
      }
    }

    KiaanAyurvedaBill updatedBill = KiaanAyurvedaBill(
      id: _bill?.id,
      invoiceNo: _invoiceNoController.text,
      invoiceDate: _dateFormat.format(_invoiceDate),
      isGstBill: _isGST,
      to: _toController.text,
      toAddress: _toAddressController.text,
      toGst: _toGSTINController.text != '' ? _toGSTINController.text : null,
      toEmail: _toEmailController.text != '' ? _toEmailController.text : null,
      items: _items,
    );

    KiaanAyurvedaBill? updatedBillCreated =
        await BillsController.updateBill(updatedBill);

    if (updatedBillCreated != null) {
      setState(() {
        _bill = updatedBillCreated;
        initVars(_bill);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bill updated'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update bill'),
        ),
      );
    }
  }
}
