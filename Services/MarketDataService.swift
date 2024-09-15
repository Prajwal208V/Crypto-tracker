
import Foundation
import Combine

class MarketDataService{
    
    @Published var marketData : MarketDataModel? = nil// anything subscribed into this published also get notified
    var cancellabels = Set<AnyCancellable>()
    
    var marketDataSubscription: AnyCancellable?
    
    init(){
        getMarketData() // in this initializer call getMarketData
    }
    
    func getMarketData(){
        
        guard let url = URL(string:"https://api.coingecko.com/api/v3/global") else {return} // downlad the data
        
        marketDataSubscription = NetworkingManager.download(url:url)
            .decode(type: GlobelData.self, decoder: JSONDecoder()) // decode the data
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {[weak self] (returnedGlobelData)in
                self?.marketData = returnedGlobelData.data // take the data and append to array
                self?.marketDataSubscription?.cancel()
            })
    }
    
}
