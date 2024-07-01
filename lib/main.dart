import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Variables(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scrollbarTheme: const ScrollbarThemeData(
            thumbColor:
                WidgetStatePropertyAll(Color.fromARGB(255, 144, 75, 64))),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 48, 0, 0),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(
              fontSize: 15,
              color: context.watch<Variables>().color == Colors.white
                  ? Colors.black
                  : Colors.white),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        return Scaffold(
          // appBar: AppBar(
          //   forceMaterialTransparency: true,
          //   // -8
          //   toolbarHeight: 2,
          // ),
          backgroundColor: context.watch<Variables>().color,
          body: const SafeArea(
            minimum: EdgeInsets.all(1),
            child: CallingTheAPI(),
          ),
        );
      }),
    );
  }
}

wakeTheApiFun({BuildContext? context}) async {
  try {
    var v = await http.get(
      Uri.parse(
        'https://fastapi-example-sfc6.onrender.com/res/test',
      ),
    );
    return v.body;
  } catch (e) {
    // print(e);
  }
}

class CallingTheAPI extends StatefulWidget {
  const CallingTheAPI({super.key});

  @override
  State<CallingTheAPI> createState() => _CallingTheAPIState();
}

class _CallingTheAPIState extends State<CallingTheAPI> {
  @override
  void initState() {
    super.initState();
    wakeTheApiFun();
  }

  @override
  Widget build(BuildContext context) {
    return ro();
  }
}

class Variables with ChangeNotifier {
  Color color = Colors.black;
  Color revcol = Colors.white;

  reversecolor() {
    color == Colors.black ? color = Colors.white : color = Colors.black;
    revcol == Colors.black ? revcol = Colors.white : revcol = Colors.black;

    notifyListeners();
  }

  Map<String, String> header = {
    'accept': 'application/json',
    'Content-Type': 'application/json'
  };

  String gs = '';
  String ys = '';
  String ds = '';
  bool gb = true;
  bool yb = true;
  bool db = true;
  bool fb = true;
  bool tb = true;

  bs(bool b, String s) {
    if (s == 'g') {
      gb = b;
    } else if (s == 'y') {
      yb = b;
    } else if (s == 'd') {
      db = b;
    } else if (s == 'f') {
      fb = b;
    } else {
      tb = b;
    }
    notifyListeners();
  }

  setFieldValue(String uri, String body, String char) async {
    if (char == 'g') {
      String s = await pos(uri, body);
      s = s.replaceAll('\\n', '\n');
      s = s.replaceAll(r'\', '');
      gs = s;
    } else if (char == 'y') {
      String s = await pos(uri, body);
      // s = s.trim();
      s = s.replaceAll('\\n', '\n');
      s = s.replaceAll('\\', '');
      ys = s;
    } else {
      String s = await pos(uri, body);
      s = s.toString();
      s = s.replaceAll('\\n', '\n');
      s = s.replaceAll('\\', '');
      ds = s;
    }
    notifyListeners();
  }

  Future pos(String uri, String body) async {
    var client = http.Client();
    try {
      final r = await client.post(Uri.parse(uri),
          headers: header, body: json.encode({"toBeTranslated": body}));
      String rs = utf8.decode(r.bodyBytes);

      if (rs.contains('Internal Server Error')) {
        return 'Too many requests, try again after a minute';
      } else {
        return rs;
      }
    } catch (e) {
      client.close();
      return "make sure you're connected to the internet";
    }
  }

  String text = '';
  settextengine() {
    setFieldValue(
        'https://fastapi-example-sfc6.onrender.com/res/g'
        // 'http://127.0.0.1:8000/res/g'
        ,
        text,
        'g');
    setFieldValue(
        'https://fastapi-example-sfc6.onrender.com/res/y'
        // 'http://127.0.0.1:8000/res/y'
        ,
        text,
        'y');
    setFieldValue(
        'https://fastapi-example-sfc6.onrender.com/res/d',
        // 'http://127.0.0.1:8000/res/d',
        text,
        'd');
  }

  String t = '';
  // setT(String s) {
  //   t = s;
  //   notifyListeners();
  // }

  String otherT = '';

  copy(String s) async {
    await Clipboard.setData(ClipboardData(text: s));
  }

  bool controlvisible = true;
  // revert() {
  //   controlvisible = !controlvisible;
  //   notifyListeners();
  // }
}

Widget dots() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5),
    child: SizedBox(
      height: null,
      width: 1,
      child: Column(
        children: List.generate(
          400 ~/ 10,
          (index) => Expanded(
            child: Builder(builder: (context) {
              return Container(
                color: index % 2 == 0
                    ? context.watch<Variables>().revcol
                    : const Color.fromARGB(0, 0, 0, 0),
                height: 1,
              );
            }),
          ),
        ),
      ),
    ),
  );
}

Widget ro() {
  return Builder(builder: (context) {
    var c = context.watch<Variables>();
    return Row(
      children: [
        Visibility(
          visible: c.controlvisible,
          child: controllpanel(),
        ),
        Visibility(visible: c.fb, child: dots()),
        Visibility(
          visible: c.fb,
          child: Expanded(
            child: colu(),
          ),
        ),
        Visibility(visible: c.gb, child: dots()),
        Visibility(
          visible: c.gb,
          child: Expanded(
            child: co(c.gs, 'G'),
          ),
        ),
        Visibility(visible: c.db, child: dots()),
        Visibility(
          visible: c.db,
          child: Expanded(
            child: co(c.ds, 'D'),
          ),
        ),
        Visibility(visible: c.yb, child: dots()),
        Visibility(
          visible: c.yb,
          child: Expanded(
            child: co(c.ys, 'Y'),
          ),
        ),
        Visibility(visible: c.tb, child: dots()),
        Visibility(
          visible: c.tb,
          child: Expanded(
            child: textfield(),
          ),
        )
      ],
    );
  });
}

