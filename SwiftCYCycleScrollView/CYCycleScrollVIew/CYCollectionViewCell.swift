//
//  CYCollectionViewCell.swift
//  SwiftCYCycleScrollView
//
//  Created by cyan on 2018/2/27.
//  Copyright © 2018年 cyan. All rights reserved.
//

import UIKit

class CYCollectionViewCell: UICollectionViewCell {
    
    var titleLabel: UILabel!
    var imageView: UIImageView!
    
    var _title : NSString!
    var titleLabelTextColor:UIColor!
    var titleLabelTextFont:UIFont!
    var titleHeight:CGFloat!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        setupImageView()
        setupTitle()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = UIColor.clear
        self.imageView.frame = self.bounds
        
        let titleLabelW:CGFloat = self.bounds.width
        let titleLabelH:CGFloat = 40
        let titleLabelX:CGFloat = 0
        let titleLabelY:CGFloat = self.bounds.height - titleLabelH
        self.titleLabel.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelW, height: titleLabelW)
        self.titleLabel.isHidden  = !(_title != nil)
        
    }
    
    
    func setupImageView(){
        let imageView = UIImageView()
        self.imageView = imageView
        self.contentView.addSubview(self.imageView)
        
    }
    
    func setupTitle(){
        let titleLabel = UILabel()
        self.titleLabel = titleLabel;
        self.titleLabel.isHidden = true
        self.contentView.addSubview(self.titleLabel)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
