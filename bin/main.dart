import 'dart:async';
import 'dart:io';

Future main() async {
  HttpServer server;
  try {
    server = await HttpServer.bind(
      '127.0.0.1',
      8080,
    );
  } catch (e) {
    print('failed to start server $e');
    exit(-1);
  }

  print('Listening on Localhost:${server.port}');

  await for (var req in server) {
    HttpResponse response = req.response
      ..headers.contentType = ContentType.html;

    if (req.method == 'GET') {
      String filename = req.uri.pathSegments.last;

      if (!filename.contains('.html')) {
        filename = filename + '.html';
      }

      File file = File(filename);
      if (await file.exists()) {
        file.openRead().pipe(response);
      } else {
        file
            .openWrite(mode: FileMode.write)
            .write('<h1>This is a new file</h1>');

        file.openRead().pipe(response);
      }
    }
  }
}

// import 'dart:async';
// import 'dart:io';

// final File file = File('index.html');

// Future main() async {
//   HttpServer server;
//   try {
//     server = await HttpServer.bind(
//       '127.0.0.1',
//       8080,
//     );
//   } catch (e) {
//     print('failed to start server $e');
//     exit(-1);
//   }

//   print('Listening on Localhost:${server.port}');

//   await for (var req in server) {
//     if (await file.exists()) {
//       print('Serving ${file.path}');
//       req.response.headers.contentType = ContentType.html;

//       try {
//         await file.openRead().pipe(req.response);
//       } catch (e) {
//         print("Couldn't read file: $e");
//         exit(-1);
//       }
//     } else {
//       print("Can't open file");
//       req.response
//         ..statusCode = HttpStatus.notFound
//         ..close();
//     }
//   }
// }
