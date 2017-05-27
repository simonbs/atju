//
//  CollectionView.swift
//  Atju
//
//  Created by Simon Støvring on 20/01/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation
import UIKit

/// Removes boilerplate when working with collection views
/// by exposing the layout with the correct type and creating
/// an initializer that takes no arguments.
public class CollectionView<Layout: UICollectionViewLayout>: UICollectionView {
    /// Layout of the collection view.
    public var layout: Layout {
        return collectionViewLayout as! Layout
    }
    
    public init() {
        super.init(frame: .zero, collectionViewLayout: Layout())
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
