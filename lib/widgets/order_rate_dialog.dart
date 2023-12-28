import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mechanic/models/order.dart';
import 'package:mechanic/providers/controller.dart';

class OrderRateDialog extends StatefulWidget {
  Order order ;

  OrderRateDialog(this.order, {super.key});

  @override
  _OrderRateDialogState createState() => _OrderRateDialogState();
}

class _OrderRateDialogState extends State<OrderRateDialog> {
  final Controller _controller = Controller();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rate Your Order'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('How would you rate your order?'),
          const SizedBox(height: 16.0),
          RatingBar.builder(
            initialRating: widget.order.rate,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 40.0,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                widget.order.rate = rating;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Handle the submitted rating
            debugPrint('Rated: ${widget.order.rate}');
            _controller.rateOrder(widget.order);
            Navigator.of(context).pop(); // Close the dialog
            setState(() {

            });
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}


