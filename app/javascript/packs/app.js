
let audioCtx;

const record = document.getElementById("record")
const stop = document.getElementById("stop")


if (navigator.mediaDevices.getUserMedia) {
    console.log('getUserMedia supported.');
  
    const constraints = { audio: true };
    let chunks = [];
    
  
    let onSuccess = function(stream) {
      const mediaRecorder = new MediaRecorder(stream);

  
      record.onclick = function() {
        mediaRecorder.start();
        console.log(mediaRecorder.state);
        console.log("recorder started");
        record.style.background = "red";
        stop.disabled = false;
        record.disabled = true;
      }
  
      stop.onclick = function() {
        mediaRecorder.stop();
        console.log(mediaRecorder.state);
        console.log("recorder stopped");
        // mediaRecorder.requestData();
        record.style.background = "";
        stop.disabled = true;
        record.disabled = false;
      }}

      let onError = function(err) {
        console.log('The following error occured: ' + err);
      }
      navigator.mediaDevices.getUserMedia(constraints).then(onSuccess, onError);
    };
