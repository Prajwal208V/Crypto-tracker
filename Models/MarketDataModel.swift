
import Foundation

// JSON data
/*
 URL: https://api.coingecko.com/api/v3/global
 
 JSON response:
 {
   "data": {
     "active_cryptocurrencies": 14661,
     "upcoming_icos": 0,
     "ongoing_icos": 49,
     "ended_icos": 3376,
     "markets": 1185,
     "total_market_cap": {
       "btc": 36664849.6707007,
       "eth": 850722472.886472,
       "ltc": 33806520033.562,
       "bch": 6677893746.82032,
       "bnb": 4143785392.05582,
       "eos": 4572639069196.27,
       "xrp": 3866684394710.72,
       "xlm": 23328870202364.2,
       "link": 200202489526.068,
       "dot": 513939590999.545,
       "yfi": 419544833.710654,
       "usd": 2139285617831.87,
       "aed": 7857403538590.87,
       "ars": 2.03502307283632e+15,
       "aud": 3154312464924.56,
       "bdt": 256242454696811,
       "bhd": 806142720796.349,
       "bmd": 2139285617831.87,
       "brl": 12006954458643.1,
       "cad": 2886944548407.93,
       "chf": 1817830143039.6,
       "clp": 1.95372623173032e+15,
       "cny": 15211604314155.3,
       "czk": 48390972264627.5,
       "dkk": 14415347232199,
       "eur": 1932684109289.76,
       "gbp": 1628621026570.46,
       "gel": 5754678311967.73,
       "hkd": 16678615148012.3,
       "huf": 758425065147792,
       "idr": 33242584394554264,
       "ils": 7815161204781.14,
       "inr": 179541671926444,
       "jpy": 313733010266631,
       "krw": 2.86446667437496e+15,
       "kwd": 653697227669.65,
       "lkr": 641548303799550,
       "mmk": 4488221226211265,
       "mxn": 42117960022458.5,
       "myr": 9318193329871.18,
       "ngn": 3.40550738217038e+15,
       "nok": 22635909479416.1,
       "nzd": 3434312863014.48,
       "php": 120938090268700,
       "pkr": 597164061607842,
       "pln": 8267643645094.37,
       "rub": 192269167731171,
       "sar": 8027998730899.23,
       "sek": 21938192171588.3,
       "sgd": 2795372427536.64,
       "thb": 73209562770633.2,
       "try": 72722875292576.6,
       "twd": 68583357622071.9,
       "uah": 88051969172863.3,
       "vef": 214206668913.505,
       "vnd": 53214729743567760,
       "zar": 38266580592534,
       "xdr": 1592984806748.62,
       "xag": 74763604021.9949,
       "xau": 856163497.112494,
       "bits": 36664849670700.7,
       "sats": 3.66648496707006e+15
     },
     "total_volume": {
       "btc": 1253232.55277641,
       "eth": 29078343.5899848,
       "ltc": 1155532663.64553,
       "bch": 228255506.368133,
       "bnb": 141637748.188931,
       "eos": 156296294273.187,
       "xrp": 132166224552.569,
       "xlm": 797398593467.073,
       "link": 6843073932.50938,
       "dot": 17566847577.0657,
       "yfi": 14340362.7091787,
       "usd": 73122415611.477,
       "aed": 268572051523.55,
       "ars": 69558642226415.1,
       "aud": 107816808146.654,
       "bdt": 8758562724614.12,
       "bhd": 27554573630.0417,
       "bmd": 73122415611.477,
       "brl": 410406869860.975,
       "cad": 98677968643.532,
       "chf": 62134822074.4495,
       "clp": 66779854132996.2,
       "cny": 519944248446.968,
       "czk": 1654040375106.02,
       "dkk": 492727573499.467,
       "eur": 66060618323.7986,
       "gbp": 55667510025.6925,
       "gel": 196699297994.873,
       "hkd": 570087798707.707,
       "huf": 25923547730902.8,
       "idr": 1.13625691297908e+15,
       "ils": 267128176304.885,
       "inr": 6136871413874.32,
       "jpy": 10723633803982.9,
       "krw": 97909657748810.5,
       "kwd": 22343870293.5678,
       "lkr": 21928610800839.6,
       "mmk": 153410827952879,
       "mxn": 1439624027665.4,
       "myr": 318502961799.691,
       "ngn": 116402842187754,
       "nok": 773712666929.974,
       "nzd": 117387435513.963,
       "php": 4133756253103.19,
       "pkr": 20411523518482.3,
       "pln": 282594371553.284,
       "rub": 6571906937027.06,
       "sar": 274403125434.071,
       "sek": 749864156690.369,
       "sgd": 95547963643.2828,
       "thb": 2502358745848.15,
       "try": 2485723396296.55,
       "twd": 2344231522088.34,
       "uah": 3009683527808.9,
       "vef": 7321747475.17718,
       "vnd": 1.81892008833549e+15,
       "zar": 1307980938493.49,
       "xdr": 54449436826.4365,
       "xag": 2555477062.2208,
       "xau": 29264321.9518692,
       "bits": 1253232552776.41,
       "sats": 125323255277641
     },
     "market_cap_percentage": {
       "btc": 53.8626634112608,
       "eth": 14.1394403094466,
       "usdt": 5.52246871923936,
       "bnb": 3.51803051556764,
       "sol": 2.8692381985388,
       "usdc": 1.62277858419729,
       "xrp": 1.45382117226783,
       "steth": 1.15298675969873,
       "doge": 0.663001861522731,
       "trx": 0.63470372739129
     },
     "market_cap_change_percentage_24h_usd": -1.0679169116054,
     "updated_at": 1725271512
   }
 }
*/


// MARK: - Welcome
struct GlobelData: Codable {
    
    let data: MarketDataModel?
}

// MARK: - DataClass
struct MarketDataModel:Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double?
    
    enum CodingKeys: String, CodingKey{
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap:String{
        if let item = totalMarketCap.first(where: {$0.key == "usd"}){
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume:String{
        if let item = totalVolume.first(where: {$0.key == "usd"}){
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance: String{
        if let item = marketCapPercentage.first(where: {$0.key == "btc"}){
            return item.value.asPercentString()
        }
        return ""
    }
}
