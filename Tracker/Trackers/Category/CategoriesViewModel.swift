//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Мамытов Руслан on 20.08.2026.
//

import Foundation

final class CategoriesViewModel {
    // MARK: - Public properties
    var onCategoriesUpdated: Binding<Void>?
    var onEmptyStateChanged: Binding<Bool>?
    var onSelectionChanged: Binding<Void>?
    var numberOfCategories: Int {
        return categories.count
    }
    
    // MARK: - Private properties
    private let dataProvider: TrackersDataProvider
    private var categories: [String] = [] {
        didSet {
            onCategoriesUpdated?(())
            onEmptyStateChanged?(categories.isEmpty)
        }
    }
    
    private(set) var selectedCategory: String?
    
    // MARK: - Initializer
    init(dataProvider: TrackersDataProvider, initialSelection: String? = nil) {
        self.dataProvider = dataProvider
        self.selectedCategory = initialSelection
    }
    
    // MARK: - Public Methods
    func loadCategories() {
        self.categories = dataProvider.fetchAllCategories()
    }
    
    func selectCategory(at index: Int) {
        guard index < categories.count else { return }
        selectedCategory = categories[index]
        
        onSelectionChanged?(())
    }
    
    func addNewCategory(title: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        
        dataProvider.addCategory(with: trimmedTitle)
        loadCategories()
    }
    
    func deleteCategory(at index: Int) {
        guard index < categories.count else { return }
        let targetCategory = categories[index]
        
        if targetCategory == selectedCategory {
            selectedCategory = nil
        }
        
        dataProvider.deleteCategory(with: targetCategory)
        loadCategories()
    }
    
    func editCategory(at index: Int, newTitle: String) {
        guard index < categories.count else { return }
        let oldTitle = categories[index]
        
        if oldTitle == selectedCategory {
            selectedCategory = newTitle
        }
        
        dataProvider.updateCategory(oldTitle: oldTitle, newTitle: newTitle)
        loadCategories()
    }
    
    func category(at index: Int) -> String {
        return categories[index]
    }
    
    func isCategorySelected(at index: Int) -> Bool {
        return categories[index] == selectedCategory
    }
}
