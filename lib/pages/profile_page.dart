import '../static_var.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'Profilo',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),

                    Spacer(),

                    Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(StaticVar.PIER_2),
                          radius: 50,
                        ),

                        Text('Modifica'),
                      ],
                    )
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of the shadow
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Inserisci il tuo lido',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Center the text horizontally
                        Text(
                          'Inizia a guadagnare tramite BAH',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center, // Center text horizontally
                        ),
                      ],
                    ),
                    // Adjust icon size
                    Image.asset(
                      StaticVar.PALM_ICON,
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
              ),


              const SizedBox(height: 10),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 20),
                child: Text(
                  'Impostazioni',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      leading: Image.asset(
                        StaticVar.OMINO_ICON,
                        width: 20,
                        height: 20,
                      ),
                      title: const Text('Informazioni personali'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        // Handle navigation to personal information screen
                      },
                    ),

                    const Divider(
                      thickness: 1.5,
                      color: StaticVar.CYAN,
                    ),

                    // ... other settings options
                    ListTile(
                      leading: Image.asset(
                        StaticVar.LOCK_ICON,
                        width: 20,
                        height: 20,
                      ),
                      title: const Text(
                        'Privacy',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {

                      },
                    ),

                    const Divider(
                      thickness: 1.5,
                      color: Color(0xFF36A9E1),
                    ),

                    ListTile(
                      leading: Image.asset(
                        StaticVar.SETTINGS_ICON,
                        width: 20,
                        height: 20,
                      ),
                      title: const Text('Accessibilità'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {

                      },
                    ),

                    const Divider(
                      thickness: 1.5,
                      color: StaticVar.CYAN,
                    ),

                    ListTile(
                      leading: Image.asset(
                        StaticVar.NOTIFICATIONS_ICON,
                        width: 20,
                        height: 20,
                      ),
                      title: Text(
                        'Notifiche',
                        style: GoogleFonts.inter(),
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {

                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 20),
                child: Text(
                  'Assistenza',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      leading: Image.asset(
                        StaticVar.BAH_BLUE_ICON,
                        width: 20,
                        height: 20,
                      ),
                      title: Text(
                        'Come funziona bah',
                        style: GoogleFonts.inter(),
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        // Handle navigation to personal information screen
                      },
                    ),

                    const Divider(
                      thickness: 1.5,
                      color: StaticVar.CYAN,
                    ),

                    // ... other settings options
                    ListTile(
                      leading: Image.asset(
                        StaticVar.HEADPHONES_ICON,
                        width: 20,
                        height: 20,
                      ),
                      title: Text(
                        'Centro Assistenza',
                        style: GoogleFonts.inter(),

                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {

                      },
                    ),

                    const Divider(
                      thickness: 1.5,
                      color: StaticVar.CYAN,
                    ),

                    ListTile(
                      leading: Image.asset(
                        StaticVar.PEN_ICON,
                        width: 20,
                        height: 20,
                      ),
                      title: Text(
                        'Inviaci il tuo feedback',
                        style: GoogleFonts.inter(),
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {

                      },
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0,horizontal: 20),
                child: Text(
                  'Esci',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
