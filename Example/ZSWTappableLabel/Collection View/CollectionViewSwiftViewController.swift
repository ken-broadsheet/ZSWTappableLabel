//
//  CollectionViewSwiftViewController.swift
//  ZSWTappableLabel_Example
//
//  Created by Zac West on 4/20/19.
//  Copyright © 2019 Zachary West. All rights reserved.
//

import UIKit
import ZSWTappableLabel
import SafariServices
import SnapKit

class CollectionViewSwiftViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ZSWTappableLabelTapDelegate, ZSWTappableLabelLongPressDelegate {
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = true
        collectionView.register(CollectionViewSwiftCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewSwiftCell
        
        cell.label.longPressDelegate = self
        cell.label.tapDelegate = self
        
        cell.label.attributedText = NSAttributedString(string: String(format: "Hello %d", indexPath.item), attributes: [
            .link: URL(string: String(format: "https://google.com/search?q=index+%d", indexPath.item))!,
            .tappableRegion: true,
            .tappableHighlightedBackgroundColor: UIColor.lightGray,
        ])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    // MARK: - ZSWTappableLabelTapDelegate
    func tappableLabel(_ tappableLabel: ZSWTappableLabel, tappedAt idx: Int, withAttributes attributes: [NSAttributedString.Key : Any] = [:]) {
        guard let URL = attributes[.link] as? URL else {
            return
        }
        
        show(SFSafariViewController(url: URL), sender: self)
    }
    
    // MARK: - ZSWTappableLabelLongPressDelegate
    func tappableLabel(_ tappableLabel: ZSWTappableLabel, longPressedAt idx: Int, withAttributes attributes: [NSAttributedString.Key : Any] = [:]) {
        guard let URL = attributes[.link] as? URL else {
            return
        }
        
        present(UIActivityViewController(activityItems: [URL], applicationActivities: nil), animated: true, completion: nil)
    }
}

class CollectionViewSwiftCell: UICollectionViewCell {
    let label = ZSWTappableLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
