//
//  ListViewModel.swift
//  CenNews
//
//  Created by Bell KunG on 15/10/2563 BE.
//

import Foundation

protocol ListViewModel {
    associatedtype SectionEnum = Int
    
    func numberOfSections() -> Int
    func numberOfRowsInSection(_ section: Int) -> Int
    func dataForRow(at indexPath: IndexPath) -> Any?
    func sectionType(at indexPath: IndexPath) -> SectionEnum
}
