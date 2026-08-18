//
//  TrackersViewController+UICollectionViewDelegateFlowLayout.swift
//  Tracker
//
//  Created by Мамытов Руслан on 12.08.2026.
//
import UIKit

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerView = HeaderReusableView()
        
        headerView.titleLabel.text = dataProvider.categoryTitle(at: section)
        
        let targetSize = CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height)
        let estimatedSize = headerView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return CGSize(width: collectionView.frame.width, height: estimatedSize.height > 0 ? estimatedSize.height : 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 10, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        collectionViewParams.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - collectionViewParams.paddingWidth
        let cellWidth =  availableWidth / CGFloat(collectionViewParams.cellCount)
        return CGSize(width: cellWidth, height: 150)
    }
    
}
