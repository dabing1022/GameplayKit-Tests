/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    The initial state of a `SceneLoader`. Determines which state should be entered at the beginning of the scene loading process.
*/

import GameplayKit

class SceneLoaderInitialState: GKState {
    // MARK: Properties
    
    unowned let sceneLoader: SceneLoader

    // MARK: Initialization
    
    init(sceneLoader: SceneLoader) {
        self.sceneLoader = sceneLoader
    }
    
    // MARK: GKState Life Cycle
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        #if os(iOS)
        // Move the `stateMachine` to the available state if no on-demand resources are required.
        if !sceneLoader.sceneMetadata.requiresOnDemandResources {
            stateMachine!.enterState(SceneLoaderResourcesAvailableState.self)
        }
        #elseif os(OSX)
        // On OS X the resources will always be in local storage available for download.
        stateMachine!.enterState(SceneLoaderResourcesAvailableState.self)
        #endif
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        #if os(iOS)
        if stateClass is SceneLoaderDownloadingResourcesState.Type {
            return true
        }
        #endif
        
        return stateClass is SceneLoaderResourcesAvailableState.Type
    }
}