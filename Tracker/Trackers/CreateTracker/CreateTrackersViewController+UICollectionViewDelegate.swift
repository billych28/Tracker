//
//  CreateTrackersViewController+UICollectionViewDelegate.swift
//  Tracker
//
//  Created by Мамытов Руслан on 17.08.2026.
//

import UIKit

extension CreateTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let currentSection = Section(rawValue: indexPath.section) else { return }
        
        var indexPathsToReload: [IndexPath] = [indexPath]
        
        switch currentSection {
        case .emoji:
            if indexPath == selectedEmojiIndexPath { return }
            
            if let previousPath = selectedEmojiIndexPath {
                indexPathsToReload.append(previousPath)
            }
            selectedEmojiIndexPath = indexPath
            
        case .color:
            if indexPath == selectedColorIndexPath { return }
            
            if let previousPath = selectedColorIndexPath {
                indexPathsToReload.append(previousPath)
            }
            selectedColorIndexPath = indexPath
        }
        
        collectionView.reloadItems(at: indexPathsToReload)
        checkFormValidation()
    }
}
