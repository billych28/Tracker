//
//  CategoriesViewController+UITableViewDataSource.swift
//  Tracker
//
//  Created by Мамытов Руслан on 20.08.2026.
//

import UIKit

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCategories
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell
        else {
            return UITableViewCell()
        }
        
        let categoryName = viewModel.category(at: indexPath.row)
        cell.configure(with: categoryName, isSelected: viewModel.isCategorySelected(at: indexPath.row))
        
        return cell
    }
}
