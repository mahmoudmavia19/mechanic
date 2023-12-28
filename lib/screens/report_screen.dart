import 'package:flutter/material.dart';
import 'package:mechanic/providers/controller.dart';
import 'package:mechanic/utils/app_strings.dart';
import 'package:mechanic/utils/state_renderer/state_renderer_impl.dart';
import 'package:mechanic/widgets/custombtn.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController _reportTextController = TextEditingController();
  final Controller _controller = Controller() ;
  // Function to handle report submission
  void _submitReport() {
    final String reportText = _reportTextController.text.trim();
    if (reportText.isNotEmpty) {
     _controller.sendReportToSupervisor(_reportTextController.text);
      _reportTextController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.reportTitle),
      ),
      body: StreamBuilder<FlowState>(
        stream: _controller.sendReportStateCo.stream,
        builder: (context, snapshot) => snapshot.data?.getScreenWidget(context, _body(), (){})??_body(),)
    );
  }

  _body()=> SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          AppString.complaintDetails,
          style: TextStyle(fontSize: 16.0),
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _reportTextController,
          maxLines: 6,
          decoration: const InputDecoration(
            hintText: AppString.discIsu,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16.0),
        CustomBTN(text: AppString.sendButton, onPressed: () {
          _submitReport();
        },)
      ],
    ),
  );

  @override
  void dispose() {
    // Dispose of the controller when the screen is no longer in use
    _reportTextController.dispose();
    super.dispose();
  }
}
