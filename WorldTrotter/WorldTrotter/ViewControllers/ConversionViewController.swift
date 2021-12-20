//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by cx on 2021/12/12.
//

//import Foundation //UIKit里面就已经包含了Foundation
import UIKit

class ConversionViewController: UIViewController,UITextFieldDelegate{
    @IBOutlet var celsiusLabel:UILabel!
    @IBOutlet var textField:UITextField!
    var fahrenHeitValue:Measurement<UnitTemperature>?//存储华氏度
    {
        didSet{//华氏度改变了以后就通知改变摄氏度
            updateCelsiusLabel()
        }
    }
    var celsiusValue:Measurement<UnitTemperature>?{//存储摄氏度(依赖于华氏度）
        //这是个计算属性。
        //摄氏度每次都是根据华氏度计算出来的
        if let fahrenHeitValue=fahrenHeitValue{
            return fahrenHeitValue.converted(to: .celsius)
        }
        else{
            return nil
        }
    }
    let numberFormatter:NumberFormatter={
        let nf=NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits=0
        nf.maximumFractionDigits=2
        return nf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loaded it's view")
        
        updateCelsiusLabel()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //每次点击 换颜色
//        struct control{
//            static var a:Bool=false
//        }
//        if control.a==true{
//            view.backgroundColor=UIColor.white
//            control.a = !control.a
//        }else{
//            view.backgroundColor=UIColor.black
//            control.a = !control.a
//        }
        //根据上午下午换颜色
//        let dateformatter = DateFormatter()
//        dateformatter.dateFormat = "yyyy-MM-dd 'at' HH:mm aa"
//        print(dateformatter.string(from: Date()))
//        if dateformatter.string(from: Date()) == dateformatter.amSymbol{
//            view.backgroundColor=UIColor.darkGray
//        }else{
//            view.backgroundColor=UIColor.gray
//        }
        
        //根据早晚更改背景颜色
        let dateformatter=DateFormatter()
        dateformatter.dateFormat="HH"
        let str=dateformatter.string(from: Date())
        let time:Int8 = Int8(str)!
        if(time > 6 && time < 18){//强制解包
            view.backgroundColor=UIColor.white
        }else{
            view.backgroundColor=UIColor.darkGray
        }
        
    }
    @IBAction func fahrenHeitFieldEditingChanged(_ textField:UITextField){
        if let text=textField.text, let value=Double(text){
            fahrenHeitValue=Measurement(value: value, unit:.fahrenheit)
        }else{
            fahrenHeitValue=nil
        }
    }
    @IBAction func dismissKeyboard(_ sender:UITapGestureRecognizer){//手势识别（点击识别）
        textField.resignFirstResponder();//这个函数会释放textField的键盘。
    }
    
    func updateCelsiusLabel(){//更新摄氏度标签
        if let celsiusValue=celsiusValue{
            //celsiusLabel.text="\(celsiusValue.value)"//反斜杠转义字符
            celsiusLabel.text=numberFormatter.string(from:NSNumber(value:celsiusValue.value))
        }else{
            celsiusLabel.text="请输入正确数字"
        }
    }
    // MARK: UITextfield的委托
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    //使用CharacterSet判断字符串和集合的关系
        let charSet=CharacterSet.letters //静态变量，可以直接调
        if string.rangeOfCharacter(from: charSet) != nil{
            return false
        }
        
    //禁止多个小数点
    let existingTextHasDecimalSeparator=textField.text?.range(of:".")
    let replacementTextHasDecimalSeparator=string.range(of:".")
        if existingTextHasDecimalSeparator != nil,replacementTextHasDecimalSeparator != nil{
            return false;
        }else{
            return true;
        }
    }
    
    
    
}
