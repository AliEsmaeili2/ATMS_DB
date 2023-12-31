//
//  historyVc.swift
//  ATMS_DB
//
//  Created by Ali Esmaeili on 11/14/23.
//

import UIKit
import PDFKit
import CoreData
import QuickLook
import Foundation

class historyVc: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pdfURLs: [URL] = []
    var selectedPDFURL: URL?
    
    private let emptyStateImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchPDFURLsFromCoreData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(historyCollectionViewCell.self, forCellWithReuseIdentifier: "PDFCell")
        
        //  fetchPDFURLsFromCoreData()
        
        configureEmptyStateView()
        
        updateEmptyStateView()
        
    }
    // MARK: functions
    
    private func configureEmptyStateView() {
        // Configure empty state image
        let largeIconSize: CGFloat = 99
        
        let emptyStateImage = UIImage(systemName: "mail.and.text.magnifyingglass.rtl")?.withRenderingMode(.alwaysTemplate)
        // let emptyStateImage = UIImage(named: "news")?.withRenderingMode(.alwaysTemplate)
        emptyStateImageView.image = emptyStateImage
        emptyStateImageView.tintColor = .systemGray
        emptyStateImageView.contentMode = .scaleAspectFit
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStateImageView)
        
        // Configure title label
        titleLabel.text = "No Ticket Available"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Configure description label
        descriptionLabel.text = "Looks like you haven't bought a Ticket yet. buy a new Ticket to be displayed on this page."
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .gray
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        // Add constraints for the empty state view elements
        NSLayoutConstraint.activate([
            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -largeIconSize),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: largeIconSize),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: largeIconSize),
            
            titleLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func updateEmptyStateView() {
        // Determine whether to show or hide the empty state view based on your logic
        let shouldShowEmptyState = pdfURLs.isEmpty
        
        if shouldShowEmptyState {
            
            emptyStateImageView.isHidden = false
            titleLabel.isHidden = false
            descriptionLabel.isHidden = false
        }
        else {
            emptyStateImageView.isHidden = true
            titleLabel.isHidden = true
            descriptionLabel.isHidden = true
        }
    }
    
    func fetchPDFURLsFromCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            pdfURLs = results.compactMap { historyEntity in
                let pdfURL = documentsDirectoryURL.appendingPathComponent("\(historyEntity.namePDF ?? "").pdf")
                return pdfURL
            }
            
            DispatchQueue.main.async {
                
                self.collectionView.reloadData() // Reload the collection view data on the main queue
                self.updateEmptyStateView() // Update the empty state view
            }
            
            print("PDF URLs fetched from CoreData")
            
        } catch {
            print("Failed to fetch PDF URLs from CoreData: \(error)")
        }
    }
    
    
    // Add a function to delete data from CoreData and remove the file from the documents directory
    func deletePDF(at index: Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
            let results = try context.fetch(fetchRequest)
            
            if index < results.count {
                let pdfEntity = results[index]
                
                // Delete the PDF file from the documents directory
                let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let pdfURL = documentsDirectoryURL.appendingPathComponent("\(pdfEntity.namePDF ?? "").pdf")
                
                do {
                    try FileManager.default.removeItem(at: pdfURL)
                } catch {
                    print("Error deleting PDF file: \(error)")
                }
                
                // Delete the PDF entity from CoreData
                context.delete(pdfEntity)
                try context.save()
                
                // Update the data source (pdfURLs) by removing the deleted URL
                pdfURLs.remove(at: index)
                collectionView.reloadData()
                
                updateEmptyStateView()
                
                print("PDF deleted from CoreData and documents directory")
            }
        } catch {
            print("Failed to delete PDF from CoreData: \(error)")
        }
    }
    
    func configureContextMenu(index: Int) -> UIContextMenuConfiguration{
        
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] (_) -> UIMenu? in
            guard let self = self else { return nil }
            
            let preview = UIAction(title: "Preview", image: UIImage(systemName: "doc.text.magnifyingglass"), identifier: nil, discoverabilityTitle: nil, state: .off) { (_) in
                
                print("Preview button clicked")
                self.selectedPDFURL = self.pdfURLs[index]
                self.showPDFPreview()
            }
            
            let edit = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil"), identifier: nil, discoverabilityTitle: nil, state: .off) { (_) in
                print("edit button clicked")
                //add tasks...
            }
            
            let share = UIAction(title: "Share", image: UIImage(systemName: "shareplay"), identifier: nil, discoverabilityTitle: nil, state: .off) { (_) in
                print("share button clicked")
                //add tasks...
            }
            
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, attributes: .destructive, state: .off) { [weak self] (_) in
                guard let self = self else { return }
                
                let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you want to delete the PDF?", preferredStyle: .alert)
                
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (_) in
                    guard let self = self else { return }
                    print("Delete button clicked")
                    
                    self.deletePDF(at: index) // Call the delete function
                    self.collectionView.reloadData()
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                
                // Add actions to the alert controller
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            
            return UIMenu(title: "Options", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [preview,edit,share,delete])
        }
        
        return context
    }
    
    func showPDFPreview() {
        
        guard let selectedPDFURL = selectedPDFURL else { return }
        
        let previewController = QLPreviewController()
        previewController.dataSource = self
        self.present(previewController, animated: true, completion: nil)
    }
    
}

extension historyVc: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return pdfURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PDFCell", for: indexPath) as! historyCollectionViewCell
        
        let pdfURL = pdfURLs[indexPath.item]
        
        if let pdfDocument = PDFDocument(url: pdfURL) {
            
            cell.pdfView.document = pdfDocument
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        configureContextMenu(index: indexPath.row)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedPDFURL = pdfURLs[indexPath.item]
        
    }
}

extension historyVc: QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        
        return selectedPDFURL! as QLPreviewItem
    }
    
    func previewControllerDidDismiss(_ controller: QLPreviewController) {
        
        selectedPDFURL = nil
    }
}
