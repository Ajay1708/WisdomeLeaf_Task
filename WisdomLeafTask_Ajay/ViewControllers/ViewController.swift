//
//  ViewController.swift
//  WisdomLeafTask_Ajay
//
//  Created by Venkata Ajay Sai Nellori on 17/05/23.
//

import UIKit
import SDWebImage
class ViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    var viewModel: ViewModel!
    private let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewModel()
        addClosureBlocks()
        addRefreshControl()
        viewModel.fetchData()
    }
    /// This method adds refresh control to tableview.
    func addRefreshControl() {
        if #available(iOS 10.0, *) {
            table.refreshControl = refreshControl
        } else {
            table.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshAction(_:)), for: .valueChanged)
    }
    func addClosureBlocks() {
        // This closure block handles the activity indicator
        viewModel.updateLoadingStatus = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                let _ = self.viewModel.isLoading ? self.loader.startAnimating() : self.loader.stopAnimating()
            }
        }
        // This closure block indicates that network api returns response
        viewModel.didFinishFetch = { [weak self] in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }
    @objc func refreshAction(_ sender: UIRefreshControl) {
        refreshControl.endRefreshing()
    }
    /// This method will get called when we reach the end of scrollview
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Here i am comparing my authors array count with multiple of current page and the items count of each page. If it matches the i am incrementing currentPage and hitting api.
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height){
            if viewModel.currentPage*viewModel.limit == viewModel.authors.count{
                viewModel.pageNo = viewModel.currentPage
                viewModel.currentPage = viewModel.currentPage + 1
                viewModel.fetchData()
            }
        }
    }

}
// MARK: - TABLEVIEW DELEGATE & DATASOURCE METHODS
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.authors.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.TableCells.customCell, for: indexPath) as? CustomCell else {
            return .init()
        }
        cell.setUpCell(with: viewModel.authors[indexPath.row])
        cell.checkBtn.tag = indexPath.row
        cell.checkBtn.addTarget(self, action: #selector(btnTapAction(_:)), for: .touchUpInside)
        return cell
    }
    /// This button action changes the selected state of each row and i am reloading the particular row
    @objc func btnTapAction(_ sender: UIButton) {
        viewModel.authors[sender.tag].selected.toggle()
        DispatchQueue.main.async {
            self.table.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.authors[indexPath.row].selected {
            let alertVC = UIAlertController(title: viewModel.authors[indexPath.row].author, message: viewModel.authors[indexPath.row].url, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alertVC.addAction(action)
            self.present(alertVC, animated: true)
        }
    }
}
// MARK: - CUSTOM TABLEVIEW CELL
class CustomCell: UITableViewCell {
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorTitle: UILabel!
    @IBOutlet weak var authorDescription: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    
    /// This method sets up the data of this custom cell
    func setUpCell(with data: AuthorInfo) {
        authorTitle.text = data.author ?? ""
        authorDescription.text = data.url ?? ""
        checkBtn.isSelected = data.selected
        guard let url = URL(string:data.downloadURL ?? "") else { return }
        authorImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        authorImage.sd_setImage(with:url)
    }
}
