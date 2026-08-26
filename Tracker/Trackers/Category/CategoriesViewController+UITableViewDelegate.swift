//
//  CategoriesViewController+UITableViewDelegate.swift
//  Tracker
//
//  Created by Мамытов Руслан on 20.08.2026.
//

import UIKit

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectCategory(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let categoryTitle = self.viewModel.category(at: indexPath.row)
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            guard let self = self else { return UIMenu() }
            
            return getContextMenu(for: categoryTitle, at: indexPath)
        }
    }
    
    private func getContextMenu(for categoryTitle: String, at indexPath: IndexPath) -> UIMenu {
        let editAction = UIAction(title: "Редактировать") { _ in
            let editCategoryVC = CreateCategoryViewController()
            editCategoryVC.title = "Редактирование категории"
            editCategoryVC.setInitialText(with: categoryTitle)
            
            editCategoryVC.onCategoryCreated = { [weak self] updatedTitle in
                guard let self else { return }
                updateCategory(at: indexPath, with: updatedTitle)
            }
            
            let navController = UINavigationController(rootViewController: editCategoryVC)
            self.present(navController, animated: true)
        }
        
        let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { _ in
            let alert = UIAlertController(
                title: "Эта категория точно не нужна?",
                message: nil,
                preferredStyle: .actionSheet
            )
            
            let confirmDelete = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
                guard let self else { return }
                deleteCategory(at: indexPath)
            }
            
            let cancel = UIAlertAction(title: "Отменить", style: .cancel)
            
            alert.addAction(confirmDelete)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }
        
        return UIMenu(title: "", children: [editAction, deleteAction])
    }
}
