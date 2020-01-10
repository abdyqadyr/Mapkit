//
//  EditViewController.swift
//  MapkitTask
//
//  Created by Abdykadyr Maksat on 02.11.19.
//  Copyright © 2019 Abdykadyr Maksat. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    var place: LocationModel?
    var indexPath: Int?

    
    lazy var cityTextField: UITextField = {
        let text  = UITextField(frame: .zero)
        text.layer.cornerRadius = 5
        text.layer.masksToBounds = true
        text.placeholder = "city"
        text.borderColor = UIColor.init(red: 12, green: 208, blue: 247)
        text.textColor = .blue
        text.setLeftPaddingPoints(10)
        text.layer.borderWidth = 1.0
        text.backgroundColor = .white
        text.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.ultraLight)
        return text
    }()
    
    lazy var descTextField: UITextField  = {
        let text  = UITextField(frame: .zero)
        text.layer.cornerRadius = 5
        text.layer.masksToBounds = true
        text.setLeftPaddingPoints(10)
        text.borderColor = UIColor.init(red: 12, green: 208, blue: 247)
        text.layer.borderWidth = 1.0
        text.placeholder = "description"
        text.textColor = .blue
        text.backgroundColor = .white
        text.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.ultraLight)
        return text
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Add text", for: .normal)
        button.backgroundColor = .white
        button.borderColor = UIColor.init(red: 12, green: 208, blue: 247)
        button.setTitleColor(UIColor.init(red: 12, green: 208, blue: 247), for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1.0
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        if let place = place {
            cityTextField.text = place.title
            descTextField.text = place.subtitile
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews(){
        view.addSubview(cityTextField)
        view.addSubview(descTextField)
        view.addSubview(saveButton)
        view.backgroundColor = .white
//        self.title = place?.title
    }
    
    
    @objc func save(){
        navigationController?.popViewController(animated: true)
    }
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
