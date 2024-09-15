
import Foundation
import Combine

class DetailViewModel: ObservableObject{
    
    @Published var overViewStatistics: [StatisticModel] = []
    @Published var additionalViewStatistics: [StatisticModel] = []
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    @Published var coin: CoinModel
    
    private let coinDetailService: CoinDetailDataService
    private var cancellabels = Set<AnyCancellable>()
    
    init(coin:CoinModel){
        self.coin = coin
        self.coinDetailService =  CoinDetailDataService(coin: coin)
        self.addSusbscribers()
    }
    
    private func addSusbscribers(){
        
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink {[weak self] (returnedArrays) in
                self?.overViewStatistics = returnedArrays.overview
                self?.additionalViewStatistics = returnedArrays.additional
            }
            .store(in: &cancellabels)
        
        coinDetailService.$coinDetails
            .sink{ [weak self] (returnedCoinDetails) in
                self?.coinDescription = returnedCoinDetails?.readableDescription
                self?.websiteURL  = returnedCoinDetails?.links?.homepage?.first
                self?.redditURL = returnedCoinDetails?.links?.subredditURL
            }
            .store(in: &cancellabels)
    }
    
    private func mapDataToStatistics(coinDetailModel:CoinDetailModel?, coinModel:CoinModel)->(overview: [StatisticModel], additional:[StatisticModel]){
        // overview
        let overviewArray = createOverviewArray(coinModel:coinModel)
        
        // additional
        let additionalArray = createAdditionalArray(coinModel:coinModel,coinDetailModel:coinDetailModel)

        return (overviewArray, additionalArray)
    }
    
    private func createOverviewArray(coinModel:CoinModel)->[StatisticModel]{
        let price = coinModel.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value:price, percentageChange: pricePercentChange)
        
        let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
        
        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        var overviewArray: [StatisticModel] = [
            priceStat, marketCapStat, rankStat , volumeStat
        ]
        
        return overviewArray
    }
    
    private func createAdditionalArray(coinModel:CoinModel,coinDetailModel:CoinDetailModel?)->[StatisticModel]{
        let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24 High", value: high)
        
        let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24 Low", value: low)
        
        let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange = coinModel.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24 Price Change", value: priceChange, percentageChange: pricePercentChange)
        
        let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapChangePercentChange = coinModel.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24th Market Cap Change", value: marketCapChange, percentageChange: marketCapChangePercentChange)
        
        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hasing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hasingStat = StatisticModel(title: "Hashing Algorithm", value: hasing)
        
        var additionalArray: [StatisticModel] = [
            highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hasingStat
        ]
        return additionalArray
    }
}
