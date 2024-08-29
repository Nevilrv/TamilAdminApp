class UploadVideoRequestModel {
  List<Input>? input;
  List<String>? playbackPolicy;

  UploadVideoRequestModel({this.input, this.playbackPolicy});

  UploadVideoRequestModel.fromJson(Map<String, dynamic> json) {
    if (json['input'] != null) {
      input = <Input>[];
      json['input'].forEach((v) {
        input!.add(new Input.fromJson(v));
      });
    }
    playbackPolicy = json['playback_policy'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.input != null) {
      data['input'] = this.input!.map((v) => v.toJson()).toList();
    }
    data['playback_policy'] = this.playbackPolicy;
    return data;
  }
}

class Input {
  String? url;

  Input({this.url});

  Input.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}
