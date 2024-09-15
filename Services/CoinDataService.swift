
import Foundation
import Combine

class CoinDataService{
    
    @Published var allCoins : [CoinModel] = [] // anything subscribed into this published also get notified
    var cancellabels = Set<AnyCancellable>()
    
    var coinSubscription: AnyCancellable?
    
    init(){
        getCoins() // in this initializer call getcoins
    }
    
    func getCoins(){
        
        guard let url = URL(string:"https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {return} // downlad the data
        
        coinSubscription = NetworkingManager.download(url:url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder()) // decode the data
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: {[weak self] (returnedCoins)in
                self?.allCoins = returnedCoins // take the data and append to array
                self?.coinSubscription?.cancel()
            })
    }
    
}
