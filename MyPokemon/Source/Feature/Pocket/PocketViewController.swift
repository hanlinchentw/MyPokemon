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
    tableView.isEditing = true
    tableView.delegate = self
    tableView.dataSource = self    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: PocketViewController.cellIdentifier)
    view.addSubview(tableView)
    
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.isTranslucent = false
    navigationItem.title = "My Pokemon"
    navigationController?.navigationBar.backgroundColor = .white
    navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
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

  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    .delete
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        viewModel.release(indexPath)
      }
  }
}

extension PocketViewController: PocketViewInput {
  func onFetchCompleted() {
    self.tableView.reloadData()
  }
  
  func onFetchFailed() {
  
  }
}
