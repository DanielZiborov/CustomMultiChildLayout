import 'package:flutter/material.dart';

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.blue,
        child: CustomMultiChildLayout(
          delegate: OwnMultiChildLayoutDelegate(),
          children: [
            LayoutId(
              id: 1,
              child: const Text('left'),
            ),
            LayoutId(
              id: 2,
              child: const Text("middle"),
            ),
            LayoutId(
              id: 3,
              child:  const Text(
                "right",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OwnMultiChildLayoutDelegate extends MultiChildLayoutDelegate {
  @override
  Size getSize(BoxConstraints constraints) =>
      Size(constraints.biggest.width, 100);

  @override
  void performLayout(Size size) {
    if (hasChild(1) && hasChild(2) && hasChild(3)) {
      final minOtherElementWidth = 52;

      final firstElementMaxWidth = size.width - 2 * minOtherElementWidth;

      final thirdElementMaxWidth =
          size.width - firstElementMaxWidth - minOtherElementWidth;

      final secondElementMaxWidth =
          size.width - firstElementMaxWidth - thirdElementMaxWidth;

      final firstElementSize = layoutChild(
          1,
          BoxConstraints.loose(
            Size(firstElementMaxWidth, size.height),
          ));
      final secondElementSize = layoutChild(
        2,
        BoxConstraints.loose(Size(secondElementMaxWidth, size.height)),
      );
      final thirdElementSize = layoutChild(
        3,
        BoxConstraints.loose(Size(thirdElementMaxWidth, size.height)),
      );

      final firstElementYOffset = size.height/2 - firstElementSize.height/2;
      positionChild(1, Offset(0, firstElementYOffset));

      final thirdElementYOffset = size.height/2 - thirdElementSize.height/2;
      final thirdElementXOffset = size.width - thirdElementSize.width; 
      positionChild(3, Offset(thirdElementXOffset, thirdElementYOffset));

      final secondElementYOffset = size.height/2 - secondElementSize.height/2;
      var secondElementXOffset = size.width/2 - secondElementSize.width/2;
      if(firstElementSize.width > secondElementXOffset) {
        secondElementXOffset = firstElementSize.width;
      }else if(thirdElementXOffset < secondElementXOffset + secondElementSize.width){
        secondElementXOffset = thirdElementXOffset - thirdElementSize.width;
      }
      positionChild(2, Offset(secondElementXOffset, secondElementYOffset));
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}
