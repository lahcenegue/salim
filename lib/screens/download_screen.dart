import 'package:flutter/material.dart';
import '../data/sqldb.dart';
import 'package:open_file_plus/open_file_plus.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  SqlDb sqlDb = SqlDb();

  Future<List<Map>> readData() async {
    List<Map> response = await sqlDb.readData("SELECT * FROM download");
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التحميلات'),
      ),
      body: FutureBuilder(
        future: readData(),
        builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: ((context, index) {
                return const SizedBox(height: 08);
              }),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(
                    right: 25,
                    left: 25,
                    top: 16,
                  ),
                  padding: const EdgeInsets.only(right: 27),
                  decoration: BoxDecoration(
                    color: const Color(0xffF1F0FD),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        offset: const Offset(3, 4),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      snapshot.data![index]['name'],
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_back_ios_new),
                    onTap: () {
                      OpenFile.open(snapshot.data![index]['path']);
                    },
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
