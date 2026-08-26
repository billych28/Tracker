//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Мамытов Руслан on 20.08.2026.
//

import UIKit

enum CategoriesViewControllerConstants {
    static let dismissDelay = 0.3
}

protocol CategoryListViewControllerDelegate: AnyObject {
    func didSelectCategory(_ categoryName: String)
}

final class CategoriesViewController: UIViewController {
    // MARK: - Public properties
    weak var delegate: CategoryListViewControllerDelegate?
    let viewModel: CategoriesViewModel
    
    // MARK: - Private properties
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var emptyView: EmptyView = {
        let view = EmptyView(frame: .zero)
        view.setTitle(to: "Привычки и события можно\nобъединить по смыслу")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let addCategoryButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Добавить категорию"
        config.baseBackgroundColor = UIColor(resource: .black)
        config.baseForegroundColor = .white
        
        let button = UIButton(configuration: config)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializer
    init(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Категория"
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        
        setupUI()
        setupButton()
        bindViewModel()
        
        viewModel.loadCategories()
    }
    
    // MARK: - Public methods
    func updateCategory(at indexPath: IndexPath, with updatedTitle: String) {
        viewModel.editCategory(at: indexPath.row, newTitle: updatedTitle)
        delegate?.didSelectCategory(updatedTitle)
    }
    
    func deleteCategory(at indexPath: IndexPath) {
        viewModel.deleteCategory(at: indexPath.row)
        delegate?.didSelectCategory("")
    }
    
    // MARK: - Private methods
    private func setupUI() {
        view.addSubview(tableView)
        view.addSubview(emptyView)
        view.addSubview(addCategoryButton)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -16),
            
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupButton() {
        let action = UIAction { [weak self] _ in
            guard let self else { return }
            
            didTapAddCategory()
        }
        addCategoryButton.addAction(action, for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.onCategoriesUpdated = { [weak self] _ in
            guard let self else { return }
            
            tableView.reloadData()
        }
        
        viewModel.onEmptyStateChanged = { [weak self] isEmpty in
            guard let self else { return }
            
            didEmptyStateChanged(isEmpty)
        }
        
        viewModel.onSelectionChanged = { [weak self] _ in
            guard let self else { return }
            
            didSelectionChanged()
        }
    }
    
    private func didTapAddCategory() {
        let createCategoryVC = CreateCategoryViewController()
        
        createCategoryVC.onCategoryCreated = { [weak self] newTitle in
            guard let self else { return }
            
            viewModel.addNewCategory(title: newTitle)
        }
        
        let navController = UINavigationController(rootViewController: createCategoryVC)
        present(navController, animated: true)
    }
    
    private func didEmptyStateChanged(_ isEmpty: Bool) {
        emptyView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    private func didSelectionChanged() {
        tableView.reloadData()
        if let selectedCategory = viewModel.selectedCategory {
            delegate?.didSelectCategory(selectedCategory)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + CategoriesViewControllerConstants.dismissDelay) { [weak self] in
                guard let self else { return }
                
                dismiss(animated: true)
            }
        }
    }
}
