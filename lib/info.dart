
import 'package:flutter/material.dart';

class AuthorInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profile.jpg'),
          ),
          SizedBox(height: 16),
          Text(
            'Nama Penulis',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saran:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Mata kuliah ini sudah memiliki kontrak kuliah yang adil, tetapi dalam proses pembelajaran, saya merasa tugas dan kuis yang diberikan sedikit membebani mahasiswa. Saran saya, untuk kuis dikurangi jumlah soalnya dan frekuensi pemberian tugas juga dikurangi, Terima kasih atas perhatiannya, Pak.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Kesan:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Terima kasih saya ucapkan kepada Pak Bagus, selaku dosen mata kuliah Teknologi dan Pemrograman Mobile. Saya mendapat banyak ilmu selama satu semester ini. Saya juga ingin berterima kasih karena telah diberikan keringanan dalam pengerjaan Tugas Akhir sebab kondisi laptop saya yang kurang mendukung. Saya harap, dari keterbatasan saya ini, saya tetap bisa mendapatkan nilai yang baik dan lulus dari mata kuliah ini. Sekali lagi, terima kasih atas perhatiannya, Pak.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}