import 'package:fixme/widgets/custombuttons.dart';
import 'package:flutter/material.dart';

class ButtonGrid extends StatelessWidget {
  const ButtonGrid({Key key, @required this.onTap}) : super(key: key);
  final ConverterButtonTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(maxHeight: 355),
          child: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 1.08,
            padding: const EdgeInsets.only(left: 35, right: 35),
            mainAxisSpacing: 5,
            crossAxisSpacing: 15,
            children: <Widget>[
              CustomButton(
                text: '1',
                onTap: onTap,
              ),
              CustomButton(
                text: '2',
                onTap: onTap,
              ),
              CustomButton(
                text: '3',
                onTap: onTap,
              ),
              CustomButton(
                text: '4',
                onTap: onTap,
              ),
              CustomButton(
                text: '5',
                onTap: onTap,
              ),
              CustomButton(
                text: '6',
                onTap: onTap,
              ),
              CustomButton(
                text: '7',
                onTap: onTap,
              ),
              CustomButton(
                text: '8',
                onTap: onTap,
              ),
              CustomButton(
                text: '9',
                onTap: onTap,
              ),
              CustomButton(
                onTap: onTap,
                isClear: true,
              ),
              CustomButton(
                text: '0',
                onTap: onTap,
              ),
              CustomButton(
                onTap: onTap,
                isEqual: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
