
import Foundation
import Combine


// view refernce into viewModel and this viewMode has a data-service which we are initializing coinservice
class HomeViewModel: ObservableObject{ // we can observe it from view
    
    @Published var statistics: [StatisticModel] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins : [CoinModel] = []
    @Published var isLoading: Bool = false
    @Published var searchText:String = ""
    @Published var sortOption: SortOption = .hodlings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    enum SortOption{
        case rank, rankReversed, hodlings, hodlingsReversed, price, priceReversed
    }
    
    init(){
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
//            self.allCoins.append(DeveloperPreview.instance.coin)
//            self.portfolioCoins.append(DeveloperPreview.instance.coin)
//        }
        addSubcriber()
    }
    
    func addSubcriber(){
//        dataService.$allCoins
//            .sink{[weak self] (returnedCoins) in
//                self?.allCoins = returnedCoins
//            }
//            .store(in: &cancellables)
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchSerialQueue.main)
            .map(fikterAndSortCoins)
            .sink {[weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        // updates marketData
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink {[weak self] (returnedStats) in
                self?.statistics = returnedStats
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        // updates PortfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$savedEntities)
            .map{ (coinModels, portfolioEntities) -> [CoinModel] in
                coinModels
                    .compactMap{ (coin) -> CoinModel? in
                        guard let entity = portfolioEntities.first(where:{$0.coinID == coin.id}) else{
                            return nil
                        }
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink {[weak self] (returnedCoins) in
                guard let self = self else {return} // ####
                self.portfolioCoins = self.sortPortfolioCoinsIfneeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double){
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    func reloadData(){
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getMarketData()
        HapticManager.notification(type: .success)
    }
    
    private func fikterAndSortCoins(text:String,coins:[CoinModel],sort:SortOption)->[CoinModel]{
        var updatedCoins = filterCoins(text: text, coins: coins)
        // sorting
        sortCoins(sort: sort, coins: &updatedCoins)
        return updatedCoins
    }
    private func filterCoins(text:String,coins:[CoinModel])->[CoinModel]{
        guard !text.isEmpty else{
            return coins
        }
        let lowercasedText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowercasedText) || 
                   coin.symbol.lowercased().contains(lowercasedText) ||
                   coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func sortCoins(sort:SortOption, coins: inout [CoinModel]) {
        switch sort {
        case .rank, .hodlings:
             coins.sort(by: {$0.rank < $1.rank})
        case .rankReversed, .hodlingsReversed:
             coins.sort(by: {$0.rank > $1.rank})
        case .price:
             coins.sort(by: {$0.currentPrice < $1.currentPrice})
        case .priceReversed:
             coins.sort(by: {$0.currentPrice > $1.currentPrice})
        }
    }
    
    private func sortPortfolioCoinsIfneeded(coins:[CoinModel])-> [CoinModel]{
        // will only sort by holdings or reveredholdings if needed
        switch sortOption {
        case .hodlings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .hodlingsReversed:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        default:
            return coins
        }
    }
    
//    private func mapAllCoinsToPortfolioCoins(coinModels, portfolioEntities) -> [CoinModel] in{
//        
//    }
//    
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?)-> [StatisticModel]{
        var stats: [StatisticModel] = []
        guard let data = marketDataModel else{
            return stats
        }
        
        let marketData = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title:"24h Volume" , value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolio = StatisticModel(title: "Portfolio value", value: "$0.00", percentageChange: 0)
        
        stats.append(contentsOf: [
            marketData,
            volume,
            btcDominance,
            portfolio
        ])
        return stats
    }
}
