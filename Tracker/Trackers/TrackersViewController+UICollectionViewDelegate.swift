//
//  TrackersViewController+UICollectionViewDelegate.swift
//  Tracker
//
//  Created by Мамытов Руслан on 27.08.2026.
//
import UIKit

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        
        guard let tracker = viewModel.tracker(at: indexPath) else { return nil }
        let completionDetails = viewModel.completionDetails(for: tracker, on: datePicker.date)
        
        return UIContextMenuConfiguration(
            identifier: indexPath as NSCopying,
            previewProvider: nil
        ) { [weak self] _ in
            guard let self else { return nil }
            
            let editAction = UIAction(
                title: NSLocalizedString("edit_action_title", comment: "Edit tracker")
            ) { _ in
                self.editTracker(for: tracker, at: indexPath, with: completionDetails.count)
            }
            
            let deleteAction = UIAction(
                title: NSLocalizedString("delete_action_title", comment: "Delete tracker"),
                attributes: .destructive
            ) { _ in
                self.showDeleteAlert(for: tracker)
            }
            
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForPreviewAtConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        
        guard
            let indexPath = configuration.identifier as? IndexPath,
            let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell
        else { return nil }
        
        let parameters = UIPreviewParameters()
        parameters.visiblePath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: 16)
        
        return UITargetedPreview(view: cell, parameters: parameters)
    }
    
    private func showDeleteAlert(for tracker: Tracker) {
        let alert = UIAlertController(
            title: NSLocalizedString("trackers_delete_alert_title", comment: "Delete alert title"),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let deleteAction = UIAlertAction(
            title: NSLocalizedString("delete_action_title", comment: "Delete tracker"),
            style: .destructive
        ) { [weak self] _ in
            guard let self else { return }
            
            viewModel.deleteTracker(tracker)
        }
        
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("cancel_action_title", comment: "Отменить"),
            style: .cancel
        )
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
}
