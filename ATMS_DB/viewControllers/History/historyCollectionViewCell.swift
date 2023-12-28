//
//  historyCollectionViewCell.swift
//  ATMS_DB
//
//  Created by Ali Esmaeili on 12/28/23.
//

import UIKit
import PDFKit
import CoreData

class historyCollectionViewCell: UICollectionViewCell {
    
    var pdfView: PDFView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPDFView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPDFView()
    }
    
    private func setupPDFView() {
        pdfView = PDFView(frame: contentView.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.isUserInteractionEnabled = false // Disable user interaction
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.usePageViewController(true, withViewOptions: nil)
        pdfView.autoScales = true
        pdfView.minScaleFactor = pdfView.scaleFactorForSizeToFit
        pdfView.maxScaleFactor = pdfView.scaleFactorForSizeToFit
        contentView.addSubview(pdfView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pdfView.document = nil
    }
}
