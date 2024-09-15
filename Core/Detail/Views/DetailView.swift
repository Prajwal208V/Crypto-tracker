

import SwiftUI


struct DetailLoadingView: View{
    
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack{
            if let coin = coin{
                DetailView(coin: coin)
            }
        }
    }
}
struct DetailView: View {
    
    @StateObject private var vm : DetailViewModel
    @State private var showFullDescription: Bool = false
    
    private var columns : [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private let spacing: CGFloat = 30
    
    init(coin:CoinModel){
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        print(coin.name)
    }
    
    var body: some View {
        ScrollView(){
            VStack(spacing:20){
                ChartView(coin: vm.coin)
                overViewTitle
                Divider()
                descriptionSection
                overViewGrid
                additionalTitle
                Divider()
                additionalViewGrid
                websiteSection
            }
        }.padding()
        .navigationTitle(vm.coin.name)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing, content: {
                  navigationBarTrailingItems
            })
        }
        .scrollIndicators(.hidden)
    }

}

#Preview {
    NavigationView{
        DetailLoadingView(coin: .constant(DeveloperPreview.instance.coin))
    }
}

extension DetailView {
    
    private var overViewTitle : some View{
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
    }
    private var additionalTitle : some View{
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
    }
    private var overViewGrid:some View{
        LazyVGrid(
           columns: columns,
           alignment: .leading,
           spacing: spacing,
           pinnedViews: [],
           content: {
               ForEach(vm.overViewStatistics){ stat in
                   StatisticView(stat: stat)
               }
           }
        )
    }
    private var additionalViewGrid:some View{
        LazyVGrid(
           columns: columns,
           alignment: .leading,
           spacing: spacing,
           pinnedViews: [],
           content: {
               ForEach(vm.additionalViewStatistics){ stat in
                   StatisticView(stat: stat)
               }
           }
        )
    }
    private var navigationBarTrailingItems:some View{
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
            .foregroundColor(Color.theme.SecondaryText)
            if let url = URL(string: vm.coin.image){
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                  .aspectRatio(contentMode: .fit)
                    } else if phase.error != nil {
                        Text("Failed to load image")
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 25,height: 25)
            }else {
                Text("Invalid URL")
            }
        }
    }
    
    private var descriptionSection:some View{
        ZStack{
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty{
                VStack(alignment:.leading){
                    Text(coinDescription)
                        .lineLimit(showFullDescription ? nil :3)
                        .font(.callout)
                        .foregroundColor(Color.theme.SecondaryText)
                    Button(action: {
                        withAnimation(.easeOut){
                            showFullDescription.toggle()
                        }
                    }, label: {
                        Text("Read more..")
                            .font(.caption)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .padding(.vertical,4)
                    })
                    .accentColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private var websiteSection: some View{
        VStack(alignment:.leading, spacing: 10){
            if let websiteString = vm.websiteURL,
               let url = URL(string: websiteString){
                Link("Website", destination: url)
            }
            if let redditString = vm.redditURL,
               let url = URL(string: redditString){
                Link("Reddit", destination: url)
            }
        }
        .accentColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
}
