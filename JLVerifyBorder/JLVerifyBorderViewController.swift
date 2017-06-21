import UIKit
import SnapKit

class JLVerifyBorderViewController: UIViewController, UITextFieldDelegate {
    
    let verifyNum       = 4    //验证码位数
    let gap             = 20   //每个框之间的间隙
    let width           = 60   //每个框的 宽和高
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:=========== 创建 ===========
    var  verTF:UITextField?
    func createViews() {
        let backView                            = UIView()
        self.view.addSubview(backView)
        backView.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.width.equalTo(verifyNum * width + (verifyNum - 1) * gap)
            make.height.equalTo(width)
            make.centerX.equalTo(self.view)
        }
        
        var tmpLabel :UILabel?
        for i in 0..<verifyNum {
            let subLabel                        = UILabel()
            subLabel.layer.cornerRadius         = 5
            subLabel.tag                        = i + 10
            subLabel.layer.masksToBounds        = true
            subLabel.layer.borderWidth          = 0.5
            subLabel.textAlignment              = NSTextAlignment.center
            subLabel.font                       = UIFont.systemFont(ofSize: 20)
            subLabel.textColor                  = UIColor.red
            subLabel.layer.borderColor          = UIColor.red.cgColor
            backView.addSubview(subLabel)
            subLabel.snp.makeConstraints({ (make) in
                make.width.height.equalTo(width)
                make.centerY.equalTo(backView)
                if tmpLabel != nil {
                    make.left.equalTo(tmpLabel!.snp.right).offset(gap)
                }else {
                    make.left.equalTo(backView)
                }
            })
            tmpLabel = subLabel
        }
        
        verTF                                   = UITextField()
        verTF?.keyboardType                     = UIKeyboardType.numberPad
        verTF?.tintColor                        = UIColor.clear
        verTF?.textColor                        = UIColor.clear
        verTF?.backgroundColor                  = UIColor.clear
        verTF?.delegate                         = self
        verTF?.addTarget(self, action: #selector(valuechanged), for: UIControlEvents.editingChanged)
        
        backView.addSubview(verTF!)
        verTF?.snp.makeConstraints { (make) in
            make.edges.equalTo(backView)
        }
        
        //避免 复制粘贴长按滑动等操作
        let forbidButton                        = UIButton()
        forbidButton.addTarget(self, action: #selector(becomeFirst), for: UIControlEvents.touchUpInside)
        backView.addSubview(forbidButton)
        forbidButton.snp.makeConstraints { (make) in
            make.edges.equalTo(backView)
        }
    }
    
    func becomeFirst() {
        verTF?.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        verTF?.becomeFirstResponder()
    }
    
    //MARK:=========== textfieldDelegate ===========
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //判断只能输入数字，并且个数不能大于 verifyNum 个。
        if range.location + string.characters.count > verifyNum{
            return false
        }
        //10进制数进行判断，防止搜狗输入法导致数字键盘失效
        let cs                      = NSCharacterSet.decimalDigits.inverted
        let a                       = string.components(separatedBy: cs).joined()
        
        if string == a {
            return true
        }else {
            return false
        }
    }
    
    func valuechanged(textfield:UITextField) {
        let cStr                    = textfield.text
        var cArray                  = [Character]()
        for c in (cStr?.characters)! {
            cArray.append(c)
        }
        
        for i in 0..<verifyNum {
            let label               = self.view.viewWithTag(10 + i) as! UILabel
            if i < cArray.count {
                label.text          = "\(cArray[i])"
                if i == verifyNum - 1 {
                    gotoLogin()
                }
            }else {
                label.text          = ""
            }
        }
    }
    
    func gotoLogin() {
        print("login")
    }
}
