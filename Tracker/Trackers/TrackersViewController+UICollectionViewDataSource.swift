//
//  TrackersViewController+UICollectionViewDataSource.swift
//  Tracker
//
//  Created by Мамытов Руслан on 12.08.2026.
//
import UIKit

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderReusableView.identifier,
            for: indexPath
        ) as? HeaderReusableView else {
            return UICollectionReusableView()
        }
        
        let categoryTitle = viewModel.categoryTitle(at: indexPath.section)
        header.titleLabel.text = categoryTitle
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell,
            let tracker = viewModel.tracker(at: indexPath)
        else {
            return UICollectionViewCell()
        }
        
        cell.emojiLabel.text = tracker.emoji
        cell.titleLabel.text = tracker.name
        cell.setBackgroundColor(with: tracker.color)
        
        let details = viewModel.completionDetails(for: tracker, on: datePicker.date)
        cell.setIsCompleted(with: details.count, isCompleted: details.isCompleted)
        
        cell.delegate = self
        return cell
    }
    
}
