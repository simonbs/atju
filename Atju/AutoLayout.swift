//
//  AutoLayout.swift
//  Atju
//
//  Created by Simon Støvring on 16/06/2016.
//  Copyright © 2016 SimonBS. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var shp_horizontalCompressionResistance: UILayoutPriority {
        set { setContentCompressionResistancePriority(newValue, for: .horizontal) }
        get { return contentCompressionResistancePriority(for: .horizontal) }
    }
    
    var shp_verticalCompressionResistance: UILayoutPriority {
        set { setContentCompressionResistancePriority(newValue, for: .vertical) }
        get { return contentCompressionResistancePriority(for: .vertical) }
    }
    
    var shp_horizontalHuggingPriority: UILayoutPriority {
        set { setContentHuggingPriority(newValue, for: .horizontal) }
        get { return contentHuggingPriority(for: .horizontal) }
    }
    
    var shp_verticalHuggingPriority: UILayoutPriority {
        set { setContentHuggingPriority(newValue, for: .vertical) }
        get { return contentHuggingPriority(for: .vertical) }
    }
}

extension NSLayoutConstraint {
    func shp_setPriority(_ priority: Float) -> Self {
        self.priority = priority
        return self
    }
}

extension NSLayoutConstraint {
    /**
     Initializes a layout constraint.
     
     - parameter item:       Item to constraint.
     - parameter attribute1: Attribute of item to constraint.
     - parameter relation:   Relation between item and toItem.
     - parameter toItem:     toIt
     em to constraint.
     - parameter attribute2: Attribute of toItem to constraint to.
     - parameter multiplier: Multiplier to apply to the constraint.
     - parameter constant:   Constant to apply to the constraint.
     
     - returns: Initialized constraint.
     */
    convenience init(_ item: AnyObject, _ attribute1: NSLayoutAttribute, _ relation: NSLayoutRelation, _ toItem: AnyObject? = nil, _ attribute2: NSLayoutAttribute = .notAnAttribute, multiplier: CGFloat = 1, constant: CGFloat = 0) {
        self.init(item: item, attribute: attribute1, relatedBy: relation, toItem: toItem, attribute: attribute2, multiplier: multiplier, constant: constant)
    }
    
    /**
     Created a layout constraint.
     
     - parameter item:       Item to constraint.
     - parameter attribute1: Attribute of item to constraint.
     - parameter relation:   Relation between item and toItem.
     - parameter toItem:     toItem to constraint.
     - parameter attribute2: Attribute of toItem to constraint to.
     - parameter multiplier: Multiplier to apply to the constraint.
     - parameter constant:   Constant to apply to the constraint.
     - parameter priority:   Priority of the constraint.
     
     - returns: Created constraint.
     */
    static func shp_constraint(_ item: AnyObject, _ attribute1: NSLayoutAttribute, _ relation: NSLayoutRelation, _ toItem: AnyObject? = nil, _ attribute2: NSLayoutAttribute = .notAnAttribute, multiplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority = UILayoutPriorityRequired) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item, attribute1, relation, toItem, attribute2, multiplier: multiplier, constant: constant)
        constraint.priority = priority
        return constraint
    }
    
    /**
     Create vertical constraints relative to the superview.
     
     - parameter constraintView: View to constraint.
     - parameter topRelation:    Relation from the top of the view to the top of the superview.
     - parameter bottomRelation: Relation from the bottom of the view to the bottom of the superview.
     
     - returns: Created constraints.
     */
    static func shp_verticalEdgesEqualsSuperview(_ constraintView: UIView, topRelation: String, bottomRelation: String) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(topRelation)-[v]-\(bottomRelation)-|", options: [], metrics: nil, views: [
            "v": constraintView
            ])
    }
    
    /**
     Create horizontal constraints relative to the superview.
     
     - parameter constraintView:   View to constraint.
     - parameter leadingRelation:  Relation from the leading of the view to the leading of the superview.
     - parameter trailingRelation: Relation from the trailing of the view to the trailing of the superview.
     
     - returns: Created constraints.
     */
    static func shp_horizontalEdgesEqualsSuperview(_ constraintView: UIView, leadingRelation: String, trailingRelation: String) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(leadingRelation)-[v]-\(trailingRelation)-|", options: [], metrics: nil, views: [
            "v": constraintView
            ])
    }
    
    /**
     Create vertical and horizontal constraints relative to the superview.
     
     - parameter constraintView:   View to constraint.
     - parameter leadingRelation:  Relation from the leading of the view to the leading of the superview.
     - parameter topRelation:      Relation from the top of the view to the top of the superview.
     - parameter trailingRelation: Relation from the trailing of the view to the trailing of the superview.
     - parameter bottomRelation:   Relation from the bottom of the view to the bottom of the superview.
     
     - returns: Created constraints.
     */
    static func shp_edgesEqualsSuperview(_ constraintView: UIView, leadingRelation: String, topRelation: String, trailingRelation: String, bottomRelation: String) -> [NSLayoutConstraint] {
        return shp_verticalEdgesEqualsSuperview(constraintView, topRelation: topRelation, bottomRelation: bottomRelation)
            + shp_horizontalEdgesEqualsSuperview(constraintView, leadingRelation: leadingRelation, trailingRelation: trailingRelation)
    }
    
    /**
     Create vertical constraints relative to the superview. The edges will be equal to each other.
     
     - parameter constraintView: View to constraint.
     
     - returns: Created constraints.
     */
    static func shp_verticalEdgesEqualsSuperview(_ constraintView: UIView) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: "V:|[v]|", options: [], metrics: nil, views: [
            "v": constraintView
            ])
    }
    
    /**
     Create horizontal constraints relative to the superview. The edges will be equal to each other.
     
     - parameter constraintView: View to constraint.
     
     - returns: Created constraints.
     */
    static func shp_horizontalEdgesEqualsSuperview(_ constraintView: UIView) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: "H:|[v]|", options: [], metrics: nil, views: [
            "v": constraintView
            ])
    }
    
    /**
     Create vertical and horizontal constraints relative to the superview. The edges will be equal to each other.
     
     - parameter constraintView: View to constraint.
     
     - returns: Created constraints.
     */
    static func shp_edgesEqualsSuperview(_ constraintView: UIView) -> [NSLayoutConstraint] {
        return shp_verticalEdgesEqualsSuperview(constraintView)
            + shp_horizontalEdgesEqualsSuperview(constraintView)
    }
}

extension UIView {
    /**
     Adds a constraint to the view and returns the constraint.
     
     - parameter constraint: Constraint to add to the view.
     
     - returns: Added constraint.
     */
    func shp_addConstraint(_ constraint: NSLayoutConstraint) -> NSLayoutConstraint {
        addConstraint(constraint)
        return constraint
    }
}
