//
//  SectionedDataSource.swift
//  Whale
//
//  Created by Eliel A. Gordon on 3/8/17.
//  Copyright © 2017 Eliel A. Gordon. All rights reserved.
//
import UIKit

public protocol IdentifiableType {
    associatedtype Identity: Hashable
    
    var identity : Identity { get }
}

public struct SectionModel<Section, ItemType> {
    public var model: Section
    public var items: [Item]
    
    public init(model: Section, items: [Item]) {
        self.model = model
        self.items = items
    }
    
    public init(original: SectionModel<Section, Item>, items: [Item]) {
        self.model = original.model
        self.items = items
    }
}

extension SectionModel: SectionModelType {
    public typealias Identity = Section
    public typealias Item = ItemType
    
    public var identity: Section {
        return model
    }
}

public protocol SectionModelType {
    associatedtype Item
    
    var items: [Item] {get}
    
    init(original: Self, items: [Item])
}

open class SectionedDataSource<Section: SectionModelType>: NSObject, UICollectionViewDataSource {
    
    public typealias Item = Section.Item
    public typealias CellFactory = (SectionedDataSource<Section>, UICollectionView, IndexPath, Item) -> UICollectionViewCell
    public typealias SupplementaryViewFactory = (SectionedDataSource<Section>, UICollectionView, String, IndexPath) -> UICollectionReusableView
    
    open var configureCell: CellFactory!
    open var supplementaryViewFactory: SupplementaryViewFactory
    
    public typealias SectionModelSnapshot = SectionModel<Section, Item>
    private var _sectionModels: [SectionModelSnapshot] = []
    
    open var sectionModels: [Section] {
        return _sectionModels.map { Section(original: $0.model, items: $0.items) }
    }
    
    override init() {
        
        self.configureCell = {_, _, _, _ in return (nil as UICollectionViewCell?)! }
        self.supplementaryViewFactory = {_, _, _, _ in (nil as UICollectionReusableView?)! }
        
        super.init()
        
        self.configureCell = { [weak self] _ in
            precondition(false, "There is a minor problem. `cellFactory` property on \(self!) was not set. Please set it manually.")
            
            return (nil as UICollectionViewCell!)!
        }
        
        self.supplementaryViewFactory = { [weak self] _ in
            precondition(false, "There is a minor problem. `supplementaryViewFactory` property on \(self!) was not set.")
            return (nil as UICollectionReusableView?)!
        }
    }
    
    open func setSections(_ sections: [Section]) {
        self._sectionModels = sections.map { SectionModelSnapshot(model: $0, items: $0.items) }
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _sectionModels.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        precondition(indexPath.item < _sectionModels[indexPath.section].items.count)
        
        return configureCell(self, collectionView, indexPath, self[indexPath])
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return supplementaryViewFactory(self, collectionView, kind, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _sectionModels[section].items.count
    }
    
    open subscript(indexPath: IndexPath) -> Item {
        get {
            return self._sectionModels[indexPath.section].items[indexPath.item]
        }
        
        set(item) {
            var section = self._sectionModels[indexPath.section]
            section.items[indexPath.item] = item
            self._sectionModels[indexPath.section] = section
        }
    }
}

