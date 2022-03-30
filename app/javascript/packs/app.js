import axios from 'axios';
axios.defaults.headers['X-Requested-With'] = 'XMLHttpRequest';
axios.defaults.headers['X-CSRF-TOKEN'] = document.getElementsByName('csrf-token')[0].getAttribute('content');

const downloadLink = document.getElementById('download');
const playback = document.getElementById('play');
const result = document.getElementById('result');
const start = document.getElementById("start")
const rec = document.getElementById("rec")
const stop = document.getElementById("stop")
const play = document.getElementById("playid")

// for audio
let stream = null;  //なしでも良さそう。
let audio_sample_rate = null;
let scriptProcessor = null;
let audioContext = null;
let mediastreamsource = null;
var timeout_id = null;

// audio data
let audioData = [];
let bufferSize = 1024;
let micBlobUrl = null;



rec.onclick = function() {
    navigator.mediaDevices.getUserMedia({
        video: false,
        audio: true
    })
        .then(function (stream) { // promiseのresultをaudioStreamに格納
            console.log('録音しています');
            audioData = [];
            audioContext = new AudioContext();
            audio_sample_rate = audioContext.sampleRate;
            scriptProcessor = audioContext.createScriptProcessor(bufferSize, 1, 1);
            mediastreamsource = audioContext.createMediaStreamSource(stream);
            mediastreamsource.connect(scriptProcessor);
            scriptProcessor.onaudioprocess = onAudioProcess;
            scriptProcessor.connect(audioContext.destination);
            timeout_id = setTimeout(() => {
                stop.click(); // ボタンがクリックされなければ5秒後にstopが押される
              }, 5000);
              stop.addEventListener('click', () => {
                clearTimeout(timeout_id);
                console.log('停止しました');
              });
        })
        .catch(function (error) { // error
            console.error('mediaDevice.getUserMedia() error:', error);
            return;
        });
    
    
};

// save audio data //1024bitのバッファサイズに達するごとにaudioDataにデータを追加する
var onAudioProcess = function (e) {
    var input = e.inputBuffer.getChannelData(0);
    var bufferData = new Float32Array(bufferSize);
    for (var i = 0; i < bufferSize; i++) {
        bufferData[i] = input[i];
    }
    audioData.push(bufferData);
};

//録音の停止
stop.onclick = function() {
    saveAudio();
    
}

//再生
play.onclick = function(audioBlob) {
    if (micBlobUrl) {
        playback.src = micBlobUrl;
        // 再生終了時
        playback.onended = function () {
            playback.pause();
            playback.src = "";
        };
        // 再生
        playback.play();
    }
};



//WAVに変換
let exportWAV = function (audioData) {
    let encodeWAV = function (samples, sampleRate) {
        let buffer = new ArrayBuffer(44 + samples.length * 2);
        let view = new DataView(buffer);

        let writeString = function (view, offset, string) {
            for (let i = 0; i < string.length; i++) {
                view.setUint8(offset + i, string.charCodeAt(i));
            }
        };

        let floatTo16BitPCM = function (output, offset, input) {
            for (let i = 0; i < input.length; i++, offset += 2) {
                let s = Math.max(-1, Math.min(1, input[i]));
                output.setInt16(offset, s < 0 ? s * 0x8000 : s * 0x7FFF, true);
            }
        };

        writeString(view, 0, 'RIFF');  // RIFFヘッダ
        view.setUint32(4, 32 + samples.length * 2, true); // これ以降のファイルサイズ
        writeString(view, 8, 'WAVE'); // WAVEヘッダ
        writeString(view, 12, 'fmt '); // fmtチャンク
        view.setUint32(16, 16, true); // fmtチャンクのバイト数
        view.setUint16(20, 1, true); // フォーマットID
        view.setUint16(22, 1, true); // チャンネル数
        view.setUint32(24, sampleRate, true); // サンプリングレート
        view.setUint32(28, sampleRate * 2, true); // データ速度
        view.setUint16(32, 2, true); // ブロックサイズ
        view.setUint16(34, 16, true); // サンプルあたりのビット数
        writeString(view, 36, 'data'); // dataチャンク
        view.setUint32(40, samples.length * 2, true); // 波形データのバイト数
        floatTo16BitPCM(view, 44, samples); // 波形データ
        return view;
    };

    let mergeBuffers = function (audioData) {
        let sampleLength = 0;
        for (let i = 0; i < audioData.length; i++) {
            sampleLength += audioData[i].length;
        }
        let samples = new Float32Array(sampleLength);
        let sampleIdx = 0;
        for (let i = 0; i < audioData.length; i++) {
            for (let j = 0; j < audioData[i].length; j++) {
                samples[sampleIdx] = audioData[i][j];
                sampleIdx++;
            }
        }
        return samples;
    };

    let dataview = encodeWAV(mergeBuffers(audioData), audio_sample_rate);
    let audioBlob = new Blob([dataview], { type: 'audio/wav' });
    micBlobUrl = window.URL.createObjectURL(audioBlob);
    console.log(dataview);

    let myURL = window.URL || window.webkitURL;
    let url = myURL.createObjectURL(audioBlob);
    //ここでurlをバックエンド側に作成？その後、xhr.openでurlを取りに行ってる？
    downloadLink.href = url;
};



//保存
let saveAudio = function () {
    exportWAV(audioData);
    downloadLink.download = 'test.wav';
    audioContext.close().then(function () {
    });
};

result.onclick = function() {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', document.querySelector('#download').href, true);
    xhr.responseType = 'blob';
    xhr.send();

    xhr.onload = function(e) {
      var myBlob = this.response;
        // myBlob is now the blob that the object URL pointed to.
      let formData = new FormData();
        formData.append('target_id', document.querySelector('#target_id').value)
        formData.append('impersonation_voice', myBlob, 'voice.wav');
        formData.append('score', 100);

        axios.post(document.querySelector('#voiceform').action,  formData, {
        headers: {
        'content-type': 'multipart/form-data',
        }
        }).then(response => {
          let data = response.data
          window.location.href = data.url
          }).catch(error => {
          console.log(error.response)
        })
    } 
};