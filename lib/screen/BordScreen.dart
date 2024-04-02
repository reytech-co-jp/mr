import 'package:flutter/material.dart';
import 'package:mr/model/DicePlan.dart';
import 'package:mr/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';

class BordScreen extends StatefulWidget {
  const BordScreen({super.key});

  @override
  State<BordScreen> createState() => _BordScreenState();
}

class _BordScreenState extends State<BordScreen> {
  Store? store;
  Box<DicePlan>? dicePlanBox;
  List<DicePlan> dicePlanList = [];

  void fetchDicePlanList() {
    dicePlanList = dicePlanBox?.getAll() ?? [];
    setState(() {});
  }

  Future<void> initialize() async {
    store = await openStore();
    dicePlanBox = store?.box<DicePlan>();
    fetchDicePlanList();
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF8E6C0),
    );
  }
}
