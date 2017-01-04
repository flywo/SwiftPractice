//
//  ViewController.swift
//  SpeechRecognition
//
//  Created by baiwei－mac on 17/1/4.
//  Copyright © 2017年 YuHua. All rights reserved.
//

import UIKit
import Speech


/*需要在info.plist里面添加两个字段，表名需要使用麦克风和语音识别功能*/


let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width
let YHNoNavRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 64)
let YHNoTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49)
let YHNoNavTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49 - 64)


class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    
    let textView = UITextView(frame: YHNoTarRect)
    let speek = UIButton(frame: CGRect(x: 0, y: YHHeight-49, width: YHWidth, height: 49))
    //语音识别器
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh_Hans_CN"))
    //语音识别请求
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    //识别任务
    var recognitionTask: SFSpeechRecognitionTask?
    //音频
    let audioEngine = AVAudioEngine()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        //回调可能不是在主线程
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization{ authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.speek.isEnabled = true
                case .denied:
                    self.speek.isEnabled = false
                    self.speek.setTitle("被拒绝了", for: .disabled)
                    
                case .restricted:
                    self.speek.isEnabled = false
                    self.speek.setTitle("被限制了", for: .disabled)
                    
                case .notDetermined:
                    self.speek.isEnabled = false
                    self.speek.setTitle("没有决定", for: .disabled)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func startRecording() throws {
        
        //如果任务正在执行，先取消任务
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        //初始化音频会话
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)//录音
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else { fatalError("没有输入") }
        guard let recognitionRequest = recognitionRequest else { fatalError("创建请求失败") }
        
        //一边解析一边反馈
        recognitionRequest.shouldReportPartialResults = true
        
        //保持该任务的引用，方便停止
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                print("所有的识别结果：\(result.transcriptions)")
                self.textView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        textView.text = "说话吧，朋友。"
    }
    

    func setupView() {
        
        view.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 40)
        textView.isUserInteractionEnabled = false
        speek.setTitle("按住说话！", for: .normal)
        speek.setTitleColor(UIColor.orange.withAlphaComponent(0.5), for: .highlighted)
        speek.setTitleColor(.orange, for: .normal)
        speek.setTitleColor(.gray, for: .disabled)
        speek.addTarget(self, action: #selector(begin), for: .touchDown)
        speek.addTarget(self, action: #selector(stop), for: .touchUpInside)
        //如果没有允许使用语音，则不能点击按钮
        speek.isEnabled = false
        view.addSubview(textView)
        view.addSubview(speek)
    }
    
    func begin() {
        do {
            try startRecording()
        } catch let err as NSError {
            print("开始解析错误：\(err)")
        }
    }
    
    func stop() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }
    
    //MARK: - delegate
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            print("开始识别")
        }else {
            print("无法识别")
        }
    }
}

