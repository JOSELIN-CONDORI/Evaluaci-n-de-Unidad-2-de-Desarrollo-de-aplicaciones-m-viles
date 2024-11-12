import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:provider/provider.dart';

class ErrorData extends StatefulWidget {
  @override
  _ErrorDataState createState() => _ErrorDataState();
}

class _ErrorDataState extends State<ErrorData> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final themeColors = themeProvider.getThemeColors();
    return Column(
      children: [
        Container(
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
          child: Text(
            'No existe ningún registro coincidente con la búsqueda.',
            style: TextStyle(
              color: themeProvider.isDiurno ? themeColors[7] : themeColors[2],
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Image.asset(
              'assets/nodatos_2.jpg',
              fit: BoxFit.cover,
              height: 200,
              width: 200,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/nofoto.jpg',
                  fit: BoxFit.cover,
                  height: 200,
                  width: 200,
                );
              },
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.4),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
