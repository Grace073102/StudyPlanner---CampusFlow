//
//  AssignmentListView.swift
//  StudyPlanner
//
//  Created by Grace Chi Yen Chong on 2/9/2026.
//

//import SwiftUI
//
//struct AssignmentListView: View {
//    
////    @StateObject private var productViewModel = ProductViewModel(repository: LocalProductRepository())
//    
//    @StateObject private var assigmentViewModel = AssignmentViewModel(repository: LocalProductRepository())
//                                                                      
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                List {
//                    ForEach($assigmentViewModel.assignments) { assignment in
//                        AssignmentView(assignment: assignment)
//                    }
//                    .toolbar {
//                        ToolbarItem(placement: .confirmationAction) {
//                            Button("Add", systemImage: "plus") {
//                                assigmentViewModel.add(Assignment(title: "Software Development"))
//                            }
//                        }
//                    }
//                    //                LottieView(animation: .named("confetti"))
//                    //                    .playing(loopMode: .loop)
//                    //                    .ignoresSafeArea()
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    AssignmentListView()
//}
