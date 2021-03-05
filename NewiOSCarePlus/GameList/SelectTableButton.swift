//
//  SelectTableButton.swift
//  NewiOSCarePlus
//
//  Created by 이승재 on 2021/03/05.
//

import UIKit

class SelectTableButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitleColor(UIColor.init(named: "black"), for: .selected)
        setTitleColor(UIColor.init(named: "VeryLightPink"), for: .normal)
        tintColor = .clear
    }

}
