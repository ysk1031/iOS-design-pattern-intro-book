//
//  TimeLineViewController.swift
//  iosDesignPatternMvvm
//
//  Created by Yusuke Aono on 2018/09/04.
//  Copyright © 2018 Yusuke Aono. All rights reserved.
//

import UIKit
import SafariServices

final class TimeLineViewController: UIViewController {
    
    private var viewModel: UserListViewModel!
    private var tableView: UITableView!
    private var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TimeLineTableViewCell.self, forCellReuseIdentifier: "TimeLineCell")
        view.addSubview(tableView)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(self.refreshControlValueDidChange(sender:)),
                                 for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        viewModel = UserListViewModel()
        viewModel.stateDidUpdate = { [weak self] (state: UserListViewModelState) in
            guard let `self` = self else { return }
            switch state {
            case .loading:
                self.tableView.isUserInteractionEnabled = false
            case .finish:
                self.tableView.isUserInteractionEnabled = true
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            case .error(let error):
                self.tableView.isUserInteractionEnabled = false
                self.refreshControl.endRefreshing()
                
                let alertController = UIAlertController(title: error.localizedDescription,
                                                        message: nil,
                                                        preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
            }
        }
        viewModel.getUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func refreshControlValueDidChange(sender: UIRefreshControl) {
        viewModel.getUsers()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDelegate
extension TimeLineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        let webViewVc = SFSafariViewController(url: cellViewModel.webUrl)
        navigationController?.pushViewController(webViewVc, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TimeLineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usersCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let timeLineCell = tableView.dequeueReusableCell(withIdentifier: "TimeLineCell",
                                                               for: indexPath) as? TimeLineTableViewCell else
        {
            fatalError()
        }
        
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        timeLineCell.setNickName(nickName: cellViewModel.nickName)
        cellViewModel.downloadImage { (progress: ImageDownloadProgress) in
            switch progress {
            case .loading(let image):
                timeLineCell.setIcon(icon: image)
            case .finish(let image):
                timeLineCell.setIcon(icon: image)
            case .error:
                break
            }
        }
        return timeLineCell
    }
}
