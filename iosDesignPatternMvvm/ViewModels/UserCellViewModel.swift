//
//  UserCellViewModel.swift
//  iosDesignPatternMvvm
//
//  Created by Yusuke Aono on 2018/09/04.
//  Copyright © 2018 Yusuke Aono. All rights reserved.
//

import UIKit

enum ImageDownloadProgress {
    case loading(UIImage), finish(UIImage), error
}

final class UserCellViewModel {
    private var user: User
    
    private var isLoading = false
    
    var nickName: String {
        return user.name
    }
    var webUrl: URL {
        return URL(string: user.webUrl)!
    }
    
    init(user: User) {
        self.user = user
    }
    
    func downloadImage(progress: @escaping (ImageDownloadProgress) -> Void) {
        if isLoading == true {
            return
        }
        isLoading = true
        
        let loadingImage = UIImage(color: .gray, size: CGSize(width: 45, height: 45))!
        progress(.loading(loadingImage))
        
        ImageDownloader().downloadImage(
            imageUrl: user.iconUrl,
            success: { [weak self] image in
                guard let `self` = self else { return }
                progress(.finish(image))
                self.isLoading = false
        }) { error in
            progress(.error)
            self.isLoading = false
        }
    }
}
