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

wakeTheApiFun({BuildContext? context}) async {
  var v = await http.get(
    Uri.parse(
      'https://fastapi-example-sfc6.onrender.com/res/test',
    ),
  );
  return v.body;
  //  v.body;
  // ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(
  //     content: SizedBox(
  //       child: Text(v.body),
  //     ),
  //   ),
  // );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: true,
      home: Scaffold(
        // appBar: AppBar(
        //   forceMaterialTransparency: true,
        //   // -8
        //   toolbarHeight: 2,
        // ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          minimum: EdgeInsets.all(1),
          child: CallingTheAPI(),
        ),
      ),
    );
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
  Map<String, String> header = {
    'accept': 'application/json',
    'Content-Type': 'application/json'
  };

  String gs = '';
  String ys = '';
  String ds = '';
  bool gb = false;
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
      ys = s.replaceAll('\\n', '\n');
    } else {
      String s = await pos(uri, body);
      ds = s.replaceAll('\\n', '\n');
    }
    notifyListeners();
  }

  Future pos(String uri, String body) async {
    final g = await http.post(Uri.parse(uri),
        headers: header, body: json.encode({"toBeTranslated": body.trim()}));
    return g.body;
  }

  // late double off;
  // // var cont = ScrollController();

  // sp(double offest) {
  //   off = offest;
  //   // cont.animateTo(off, duration: Durations.short1, curve: Curves.bounceIn);
  //   // notifyListeners();
  // }

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
        'https://fastapi-example-sfc6.onrender.com/res/d'
        // 'http://127.0.0.1:8000/res/d'
        ,
        text,
        'd');
  }

  String t = '';
  setT(String s) {
    t = s;
    notifyListeners();
  }

  copy(String s) async {
    await Clipboard.setData(ClipboardData(text: s));
  }
}

Widget ro() {
  return Builder(builder: (context) {
    var c = context.watch<Variables>();
    return Row(
      children: [
        Expanded(
          child: colu(),
        ),
        Visibility(
          visible: c.gb,
          child: Expanded(
            child: co(c.gs, 'G'),
          ),
        ),
        Visibility(
          visible: c.db,
          child: Expanded(
            child: co(c.ds, 'D'),
          ),
        ),
        Visibility(
          visible: c.yb,
          child: Expanded(
            child: co(c.ys, 'Y'),
          ),
        ),
        Visibility(
          visible: c.tb,
          child: textfield(),
        )
      ],
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
              child: Card(
                color: const Color.fromARGB(255, 65, 60, 40),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 30),
                      child: SelectableText(
                        // selectionColor: Colors.blue,
                        style: const TextStyle(color: Colors.white),
                        s,
                      ),
                    ),
                  ],
                ),
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
  return Expanded(
    child: Builder(builder: (context) {
      return Column(
        children: [
          Expanded(
            child: Card(
              color: const Color.fromARGB(255, 0, 0, 0),
              child: TextField(
                onChanged: (value) {
                  context.read<Variables>().setT(value);
                },
                style: const TextStyle(color: Colors.white),
                expands: true,
                maxLines: null,
              ),
            ),
          ),
          Builder(builder: (context) {
            return bottomshit(context.watch<Variables>().t, '');
          }),
        ],
      );
    }),
  );
}

Widget bottomshit(String s, String brand) {
  return Padding(
    padding: const EdgeInsets.only(top: 0, bottom: 2),
    child: Card(
      color: const Color.fromARGB(255, 211, 243, 175),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      child: Builder(builder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  context.read<Variables>().copy(s);
                },
                icon: const Icon(Icons.copy)),
            Text(
              brand,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ],
        );
      }),
    ),
  );
}

Widget colu() {
  return Column(
    children: [
      Expanded(
        flex: 10,
        child: Builder(builder: (context) {
          return Visibility(
              visible: context.watch<Variables>().fb, child: field());
        }),
      ),
      bottom(),
    ],
  );
}

Widget bottom() {
  return Builder(builder: (context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
            onPressed: () {
              showBottomSheet(
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
                context: context,
                builder: (context) {
                  return SizedBox(
                    child: controll(),
                  );
                },
              );
            },
            icon: const Icon(Icons.arrow_drop_up_rounded)),
        IconButton(
            onPressed: () {
              context.read<Variables>().settextengine();
            },
            icon: const Icon(Icons.check))
      ],
    );
  });
}

Widget controll() {
  return SizedBox(
    height: 79,
    width: 200,
    child: Card(
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(2),
      ),
      child: Row(
        children: [
          Builder(builder: (context) {
            return IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_drop_down_rounded));
          }),
          icon(18, Icons.album_outlined, 'f'),
          icon(18, FontAwesomeIcons.g, 'g'),
          icon(18, FontAwesomeIcons.d, 'd'),
          icon(18, FontAwesomeIcons.y, 'y'),
          icon(18, FontAwesomeIcons.t, 't'),
        ],
      ),
    ),
  );
}

Widget field() {
  return Builder(builder: (context) {
    return Card(
      color: const Color.fromARGB(255, 0, 0, 0),
      child: TextField(
        onChanged: (value) => context.read<Variables>().text = value,
        style: const TextStyle(color: Colors.white),
        expands: true,
        maxLines: null,
      ),
    );
  });
}

Widget icon(double size, IconData icon, String s) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        children: [
          FaIcon(
            icon,
            size: size,
          ),
          Builder(builder: (context) {
            // var c = Provider.of<Variables>(context, listen: false);
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

            return Checkbox(
              value: b,
              onChanged: (value) {
                if (b == true) {
                  c.bs(false, s);
                } else {
                  c.bs(true, s);
                }
              },
            );
          }),
        ],
      ),
    ),
  );
}

// the streets are a mess

// Widget secondscreen(String s) {
//   return Scaffold(
//     appBar: AppBar(
//       forceMaterialTransparency: true,
//     ),
//     extendBodyBehindAppBar: true,
//     body: SizedBox.expand(
//       child: Card(
//         color: const Color.fromARGB(255, 68, 56, 15),
//         child: Center(
//           child: Builder(builder: (context) {
//             return NotificationListener<ScrollNotification>(
//               onNotification: (notification) {
//                 // context.read<Variables>().sp(notification.metrics.pixels);
//                 return false;
//               },
//               child: SingleChildScrollView(
//                 child: Builder(builder: (context) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 40,
//                       vertical: 30,
//                     ),
//                     child: Text(
//                       s,
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   );
//                 }),
//               ),
//             );
//           }),
//         ),
//       ),
//     ),
//   );
// }
