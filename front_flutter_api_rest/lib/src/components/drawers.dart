import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter_api_rest/src/controller/auth/ShareApiTokenController.dart';
import 'package:front_flutter_api_rest/src/providers/theme.dart';
import 'package:front_flutter_api_rest/src/routes/route.dart';
import 'package:provider/provider.dart';

class NavigationDrawerWidget extends StatefulWidget {
  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  String accountEmail = "";
  String accountName = "";
  String accountFoto = "";
  String accountRole = "";

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final loginDetails = await ShareApiTokenController.loginDetails();

    if (loginDetails != null) {
      setState(() {
        accountName = truncateText(loginDetails.user?.name ?? "", 10);
        accountEmail = truncateText(loginDetails.user?.email ?? "", 15);
        accountFoto = loginDetails.user?.foto ?? "";
        accountRole = loginDetails.user?.role ?? "";
      });
    }
  }

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + "...";
    }
  }

  @override
  Widget build(BuildContext context) {
    //drawertheme
    final themeProvider = context.watch<ThemeProvider>();
    final themeColors = themeProvider.getThemeColors();

    final name = '$accountName';
    final email = '$accountEmail';
    final urlImage = '$accountFoto';

    return Drawer(
      child: Material(
        color: themeProvider.isDiurno ? themeColors[6] : themeColors[0],
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: urlImage,
              name: name,
              email: email,
            ),
            Container(
              padding: padding,
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  buildSearchField(),
                  const SizedBox(height: 24),
                  // Opciones comunes para ambos roles
                  buildMenuItem(
                    text: 'Home',
                    icon: Icons.home,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        accountRole == 'user' ? '/user_home' : '/admin_home',
                      );
                    },
                  ),

                  const SizedBox(height: 16),
                  if (accountRole == 'user') ...[
                    buildMenuItem(
                      text: 'CAAA',
                      icon: CupertinoIcons.book,
                      onTap: () {
                        //  Navigator.of(context).pushNamed('/librohome');
                      },
                    ),
                  ],
                  if (accountRole == 'admin') ...[
                    buildMenuItem(
                      text: 'Usuarios',
                      icon: Icons.person_outline_sharp,
                      onTap: () {
                        Navigator.pushNamed(
                            context, AppRoutes.usuarioListRoute);
                      },
                    ),
                    buildMenuItem(
                      text: 'Categoria',
                      icon: Icons.category,
                      onTap: () {
                        Navigator.pushNamed(
                            context, AppRoutes.categoriaListRoute);
                      },
                    ),
                    buildMenuItem(
                      text: 'Sub Categoria',
                      icon: Icons.category,
                      onTap: () {
                        Navigator.pushNamed(
                            context, AppRoutes.subcategoriaListRoute);
                      },
                    ),
                    buildMenuItem(
                      text: 'Producto',
                      icon: CupertinoIcons.collections,
                      onTap: () {
                        Navigator.pushNamed(
                            context, AppRoutes.productoListRoute);
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 24),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          themeProvider.isDiurno
                              ? CupertinoIcons.moon_circle
                              : CupertinoIcons.sun_max,
                          size: 30,
                          color: themeProvider.isDiurno
                              ? Colors.white
                              : Colors.white,
                        ),
                        Switch(
                          value: themeProvider.isDiurno,
                          onChanged: (value) {
                            themeProvider.toggleTheme();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  buildMenuItem(
                    text: 'Plugins',
                    icon: Icons.account_tree_outlined,
                    onTap: () {
                      Navigator.of(context).pushNamed('/plugins');
                    },
                  ),
                  const SizedBox(height: 16),
                  buildMenuItem(
                    text: 'Logout',
                    icon: Icons.logout,
                    onTap: () {
                      ShareApiTokenController.logout(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
  }) =>
      Container(
        padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
        child: Row(
          children: [
            CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
            Spacer(),
            CircleAvatar(
              radius: 24,
              backgroundColor: Color.fromRGBO(30, 60, 168, 1),
              child: Icon(Icons.edit, color: Colors.white),
            )
          ],
        ),
      );

  Widget buildSearchField() {
    final color = Colors.white;

    return TextField(
      style: TextStyle(color: color),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        hintText: 'Search',
        hintStyle: TextStyle(color: color),
        prefixIcon: Icon(Icons.search, color: color),
        filled: true,
        fillColor: Colors.white12,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onTap,
    );
  }
}
