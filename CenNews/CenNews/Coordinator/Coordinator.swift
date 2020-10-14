//
//  Coordinator.swift
//  CenNews
//
//  Created by Bell KunG on 14/10/2563 BE.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }

    func start()
    func end()
    func startCoordinator(_ childCoordinator: Coordinator)
    func endCoordinator(_ childCoordinator: Coordinator)
}

extension Coordinator {
    func startCoordinator(_ childCoordinator: Coordinator) {
        childCoordinator.start()
        childCoordinators.append(childCoordinator)
    }

    func endCoordinator(_ childCoordinator: Coordinator) {
        childCoordinator.end()
        _ = childCoordinators.popLast()
    }
    
    func end() {}
}
