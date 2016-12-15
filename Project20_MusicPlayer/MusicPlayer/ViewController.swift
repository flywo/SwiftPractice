//
//  ViewController.swift
//  MusicPlayer
//
//  Created by baiwei－mac on 16/12/15.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit
import AVFoundation

let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width

class ViewController: UIViewController {

    let fileManager = FileManager.default
    let musicPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first?.appending("/music")
    var musicList = [String]()
    let tableView = UITableView(frame: YHRect)
    let resueIndetifier = "MusicCell"
    var musicPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveMusicFile()
        getMusicList()
        setupView()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*沙盒文件目录：
     AppName.app:应用程序本身数据，只读。  Bundle.main.path(forResource: <#T##String?#>, ofType: <#T##String?#>)
     Documents:会被itunes备份，应用程序产生的数据，不可再生的数据放在这里
        Inbox:该目录可被外部应用程序访问，只读，需要自己创建
     Library:
        Caches:应用程序启动过程需要的信息，不会被备份，存放可再生的数据
        Preferences:偏好设置，会被itunes备份
     tmp:临时数据存放，会自动被删除
     */
    
    //保存音乐文件--这一步不是必须的，只是为了熟悉swift存储文件的操作
    func saveMusicFile() {
        let names = ["成都","童话镇"]
        //在caches创建一个music文件夹
        /*try try! try?区别：
         try:两种情况，①do {let result = try func()} catch {} 处理throw ②let result = try func() 忽略throw
         try!:相当于可选类型！，如果不throw就不会出任何问题，一旦throw，程序就会crash
         try?:把throw转换成是否是nil，而不处理具体的结果。如①if let result = try? func() {} else {} ②guard let result = try? func() else {}
         */
        print(musicPath)
        do {
            try fileManager.createDirectory(atPath: musicPath!, withIntermediateDirectories: true, attributes: nil)
            print("创建成功")
        } catch let err as NSError {
            print("创建失败:\(err.localizedFailureReason)")
            return
        }
        //把歌曲保存到caches里面
        for name in names {
            let bundlePath = Bundle.main.path(forResource: name, ofType: "m4r")
            let toPath = musicPath!.appending("/\(name).m4r")
            if fileManager.fileExists(atPath: toPath) {
                print("已经存在\(name)")
                continue
            }
            do {
                try fileManager.copyItem(atPath: bundlePath!, toPath: toPath)
                print("移动成功")
            } catch let err as NSError {
                print("移动失败:\(err.localizedFailureReason)")
            }
        }
    }
    
    //读取音乐列表
    func getMusicList() {
        //读取、查看文件用NSFileManager
        do {
            musicList = try fileManager.contentsOfDirectory(atPath: musicPath!)
            print("查询成功:\(musicList)")
        } catch let err as NSError {
            print("查询失败:\(err.localizedFailureReason)")
        }
    }
    
    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
    
    func playMusic(path: String) {
        if musicPlayer != nil {
            musicPlayer?.stop()
            musicPlayer = nil
        }
        do {
            try musicPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            //可以通过musicPlayer的属性获得歌曲的信息，包括长度，通道等信息
            print("歌曲长度：\((musicPlayer?.duration)!)")
            musicPlayer?.numberOfLoops = -1//循环次数
            musicPlayer?.delegate = self
            musicPlayer?.play()
            
        } catch let err as NSError {
            print("播放失败：\(err.localizedFailureReason)")
        }
        
    }

}

extension ViewController:UITableViewDataSource, UITableViewDelegate ,AVAudioPlayerDelegate {
    //MARK: - DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resueIndetifier) ?? UITableViewCell(style: .default, reuseIdentifier: resueIndetifier)
        cell.textLabel?.text = musicList[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .orange
        cell.textLabel?.font = UIFont.systemFont(ofSize: 30, weight: 10)
        return cell
    }
    
    //MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        playMusic(path: musicPath!.appending("/\(musicList[indexPath.row])"))
    }
    
    //MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        musicPlayer = nil
    }
}

