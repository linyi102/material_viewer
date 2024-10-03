import 'package:flutter/material.dart';

enum FileType {
  disk(Icons.folder, color: Colors.amber),
  dir(Icons.folder, color: Colors.amber),
  image(Icons.image,
      suffixes: ['.gif', '.jpg', '.jpeg', '.png', '.bmp', '.webp', 'jfif']),
  audio(Icons.audio_file, suffixes: ['.mp3']),
  video(Icons.video_file, suffixes: [
    '.avi',
    '.mp4',
    '.mov',
    '.flv',
    '.mkv',
    '.vdat',
    '.webm',
    '.ts',
    '.3gp'
  ]),
  zip(Icons.folder_zip, suffixes: ['.zip', '.7z', '.rar', '.cbz']),
  unknown(Icons.insert_drive_file);

  final IconData icon;
  final List<String> suffixes;
  final Color? color;

  const FileType(this.icon, {this.suffixes = const [], this.color});
}
