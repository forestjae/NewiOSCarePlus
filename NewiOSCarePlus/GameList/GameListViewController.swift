//
//  GameListViewController.swift
//  NewiOSCarePlus
//
//  Created by 이승재 on 2021/03/05.
//

import UIKit
import Alamofire

class GameListViewController: UIViewController {
    @IBOutlet private weak var newButton: SelectTableButton!
    @IBOutlet private weak var saleButton: SelectTableButton!
    @IBOutlet private weak var selectedLineCenterConstraints: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    
    @IBAction private func newButtonTouchUp(_ sender: UIButton) {
        newButton.isSelected = true
        saleButton.isSelected = false
        
        UIView.animate(withDuration: 0.1) {
            self.selectedLineCenterConstraints.constant = 0
            self.view.layoutIfNeeded()
        }
        selectedLineCenterConstraints.constant = 0
        
        resetPropertiesForURL()
        
        gameListApiCall(newGameListURL)
    }
    
    @IBAction private func saleButtonTouchUp(_ sender: UIButton) {
        newButton.isSelected = false
        saleButton.isSelected = true
        
        let constant = saleButton.center.x - newButton.center.x
        
        UIView.animate(withDuration: 0.1) {
            self.selectedLineCenterConstraints.constant = constant
            self.view.layoutIfNeeded()
        }

        resetPropertiesForURL()
        
        gameListApiCall(newGameListURL)
    }
    
    private var newGameListURL: String {
        "https://ec.nintendo.com/api/KR/ko/search/new?count=\(newCount)&offset=\(newOffset)"
    }
    
    private var saleGameListURL: String {
        "https://ec.nintendo.com/api/KR/ko/search/sales?count=\(newCount)&offset=\(newOffset)"
    }
    
    private var newCount: Int = 10
    private var newOffset: Int = 0
    private var isEnd: Bool = false
    private var model: NewGameResponse? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var checkURL: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.register(GameItemCodeTableViewCell.self, forCellReuseIdentifier: "GameItemCodeTableViewCell")
        setTableViewDefault()
        gameListApiCall(newGameListURL)
    }
    
    private func setTableViewDefault() {
        tableView.tableFooterView = UIView()
    }
    
    private func resetPropertiesForURL() {
        newCount = 10
        newOffset = 0
        model = nil
    }
    
    private func gameListApiCall(_ url: String) {
        self.checkURL = url
        AF.request(url).responseJSON { [weak self] response in
            guard let data = response.data else { return }
            let decoder = JSONDecoder()
            guard let model = try? decoder.decode(NewGameResponse.self, from: data) else { return }
            if self?.model == nil {
                self?.model = model
                self?.tableView.tableFooterView = nil
            } else {
                if model.contents.isEmpty {
                    self?.isEnd = true
                }
                self?.model?.contents.append(contentsOf: model.contents)
            }
        }
    }
    
}

extension GameListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let gameDetailViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "GameDetailViewController") as? GameDetailViewController else { return }
        gameDetailViewController.model = model?.contents[indexPath.row]
        navigationController?.pushViewController(gameDetailViewController, animated: true)
    }
}

extension GameListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isEnd {
            return (model?.contents.count ?? 0)
        }
        return(model?.contents.count ?? 0) + 1
    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "GameItemCodeTableViewCell", for: indexPath) {
//            return cell
//        }
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isIndicatorCell(indexPath) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IndicatorCell") as? IndicatorCell else {
                return UITableViewCell()
            }
            cell.animationIndicatorView()
            return cell
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameItemTableViewCell", for: indexPath) as?
                GameItemTableViewCell else {
            return UITableViewCell()
        }
        
        guard let content = model?.contents[indexPath.row] else {
            return UITableViewCell()
        }
        
        let model = GameItemModel(gameTitle: content.formalName, gameOriginPrice: 10000, gameDiscountPrice: nil, imageURL: content.heroBannerURL)
        cell.setModel(model)
        return cell
    }
    
    private func isIndicatorCell(_ indexPath: IndexPath) -> Bool {
        indexPath.row == model?.contents.count
    }
}
