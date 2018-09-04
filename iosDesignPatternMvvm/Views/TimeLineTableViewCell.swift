//
//  TimeLineTableViewCell.swift
//  iosDesignPatternMvvm
//
//  Created by Yusuke Aono on 2018/09/04.
//  Copyright © 2018 Yusuke Aono. All rights reserved.
//

import UIKit

final class TimeLineTableViewCell: UITableViewCell {
    
    private var iconView: UIImageView!
    private var nickNameLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        iconView = UIImageView()
        iconView.clipsToBounds = true
        contentView.addSubview(iconView)
        
        nickNameLabel = UILabel()
        nickNameLabel.font = UIFont.systemFont(ofSize: 15)
        contentView.addSubview(nickNameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame = CGRect(x: 15, y: 15, width: 45, height: 45)
        iconView.layer.cornerRadius = iconView.frame.width / 2
        
        nickNameLabel.frame = CGRect(x: iconView.frame.maxX + 15,
                                     y: iconView.frame.origin.y,
                                     width: contentView.frame.width - iconView.frame.maxX - 30,
                                     height: 15)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setNickName(nickName: String) {
        nickNameLabel.text = nickName
    }
    
    func setIcon(icon: UIImage) {
        iconView.image = icon
    }
}
