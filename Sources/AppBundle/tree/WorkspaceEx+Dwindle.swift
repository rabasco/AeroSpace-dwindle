extension Workspace {
    @MainActor
    func reloadDwindleLayout() {
        let allWindows = allLeafWindowsRecursive
        allWindows.forEach { $0.unbindFromParent() }
        rootTilingContainer.children.forEach { $0.unbindFromParent() }
        rootTilingContainer.changeOrientation(.h)
        allWindows.forEach { bindDwindleWindow(rootTilingContainer, window: $0) }
    }

    @MainActor
    private func bindDwindleWindow(_ container: TilingContainer, window: Window) {
        if container.children.count == 0 || container.children.count == 1 {
            window.bind(to: container, adaptiveWeight: WEIGHT_AUTO, index: INDEX_BIND_LAST)
            return
        }
        
        if container.children.count == 2 {
            let lastItem = container.children.last
            
            if let lastItemWindow = lastItem as? Window {
                let index = lastItemWindow.ownIndex ?? INDEX_BIND_LAST
                let orientation = container.orientation.opposite
                lastItemWindow.unbindFromParent()
                let newContainer = TilingContainer(parent: container, adaptiveWeight: WEIGHT_AUTO, orientation, .dwindle, index: index)
                lastItemWindow.bind(to: newContainer, adaptiveWeight: WEIGHT_AUTO, index: INDEX_BIND_LAST)
                return bindDwindleWindow(newContainer, window: window) 
            }
            
            if let lastItemContainer = lastItem as? TilingContainer {
                return bindDwindleWindow(lastItemContainer, window: window)
            }
        }
    }
}
