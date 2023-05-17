//
//  ViewModel.swift
//  WisdomLeafTask_Ajay
//
//  Created by Venkata Ajay Sai Nellori on 17/05/23.
//

import Foundation
class ViewModel: ViewModelProtocols {
    
    private let urlString = "https://picsum.photos/v2/list?"
    var currentPage = 1
    var pageNo = 0
    var limit = 20
    var authors = [AuthorInfo]()

    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var didFinishFetch: (()->())?
    var updateLoadingStatus: (()->())?
    
    func fetchData() {
        isLoading = true
        if let url = URL(string: urlString + "page=\(pageNo)" + "&limit=\(limit)") {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            let session = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
                guard let self = self else {return}
                self.isLoading = false
                guard error == nil else {
                    print("Api fail due to \(error?.localizedDescription ?? "")")
                    return
                }
                guard let data = data else {
                    print("Api fails")
                    return
                }
                do {
                    let data = try JSONDecoder().decode([AuthorInfo].self, from: data)
                    if currentPage-1 != 0 {
                        let newAuthors = data
                        self.authors.append(contentsOf: newAuthors)
                    }
                    else{
                        self.authors = data
                    }
                    self.didFinishFetch?()
                } catch let err {
                    print("Api fails due to \(err.localizedDescription)")
                }
            }
            session.resume()
        }
    }
}


