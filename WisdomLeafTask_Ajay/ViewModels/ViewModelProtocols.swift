//
//  ViewModelProtocols.swift
//  WisdomLeafTask_Ajay
//
//  Created by Venkata Ajay Sai Nellori on 17/05/23.
//

protocol ViewModelProtocols {
    //computed closure
    var updateLoadingStatus: (() -> ())? { get set }
    var didFinishFetch: (() -> ())? { get set }
    var isLoading: Bool { get set }
}
