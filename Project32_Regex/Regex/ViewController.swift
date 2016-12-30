//
//  ViewController.swift
//  Regex
//
//  Created by baiwei－mac on 16/12/30.
//  Copyright © 2016年 YuHua. All rights reserved.
//

import UIKit

/*正则表达式来匹配自己需要的内容，需要提取网页内容时，非常有用*/

let YHRect = UIScreen.main.bounds
let YHHeight = YHRect.size.height
let YHWidth = YHRect.size.width
let YHNoNavRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 64)
let YHNoTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49)
let YHNoNavTarRect = CGRect(x: 0, y: 0, width: YHWidth, height: YHHeight - 49 - 64)


class ViewController: UIViewController {
    
    /*本demo用于匹配维基百科上面，中国的所有省市地名*/
    var provinces = [Province]()
    let tableView = UITableView(frame: YHRect, style: .plain)
    let reuseIdentifer = "ReuseIdentifer"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let result = regexProvinces() {
            provinces = result
            //将数据保存到plist文件中
            saveProvinces()
        }
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupView() {
        
        title = "全国省份列表"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifer)
        view.addSubview(tableView)
    }
    
    //保存到plist文件中
    func saveProvinces() {
        let dirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        if let path = dirPath {
            let filePath = path.appending("/Province.plist")
            print("plist文件地址：" + filePath)
            let reuslt = NSMutableDictionary()
            for province in provinces {
                let pro = NSMutableDictionary()
                for city in province.citys {
                    pro.setValue(city.alias, forKey: city.name)
                }
                reuslt.setValue(pro, forKey: province.name)
            }
            //该方法保存的数据，必须是字典和数组或者两者的结合。并且，swift的类Array、Dictionary没有该方法。需要转成OC的NSArray等才能这样存储
            reuslt.write(toFile: filePath, atomically: true)
        }
    }
}


extension ViewController:UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provinces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath)
        let province = provinces[indexPath.row]
        cell.textLabel?.text = province.name
        cell.textLabel?.textColor = .orange
        return cell
    }
    
    
    //MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let show = ShowVC()
        show.province = provinces[indexPath.row]
        self.navigationController?.pushViewController(show, animated: true)
    }
}


//市区结构体，包含名字和别称
struct City {
    let name, alias: String
}

struct Province {
    let name: String
    var citys: [City]
}


//数据处理扩展
extension ViewController {
    
    //返回省数组
    func regexProvinces() -> [Province]? {
        
        var result = [Province]()
        //先从location.html文件中解析出省和市数据
        do {
            let str = try String(contentsOfFile: Bundle.main.path(forResource: "location", ofType: "html")!)
            //正则规则
            let regex = "<h2><span class=\"mw-headline\"(.|\n)*?<ul>(.|\n)*?</ul>"
            let regular = try? NSRegularExpression(pattern: regex, options: NSRegularExpression.Options.caseInsensitive)
            let arr = regular?.matches(in: str, options: [], range: NSRange(location: 0, length: str.characters.count))
            for match in arr! {
                //把string转成nsstring，利用oc的方法获取数据，比较方便
                let range = match.range
                let strns = str as NSString
                let str = strns.substring(with: range)
                //继续对str进行提取，得到省、市数据
                if let province = regexCitys(str: str) {
                    result.append(province)
                }
                
                //下方是采用纯swift的方法获得数据，但是比较麻烦
                //            let starIndex = str.index(str.startIndex, offsetBy: range.location)
                //            let endIndex = str.index(str.startIndex, offsetBy: range.location + range.length)
                //            print("解析结果："+str[starIndex...endIndex])
            }
            
        } catch let err as NSError {
            print(err.localizedFailureReason)
        }
        return result
    }
    
    //继续提取
    func regexCitys(str: String) -> Province? {
        
        let provinceNameRegular = try? NSRegularExpression(pattern: "\">.*?</span><span", options: NSRegularExpression.Options.caseInsensitive)
        let provinceNameRange = provinceNameRegular?.rangeOfFirstMatch(in: str, options: [], range: NSRange(location: 0, length: str.characters.count))
        var provinceName = (str as NSString).substring(with: provinceNameRange!)
        provinceName = (provinceName as NSString).substring(with: NSRange(location: 2, length: provinceName.characters.count-2-12))
        print("城市名称：\(provinceName)")
        if provinceName == "注释和参考" {
            return nil
        }
        var province = Province(name: provinceName, citys: [City]())
        
        //解析城市
        let cityRegular = try? NSRegularExpression(pattern: "\">.*?</a>.*?</li>", options: NSRegularExpression.Options.caseInsensitive)
        let arr = cityRegular?.matches(in: str, options: [], range: NSRange(location: 0, length: str.characters.count))
        for match in arr! {
            let range = match.range
            let str: NSString = (str as NSString).substring(with: range) as NSString
            //城市名
            let spaceRange = str.range(of: "</a>")
            if spaceRange.length+spaceRange.location > str.length {
                continue
            }
            let cityName = str.substring(with: NSRange(location: 2, length: spaceRange.location-2))
            //城市别名
            let spaceRange2 = str.range(of: "：")
            if spaceRange2.length+spaceRange2.location > str.length {
                continue
            }
            var cityAlias = str.substring(with: NSRange(location: spaceRange2.location+1, length: str.length-spaceRange2.location-1-5))
            print("..城市：\(cityName)\n..别名：\(cityAlias)")
            //经过分析，上海，富阳，青岛，信阳，武汉，广州，这几个城市别名会有区别，单独提出来处理
            switch cityName {
            case "上海":
                cityAlias = (cityAlias as NSString).substring(with: NSRange(location: cityAlias.characters.count-6, length:6))
            case "富阳":
                cityAlias = (cityAlias as NSString).substring(with: NSRange(location: 0, length:4))
            case "青岛":
                cityAlias = (cityAlias as NSString).substring(with: NSRange(location: 0, length:2))
            case "信阳":
                cityAlias = (cityAlias as NSString).substring(with: NSRange(location: 0, length:10))
            case "武汉":
                cityAlias = (cityAlias as NSString).substring(with: NSRange(location: cityAlias.characters.count-20, length:20))
            case "广州":
                cityAlias = (cityAlias as NSString).substring(with: NSRange(location: cityAlias.characters.count-15, length:15))
            default:
                break
            }
            print("经过修正：\(cityAlias)")
            let city = City(name: cityName, alias: cityAlias)
            province.citys.append(city)
        }
        return province
    }
}

