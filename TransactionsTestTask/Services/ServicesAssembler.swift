//
//  ServicesAssembler.swift
//  TransactionsTestTask
//
//

/// Services Assembler is used for Dependency Injection
/// There is an example of a _bad_ services relationship built on `onRateUpdate` callback
/// This kind of relationship must be refactored with a more convenient and reliable approach
///
/// It's ok to move the logging to model/viewModel/interactor/etc when you have 1-2 modules in your app
/// Imagine having rate updates in 20-50 diffent modules
/// Make this logic not depending on any module
enum ServicesAssembler {
    
    // MARK: - BitcoinRateService
    static let bitcoinRateService: PerformOnce<BitcoinRateService> = {
        lazy var analyticsService = Self.analyticsService()
        
        let service = BitcoinRateServiceImpl(
            networkClient: NetworkClientImpl(),
            walletService: Self.walletService()
        )
        // Scheduling automatic rate updates every 2 min while app is active
        service.scheduleRateUpdate(interval: 120)

        return { service }
    }()
    
    // MARK: - AnalyticsService
    static let analyticsService: PerformOnce<AnalyticsService> = {
        let service = AnalyticsServiceImpl()
        return { service }
    }()

    // MARK: - Storage
    static let walletService: PerformOnce<WalletService> = {
        let service = WalletServiceImpl()
        return { service }
    }()

    static let transactionsService: PerformOnce<TransactionsService> = {
        let service = TransactionsServiceImpl()
        return { service }
    }()

}