controllpanel() {
  return Builder(builder: (context) {
    return Container(
      color: context.watch<Variables>().color,
      child: SizedBox(
        width: 40,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // icon(18, Icons.album_outlined, 'f'),
            Expanded(child: icon(18, FontAwesomeIcons.t, 't')),
            Expanded(child: icon(18, FontAwesomeIcons.y, 'y')),
            Expanded(child: icon(18, FontAwesomeIcons.d, 'd')),
            Expanded(child: icon(18, FontAwesomeIcons.g, 'g')),
            Expanded(child: icon(18, FontAwesomeIcons.f, 'f')),
            Expanded(
              child: IconButton(
                onPressed: () => context.read<Variables>().reversecolor(),
                icon: Icon(
                  color: context.watch<Variables>().revcol,
                  Icons.sunny,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  });
}

Widget co(String s, String brand) {
  return Builder(
    builder: (context) {
      return GestureDetector(
        // onTap: () async {
        //   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        //   await Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => secondscreen(s),
        //     ),
        //   );
        //   SystemChrome.setPreferredOrientations(
        //     [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft],
        //   );
        // },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 30),
                  child: SelectableText(
                    style: Theme.of(context).textTheme.bodyMedium,
                    s,
                  ),
                ), // const TextStyle( fontSize: 14),
              ),
            ),
            bottomshit(s, brand),
          ],
        ),
      );
    },
  );
}

Widget textfield() {
  return Builder(builder: (context) {
    return Column(
      children: [
        Expanded(
          child: TextField(
            controller: TextEditingController()
              ..text = context.watch<Variables>().otherT,
            decoration:
                const InputDecoration(contentPadding: EdgeInsets.all(8)),
            onChanged: (value) {
              context.read<Variables>().otherT = value;
            },
            style: TextStyle(
                color: context.watch<Variables>().revcol, fontSize: 14),
            expands: true,
            maxLines: null,
          ),
        ),
        bottomshit(context.watch<Variables>().t, ''),
      ],
    );
  });
}

Widget bottomshit(String s, String brand) {
  return Padding(
    padding: const EdgeInsets.only(top: 0, bottom: 2),
    child: Builder(builder: (context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () {
                context.read<Variables>().copy(s);
              },
              icon: Icon(
                Icons.copy,
                color: Theme.of(context).primaryColor,
              )),
          Builder(builder: (context) {
            return Text(
              brand,
              style: TextStyle(
                fontSize: 30,
                color: context.watch<Variables>().revcol,
              ),
            );
          }),
        ],
      );
    }),
  );
}

Widget colu() {
  return Builder(builder: (context) {
    return Column(
      children: [
        Expanded(
          flex: 10,
          child: field(),
        ),
        bottom(),
      ],
    );
  });
}

Widget bottom() {
  return Builder(builder: (context) {
    return Card(
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(1),
      ),
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // arrowbutton(),
          Expanded(
            child: IconButton(
                onPressed: () {
                  context.read<Variables>().settextengine();
                },
                icon: const Icon(
                  Icons.check,
                  size: 27,
                  color: Colors.white,
                )),
          )
        ],
      ),
    );
  });
}

Widget arrowbutton() {
  return Expanded(
    child: Builder(builder: (context) {
      return IconButton(
          onPressed: () {
            // context.read<Variables>().revert();
          },
          icon: Icon(
            context.watch<Variables>().controlvisible
                ? Icons.arrow_left_rounded
                : Icons.arrow_right_rounded,
            size: 27,
            color: Colors.white,
          ));
    }),
  );
}

Widget field() {
  return Builder(builder: (context) {
    return TextField(
      controller: TextEditingController()
        ..text = context.watch<Variables>().text,
      decoration: const InputDecoration(contentPadding: EdgeInsets.all(8)),
      onChanged: (value) => context.read<Variables>().text = value,
      style: TextStyle(color: context.watch<Variables>().revcol, fontSize: 13),
      expands: true,
      maxLines: null,
    );
  });
}

Widget icon(double size, IconData icon, String s) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Builder(builder: (context) {
          return FaIcon(
            color: context.watch<Variables>().revcol,
            icon,
            size: 15,
          );
        }),
        Expanded(
          flex: -100,
          child: Builder(builder: (context) {
            var c = context.watch<Variables>();
            bool b;
            if (s == 'g') {
              b = c.gb;
            } else if (s == 'y') {
              b = c.yb;
            } else if (s == 'd') {
              b = c.db;
            } else if (s == 'f') {
              b = c.fb;
            } else {
              b = c.tb;
            }
            return Transform.rotate(
              angle: 180,
              child: Transform.scale(
                alignment: Alignment.centerLeft,
                scale: .6,
                child: Switch(
                  thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                      (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return const Icon(
                        Icons.close,
                        color: Color.fromARGB(255, 0, 0, 0),
                      );
                    }
                    return null; // All other states will use the default thumbIcon.
                  }),
                  value: b,
                  onChanged: (value) {
                    if (b == true) {
                      c.bs(false, s);
                    } else {
                      c.bs(true, s);
                    }
                  },
                ),
              ),
            );
          }),
        ),
      ],
    ),
  );
}
