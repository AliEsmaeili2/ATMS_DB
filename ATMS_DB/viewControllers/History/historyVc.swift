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

class historyVc: UIViewController {
    
    private let emptyStateImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureEmptyStateView()
        
      //  updateEmptyStateView()
        
    }
    // MARK: functions
    
    private func configureEmptyStateView() {
        // Configure empty state image
        let largeIconSize: CGFloat = 99
        
        let emptyStateImage = UIImage(systemName: "mail.and.text.magnifyingglass.rtl")?.withRenderingMode(.alwaysTemplate)
        //     let emptyStateImage = UIImage(named: "news")?.withRenderingMode(.alwaysTemplate)
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
        descriptionLabel.text = "Looks like you haven't bought a Ticket yet. Add a new Ticket to be displayed on this page."
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
    
//    private func updateEmptyStateView() {
//        // Determine whether to show or hide the empty state view based on your logic
//        let shouldShowEmptyState = pdfURLs.isEmpty
//
//        if shouldShowEmptyState {
//            emptyStateImageView.isHidden = false
//            titleLabel.isHidden = false
//            descriptionLabel.isHidden = false
//        } else {
//            emptyStateImageView.isHidden = true
//            titleLabel.isHidden = true
//            descriptionLabel.isHidden = true
//        }
//    }
}
