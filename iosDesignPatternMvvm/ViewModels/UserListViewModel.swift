//
//  UserListViewModel.swift
//  iosDesignPatternMvvm
//
//  Created by Yusuke Aono on 2018/09/04.
//  Copyright © 2018 Yusuke Aono. All rights reserved.
//

import UIKit

enum UserListViewModelState {
    case loading, finish, error(Error)
}

final class UserListViewModel {
    var stateDidUpdate: ((UserListViewModelState) -> Void)?
    
    private var users: [User] = []
    var cellViewModels: [UserCellViewModel] = []
    var usersCount: Int {
        return users.count
    }
    
    func getUsers() {
        stateDidUpdate?(.loading)
        users.removeAll()
        
        Api().getUsers(success: { [weak self] users in
            guard let `self` = self else { return }
            self.users = users
            self.cellViewModels = users.map { UserCellViewModel(user: $0) }
            self.stateDidUpdate?(.finish)
        }) { error in
            self.stateDidUpdate?(.error(error))
        }
    }
}
