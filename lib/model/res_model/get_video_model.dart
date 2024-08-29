// To parse this JSON data, do
//
//     final getAllVideoResponseModel = getAllVideoResponseModelFromJson(jsonString);

import 'dart:convert';

GetAllVideoResponseModel getAllVideoResponseModelFromJson(String str) =>
    GetAllVideoResponseModel.fromJson(json.decode(str));

String getAllVideoResponseModelToJson(GetAllVideoResponseModel data) =>
    json.encode(data.toJson());

class GetAllVideoResponseModel {
  GetAllVideoResponseModel({
    this.data,
  });

  List<Datum>? data;

  factory GetAllVideoResponseModel.fromJson(Map<String, dynamic> json) =>
      GetAllVideoResponseModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.tracks,
    this.test,
    this.status,
    this.playbackIds,
    this.mp4Support,
    this.maxStoredResolution,
    this.maxStoredFrameRate,
    this.masterAccess,
    this.id,
    this.duration,
    this.createdAt,
    this.aspectRatio,
    this.errors,
  });

  List<Track>? tracks;
  bool? test;
  String? status;
  List<PlaybackId>? playbackIds;
  String? mp4Support;
  String? maxStoredResolution;
  double? maxStoredFrameRate;
  String? masterAccess;
  String? id;
  double? duration;
  String? createdAt;
  String? aspectRatio;
  Errors? errors;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        tracks: json["tracks"] == null
            ? null
            : List<Track>.from(json["tracks"].map((x) => Track.fromJson(x))),
        test: json["test"],
        status: json["status"],
        playbackIds: List<PlaybackId>.from(
            json["playback_ids"].map((x) => PlaybackId.fromJson(x))),
        mp4Support: json["mp4_support"],
        maxStoredResolution: json["max_stored_resolution"] == null
            ? null
            : json["max_stored_resolution"],
        maxStoredFrameRate: json["max_stored_frame_rate"] == null
            ? null
            : json["max_stored_frame_rate"].toDouble(),
        masterAccess: json["master_access"],
        id: json["id"],
        duration: json["duration"] == null ? null : json["duration"].toDouble(),
        createdAt: json["created_at"],
        aspectRatio: json["aspect_ratio"] == null ? null : json["aspect_ratio"],
        errors: json["errors"] == null ? null : Errors.fromJson(json["errors"]),
      );

  Map<String, dynamic> toJson() => {
        "tracks": tracks == null
            ? null
            : List<dynamic>.from(tracks!.map((x) => x.toJson())),
        "test": test,
        "status": status,
        "playback_ids": List<dynamic>.from(playbackIds!.map((x) => x.toJson())),
        "mp4_support": mp4Support,
        "max_stored_resolution":
            maxStoredResolution == null ? null : maxStoredResolution,
        "max_stored_frame_rate":
            maxStoredFrameRate == null ? null : maxStoredFrameRate,
        "master_access": masterAccess,
        "id": id,
        "duration": duration == null ? null : duration,
        "created_at": createdAt,
        "aspect_ratio": aspectRatio == null ? null : aspectRatio,
        "errors": errors == null ? null : errors!.toJson(),
      };
}

class Errors {
  Errors({
    this.type,
    this.messages,
  });

  String? type;
  List<String>? messages;

  factory Errors.fromJson(Map<String, dynamic> json) => Errors(
        type: json["type"],
        messages: List<String>.from(json["messages"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "messages": List<dynamic>.from(messages!.map((x) => x)),
      };
}

class PlaybackId {
  PlaybackId({
    this.policy,
    this.id,
  });

  String? policy;
  String? id;

  factory PlaybackId.fromJson(Map<String, dynamic> json) => PlaybackId(
        policy: json["policy"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "policy": policy,
        "id": id,
      };
}

class Track {
  Track({
    this.type,
    this.maxWidth,
    this.maxHeight,
    this.maxFrameRate,
    this.id,
    this.duration,
    this.maxChannels,
    this.maxChannelLayout,
  });

  String? type;
  int? maxWidth;
  int? maxHeight;
  double? maxFrameRate;
  String? id;
  double? duration;
  int? maxChannels;
  String? maxChannelLayout;

  factory Track.fromJson(Map<String, dynamic> json) => Track(
        type: json["type"],
        maxWidth: json["max_width"] == null ? null : json["max_width"],
        maxHeight: json["max_height"] == null ? null : json["max_height"],
        maxFrameRate: json["max_frame_rate"] == null
            ? null
            : json["max_frame_rate"].toDouble(),
        id: json["id"],
        duration: json["duration"].toDouble(),
        maxChannels: json["max_channels"] == null ? null : json["max_channels"],
        maxChannelLayout: json["max_channel_layout"] == null
            ? null
            : json["max_channel_layout"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "max_width": maxWidth == null ? null : maxWidth,
        "max_height": maxHeight == null ? null : maxHeight,
        "max_frame_rate": maxFrameRate == null ? null : maxFrameRate,
        "id": id,
        "duration": duration,
        "max_channels": maxChannels == null ? null : maxChannels,
        "max_channel_layout":
            maxChannelLayout == null ? null : maxChannelLayout,
      };
}
