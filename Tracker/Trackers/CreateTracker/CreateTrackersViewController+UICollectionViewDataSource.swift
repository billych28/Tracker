//
//  CreateTrackersViewController+DataSource.swift
//  Tracker
//
//  Created by Мамытов Руслан on 17.08.2026.
//

import UIKit

enum Section: Int {
    case emoji = 0
    case color
}

extension CreateTrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = Section(rawValue: section) else { return 0 }
        
        switch sectionType {
        case .emoji: return emojis.count
        case .color: return emojis.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectableItemCell.identifier, for: indexPath) as? SelectableItemCell,
            let currentSection = Section(rawValue: indexPath.section)
        else {
            return UICollectionViewCell()
        }
        
        let isSelected: Bool
        if currentSection == .emoji {
            isSelected = (indexPath == selectedEmojiIndexPath)
            cell.configure(withEmoji: emojis[indexPath.row], isSelected: isSelected)
        } else {
            isSelected = (indexPath == selectedColorIndexPath)
            cell.configure(withColor: colors[indexPath.row], isSelected: isSelected)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableView.identifier, for: indexPath) as? HeaderReusableView,
            let currentSection = Section(rawValue: indexPath.section)
        else {
            return UICollectionReusableView()
        }
        
        let title = currentSection == .emoji ? "Emoji" : "Цвет"
        header.titleLabel.text = title
        return header
    }
}
