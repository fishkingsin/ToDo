//
//  AppComponent.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import Foundation
import RIBs
import RxSwift
import RxCocoa
final class AppComponent: Component<EmptyDependency>, RootDependency {
    let application: UIApplication
    let launchOptions: [UIApplication.LaunchOptionsKey : Any]?
    let service: ToDoServiceProtocol
    let config: BehaviorRelay<Config>


    init(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        let configSnapshot = Config(maxIncompleteItems: 10)

        self.application   = application
        self.launchOptions = launchOptions
        self.service       = ToDoService()
        self.config        = BehaviorRelay<Config>(value: configSnapshot)

        super.init(dependency: EmptyComponent())
    }
}
