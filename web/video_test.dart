import 'dart:html';
import 'dart:isolate';

var charList = [" ", ".", ",", ":", ";", "i", "1", "t", "f", "L", "C", "G", "0", "8", "@"];

int cli;
int width = 100;
int height = 75;
int timeout = 100;
String localMediaStream;
CanvasElement canvas;
CanvasRenderingContext2D ctx;
VideoElement video;
DivElement ascii; 

void onSuccess(stream) {
  localMediaStream = stream;
  video = query('video');
  video.src = Url.createObjectUrl(localMediaStream);
  video.on.loadedMetadata.add((e) {
    //window.requestAnimationFrame(draw);
    //draw(0.0);
    window.setTimeout(draw, timeout);
  }); 
}

void onError(error) {

}

draw() {
  if (localMediaStream != null) {
    ctx.drawImage(video, 0, 0, width, height);
    Uint8ClampedArray data = ctx.getImageData(0,0, width, height).data;
    List<int> l = data.getRange(0, data.length-1);
        
    query('#last').innerHTML = convert(data);
    
//    sendPort.call({"data": l}).then((reply) {
//      query('#last').innerHTML = reply;
//    });
  }
  
  window.setTimeout(draw, timeout);
  //window.requestAnimationFrame(draw);
}

convert(data) {
//  port.receive((msg, reply) {
//    //print("from isolate = ${msg['data']}");
//    var img = new Uint8ClampedArray.fromList(msg['data']);
//    ///reply.send("data = ${msg['data'].runtimeType}");
//    //
//    //return; 
//    
    var img = data;
    
    var buf = new Uint8Array(15000);
    var strChars = new StringBuffer();
    for (var y = 0; y < height; y++) {
      var outRow = y*width*2;
      var row = outRow*2;
      for(var x = 0; x < width; x++) {
        
        var loc = row+x*4;
        var outLoc = outRow+x*2;
        
        var r = img[loc];
        var g = img[loc+1];
        var b = img[loc+2];
        
        var rr = (r/16).floor().toInt();
        var gr = (g/16).floor().toInt();
        var br = (b/16).floor().toInt();
        
        var bright = (0.3*r + 0.59*g + 0.11*b) / 255;
        var idx = ((cli) - (bright * (cli)).round()).toInt();
        
        var char = charList[idx];
        
        strChars.add("<span style='"
        "color:rgb("
        "${rr*16}"
        ","
        "${gr*16}"
        ","
        "${br*16}"
        ");"
        "'>"
        "$char"
        "$char"
        "</span>");
        
        buf[outLoc] = (idx << 4) + rr;
        buf[outLoc+1] = (gr << 4) + br;
      }
      strChars.add("\n");
    }
    
    return strChars.toString();
//    reply.send(strChars.toString());
//  });
}

//var sendPort;

void main() {
  cli = charList.length-1;
  //sendPort = spawnFunction(convert);
  ascii = query('#ascii');
  var options = { 'video': true, "audio": true };
  window.navigator.webkitGetUserMedia(options, onSuccess, onError);
  canvas = query("#canvas");
  ctx = canvas.getContext("2d");
}

