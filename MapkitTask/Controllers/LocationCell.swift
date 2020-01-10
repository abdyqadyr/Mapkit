//
//  LocationCell.swift
//  MapkitTask
//
//  Created by Abdykadyr Maksat on 02.11.19.
//  Copyright © 2019 Abdykadyr Maksat. All rights reserved.
//

import Foundation
import UIKit
class LocationCell: UITableViewCell{
    lazy var city: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        return label
    }()
    
    lazy var desc: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.ultraLight)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        contentView.addSubview(city)
        contentView.addSubview(desc)
    }
    
    
    
}
