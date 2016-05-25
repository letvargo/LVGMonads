//
//  IO.swift
//  Pods
//
//  Created by doof nugget on 5/24/16.
//
//

public struct IO<T> {
    
    private let action: () -> T
    
    public init(_ action: () -> T) {
        self.action = action
    }
}