//
//  GameDetailViewController.swift
//  NewiOSCarePlus
//
//  Created by 이승재 on 2021/03/05.
//

import UIKit

class GameDetailViewController: UIViewController {
    
    @IBOutlet private weak var containerViewController: UIView!
    var model: NewGameContent?
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? GameDetailPageViewController
        destination?.model = model
        
    }
    

 

}
