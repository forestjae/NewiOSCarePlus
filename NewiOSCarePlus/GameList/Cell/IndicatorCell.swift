//
//  IndicatorCell.swift
//  NewiOSCarePlus
//
//  Created by 이승재 on 2021/03/05.
//

import UIKit

class IndicatorCell: UITableViewCell {

    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    func animationIndicatorView() {
        activityIndicatorView.startAnimating()
    }
}
