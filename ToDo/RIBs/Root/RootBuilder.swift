//
//  RootBuilder.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa

protocol RootDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.

    var application: UIApplication { get }
    var launchOptions: [UIApplication.LaunchOptionsKey: Any]? { get }
    var service: ToDoServiceProtocol { get }
    var config: BehaviorRelay<Config> { get }
}

final class RootComponent: Component<RootDependency> {
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.

    let rootViewController: RootViewController

    var application: UIApplication {
        return dependency.application
    }

    var launchOptions: [UIApplication.LaunchOptionsKey: Any]? {
        return dependency.launchOptions
    }

    var config: BehaviorRelay<Config> {
        return dependency.config
    }

    var service: ToDoServiceProtocol {
        return dependency.service
    }

    init(dependency: RootDependency,
         rootViewController: RootViewController) {

        self.rootViewController = rootViewController

        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build() -> (launchRouter: LaunchRouting, urlHandler: UrlHandler)
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {

    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    func build() -> (launchRouter: LaunchRouting, urlHandler: UrlHandler) {
        let viewController = RootViewController()
        let component      = RootComponent(dependency: dependency,
                                           rootViewController: viewController)
        let interactor     = RootInteractor(presenter: viewController)

        let loggedOutBuilder = LoggedOutBuilder(dependency: component)
        let loggedInBuilder = LoggedInBuilder(dependency: component)

        let router = RootRouter(interactor: interactor,
                                viewController: viewController,
                                loggedOutBuilder: loggedOutBuilder,
                                loggedInBuilder: loggedInBuilder)

        return (router, interactor)
    }
}
