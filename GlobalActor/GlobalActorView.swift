//
//  ContentView.swift
//  GlobalActor
//
//  Created by Skorobogatow, Christian on 1/8/22.
//

import SwiftUI

@globalActor final class MyFirstGlobalActor {
    static var shared = MyNewDataManager()
}

actor MyNewDataManager {
    
    func getDataFromDataBase() -> [String]{
        
        return ["One", "Two", "Three","Four", "Five", "six"]
    }
}

class GlobalActorViewModel: ObservableObject {
    @MainActor @Published var dataArray: [String] = []
    let manager = MyFirstGlobalActor.shared
    
    @MyFirstGlobalActor
    func getData()  {
        
        // HEAVY COMPLEX METHOD
        
        
        
        Task {
            let data = await manager.getDataFromDataBase()
            await MainActor.run {
                self.dataArray = data
            }
        }
    }
}

struct GlobalActorView: View {
    
    @StateObject private var viewModel = GlobalActorViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.getData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalActorView()
    }
}
