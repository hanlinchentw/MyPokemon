//
//  PokemonDetailView.swift
//  MyPokemon
//
//  Created by Leo Chen on 2023/2/23.
//

import Kingfisher
import UIKit

class PokemonDetailView: UIView {
  
  // UI Components
  let imageView = UIImageView()
  let tableView = UITableView()
  
  // Data
  var pokemonDetail: PokemonDetail? {
    didSet {
      configure()
    }
  }
  
  // Lifecycle
  init() {
    super.init(frame: .zero)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // Setup UI
  func configure() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
      if let urlString = self.pokemonDetail?.imageUrl,
          let url = URL(string: urlString) {
        self.imageView.kf.setImage(with: url)
      } else {
        self.imageView.image = UIImage(systemName: "questionmark")
        self.imageView.tintColor = .lightGray
      }
    }
  }
  
  func setupUI() {
    DispatchQueue.main.async {
      self.backgroundColor = .white
      self.addSubview(self.imageView)
      self.imageView.translatesAutoresizingMaskIntoConstraints = false
      self.imageView.contentMode = .scaleAspectFit
      NSLayoutConstraint.activate([
        self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
        self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
        self.imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
        self.imageView.widthAnchor.constraint(equalToConstant: 120),
        self.imageView.heightAnchor.constraint(equalToConstant: 120)
      ])
      
      // UITableView
      self.tableView.translatesAutoresizingMaskIntoConstraints = false
      self.tableView.dataSource = self
      self.tableView.delegate = self
      self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
      self.tableView.tableFooterView = UIView() // 隱藏 UITableView 底部多餘的 separator line
      self.tableView.backgroundColor = .lightGray // 使用 group style 的背景顏色
      self.addSubview(self.tableView)
      
      NSLayoutConstraint.activate([
        self.tableView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor),
        self.tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        self.tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        self.tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
      ])
    }
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PokemonDetailView: UITableViewDataSource, UITableViewDelegate {
  // UITableView 的 section 數量
  func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  // 每個 section 中的 row 數量
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1 // Pokemon 編號
    case 1:
      return 2 // 身高和體重
    case 2:
      return pokemonDetail?.types.count ?? 0 // Pokemon 類型
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    var content = cell.defaultContentConfiguration()
    content.prefersSideBySideTextAndSecondaryText = true
    switch indexPath.section {
    case 0:
      if indexPath.row == 0 {
        content.text = "編號: \(pokemonDetail?.id ?? 0)"
      }
    case 1:
      if indexPath.row == 0 {
        content.text = "身高"
        content.secondaryText = "\(pokemonDetail?.height ?? 0) cm"
        
      } else if indexPath.row == 1 {
        content.text = "體重"
        content.secondaryText = "\(pokemonDetail?.weight ?? 0) kg"
      }
    case 2:
      content.text = pokemonDetail?.types[indexPath.row]
    default:
      break
    }
    cell.contentConfiguration = content
    return cell
  }
  
  // UITableView 的 header 標題
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return pokemonDetail?.name.capitalized
    case 1:
      return "體格資訊"
    case 2:
      return "屬性"
    default:
      return nil
    }
  }
  
  // UITableView 的 header 標題高度
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
  // UITableView 的 header 標題樣式
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = .white
    
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    label.textColor = .darkGray
    label.text = self.tableView(tableView, titleForHeaderInSection: section)
    headerView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
      label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
      label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10)
    ])
    
    return headerView
  }
}
