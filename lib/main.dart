import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

void main() => runApp(App());

// via https://stackoverflow.com/questions/49874272/how-to-navigate-to-other-page-without-animation-flutter/
class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          maintainState: maintainState,
          settings: settings,
          fullscreenDialog: fullscreenDialog,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      initialRoute: FirstScreen.routeName,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case FirstScreen.routeName:
            return NoAnimationMaterialPageRoute(
              builder: (_) => FirstScreen(),
            );
          case SecondScreen.routeName:
            return NoAnimationMaterialPageRoute(
              builder: (_) => SecondScreen(),
            );
          case ThirdScreen.routeName:
            return MaterialPageRoute(
              builder: (_) => ThirdScreen(),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
            );
        }
      },
    );
  }
}

class BottomNavigation extends StatelessWidget {
  final int currentIndex;

  BottomNavigation({
    Key key,
    @required this.currentIndex,
  }) : super(key: key);

  final List<String> routes = [
    FirstScreen.routeName,
    SecondScreen.routeName,
    ThirdScreen.routeName,
  ];

  Widget _build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: this.currentIndex,
      onTap: (int nextIndex) {
        Navigator.pushNamed(context, routes[nextIndex]);
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('First'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          title: Text('Second'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          title: Text('Third (full)'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }
}

class FirstScreen extends StatelessWidget {
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Go to second'),
          onPressed: () {
            Navigator.pushNamed(context, SecondScreen.routeName);
          },
        ),
      ),
      bottomNavigationBar: BottomNavigation(currentIndex: 0),
    );
  }
}

class SecondScreen extends StatelessWidget {
  static const String routeName = '/second';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: RaisedButton(
              child: Text('Go to third'),
              onPressed: () {
                Navigator.pushNamed(context, ThirdScreen.routeName);
              },
            ),
          ),
          Center(
            child: RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go back!'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(currentIndex: 1),
    );
  }
}

class ThirdScreen extends StatelessWidget {
  static const String routeName = '/third';

  @override
  Widget build(BuildContext context) {
    // no AppBar and BottomNavigation
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
