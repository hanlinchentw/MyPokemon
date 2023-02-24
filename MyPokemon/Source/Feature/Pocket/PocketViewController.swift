//
//  PocketViewController.swift
//  MyPokemon
//
//  Created by 陳翰霖 on 2023/2/23.
//

import UIKit

class PocketViewController: UIViewController {
  static var cellIdentifier: String {
    NSStringFromClass(PocketViewController.self)
  }

  let tableView = UITableView()
  
  var viewModel: PocketViewModelImpl!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.fetch()

    tableView.delegate = self
    tableView.dataSource = self    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: PocketViewController.cellIdentifier)
    view.addSubview(tableView)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
  }
}

extension PocketViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: PocketViewController.cellIdentifier, for: indexPath)
    cell.textLabel?.text = viewModel.data[indexPath.row].name
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("Selected item at row \(indexPath.row)")
  }
}

extension PocketViewController: PocketViewInput {
  func onFetchCompleted() {
    self.tableView.reloadData()
  }
  
  func onFetchFailed() {
  
  }
}
