//
//  TrackersViewController+UICollectionViewDataSource.swift
//  Tracker
//
//  Created by Мамытов Руслан on 12.08.2026.
//
import UIKit

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.trackersHeaderIdentifier, for: indexPath) as? CategoryHeaderView else {
                return UICollectionViewCell()
            }
            
            if indexPath.section < visibleCategories.count {
                header.titleLabel.text = visibleCategories[indexPath.section].title
            }
            
            return header
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.trackerCellIdentifier, for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        
        let isCompletedToday = completedTracker.contains { record in
            record.id == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: currentDate)
        }
        
        let totalCompletedDays = completedTracker.filter { $0.id == tracker.id }.count
        
        cell.delegate = self
        cell.emojiLabel.text = tracker.emoji
        cell.titleLabel.text = tracker.name
        cell.setIsCompleted(with: totalCompletedDays, isCompleted: isCompletedToday)
        
        return cell
    }
    
}
