//
//  CreateTrackerViewController+UICollectionView.swift
//  Tracker
//
//  Created by Мамытов Руслан on 17.08.2026.
//

import UIKit

extension CreateTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = itemSpacing - (columnsCount - 1)
        let availableWidth = collectionView.bounds.width - CGFloat(paddingSpace)
        let widthPerItem = floor(availableWidth / CGFloat(columnsCount))
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let currentSection = Section(rawValue: section) else { return CGSize(width: 0, height: 0) }
        let headerView = HeaderReusableView()
        
        let emojiSectionTitle = NSLocalizedString("create_tracker_emoji_section_title", comment: "Title for emoji section")
        let colorSectionTitle = NSLocalizedString("create_tracker_color_section_title", comment: "Title for color section")
        
        headerView.titleLabel.text = currentSection == .emoji ? emojiSectionTitle : colorSectionTitle
        
        let targetSize = CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height)
        let estimatedSize = headerView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return CGSize(width: collectionView.frame.width, height: estimatedSize.height > 0 ? estimatedSize.height : 42)
    }
}
