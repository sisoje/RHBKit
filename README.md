# RHBKit

[![CI Status](http://img.shields.io/travis/sisoje/RHBKit.svg?style=flat)](https://travis-ci.org/sisoje/RHBKit)
[![Version](https://img.shields.io/cocoapods/v/RHBKit.svg?style=flat)](http://cocoapods.org/pods/RHBKit)
[![License](https://img.shields.io/cocoapods/l/RHBKit.svg?style=flat)](http://cocoapods.org/pods/RHBKit)
[![Platform](https://img.shields.io/cocoapods/p/RHBKit.svg?style=flat)](http://cocoapods.org/pods/RHBKit)

## Content

Core, all platforms

- Data stack and fetched data wrappers
- Generic table view data source for background fetched data
- Operations and queues
- Predicates and operators
- Encryption checker
- Memory diagnostics
- Objective-C defer, singleton and casting
- Mutable protocol
- Utilities, debug, deiniter
- Native extensions

Extras, platform subset

- Orientation tracker ```{ios, watchos}```
- UIKit: table data sources, app settings, fake progress view ```{ios, tvos}```
- Native extensions for various platforms


## Examples and snippets ```[Swift]```

Generic data source and background fetching

    dataStack.backgroundFetch(fetchRequest) { [weak self] controller, mainContext in
        self?.tableViewDataSource = TableViewDataSource(controller, mainContext)
        self?.tableView.reloadData()
    }

Best accelerometer based orientation tracker, works for watchos

    orientationTracker.startTracking { [weak self] tracker in
        UIView.animate(withDuration: 0.3) {
            self?.imageView.transform = CGAffineTransform(rotationAngle: -CGFloat(tracker.deviceRotation))
        }
    }

Core data operations

    queue.addCoreDataOperation(persistentContainer) { context in
        try! context.fetch(TestEntity.fetchRequest()).forEach { context.delete($0) }
        try! context.save()
    }

NSPersistentContainer extension for async store loading, with fake progress

    progressView.startProgress()
    container.loadStoresAsync { [weak self] _, errors in
        self?.progressView.endProgess(errors.isEmpty)
    }

Debug

    Debug.execute { print("log in debug only") }

Mutating while constructing

    let queue = OperationQueue().mutate { $0.maxConcurrentOperationCount = 1 }

PredicateKey with arithmetic operators for building NSPredicate

    let predicate1 = PredicateKey("name") == "Sisoje"
    let predicate2 = PredicateKey(#keyPath(TestEntity.name)) == "Sisoje"
    let predicate3 = \TestEntity.name == "Sisoje"

NSPredicate logical operators for building complex predicates

    let predicate = !predicate1 || predicate2

Blocks with operation parameter

    queue.addOperationInside { operation in
        while !operation.isCancelled { printf("doing some work") }
    }

Collection safe index

    let optional = array[safe: 55]

Convenienece constructors

    NSManagedObjectModel(name: "TestModel", in: Bundle.main)
    NSFetchedResultsController(performing: request, in: context)
    UIColor(colorReference: 0x112233)

Notification center adding & removing

    var removeObserver: (() -> Void)?
    removeObserver = NotificationCenter.default.addRemovableObserver(.UIApplicationWillEnterForeground) { _ in
        removeObserver?()
    }

Application settings with return block

    application.openApplicationSettings {
        printf("back from settings, something maybe changed")
    }

Encryption checker

    let isEncrypted = RHBEncryptionChecker.isEncrypted(main)

Memory diagnostics

    let memoryUsed = RHBDiagnostics.memoryUsed()


## Examples and snippets ```[Objective-C]```

Defer

    RHB_DEFER {
        NSLog(@"time to release something");
    }];

Singleton

    @implementation MySingleton
        RHB_SINGLETON(sharedInstance)
    @end

Casting

    NSArray *array = [NSArray rhb_dynamicCast:self.collection];
    if (array) {
        NSLog(@"It is array: %@", array);
    }

## Requirements

- Swift 4.0
- Platforms:

        { :ios => "10.0", :watchos => "3.0", :tvos => "10.0", :osx => "10.12" }

## Installation

[RHBKit](http://cocoapods.org/pods/RHBKit) is available through CocoaPods. To install
it, simply add the following line to your Podfile:

```ruby
pod 'RHBKit'
```

## Author

Lazar Otasevic, redhotbits@gmail.com

## License

RHBKit is available under the MIT license. See the LICENSE file for more info.
