import 'package:flutter/material.dart';

/// The controller that holds the state of the cart.
class PanierCoffeController extends StatefulWidget {
  final Widget child;

  const PanierCoffeController({Key? key, required this.child}) : super(key: key);

  @override
  _PanierCoffeControllerState createState() => _PanierCoffeControllerState();

  static _PanierCoffeControllerState of(BuildContext context) {
    final inheritedWidget = context.dependOnInheritedWidgetOfExactType<_InheritedPanierCoffeController>();
    if (inheritedWidget == null) {
      throw FlutterError('PanierCoffeController.of() called with a context that does not contain a PanierCoffeController.');
    }
    return inheritedWidget.state;
  }

  static void addOrder(BuildContext context, Map<String, dynamic> orderInfo) {
    final _PanierCoffeControllerState? state = of(context);
    if (state != null) {
      state.addOrder(orderInfo);
      print('Paaaaaaaaaaaaaaaaaaaaaaaaaaaaal');
    } else {
      print('PanierCoffeController state is null');
      // Gérer le cas où le contrôleur n'est pas trouvé
    }
  }
}

/// Private class to hold the state and expose it through context.
class _PanierCoffeControllerState extends State<PanierCoffeController> {
  List<Map<String, dynamic>> orders = [];

  void addOrder(Map<String, dynamic> orderInfo) {
    setState(() {
      orders.add(orderInfo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedPanierCoffeController(
      state: this,
      child: widget.child,
    );
  }
}

/// Inherited widget to propagate the controller state down the widget tree.
class _InheritedPanierCoffeController extends InheritedWidget {
  final _PanierCoffeControllerState state;

  _InheritedPanierCoffeController({
    Key? key,
    required Widget child,
    required this.state,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_InheritedPanierCoffeController oldWidget) {
    return true;
  }

  static _PanierCoffeControllerState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedPanierCoffeController>()?.state;
  }
}
