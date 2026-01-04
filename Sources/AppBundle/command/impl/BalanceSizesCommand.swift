import AppKit
import Common
import Foundation

struct BalanceSizesCommand: Command {
    let args: BalanceSizesCmdArgs
    /*conforms*/ var shouldResetClosedWindowsCache = false

    func run(_ env: CmdEnv, _ io: CmdIo) -> Bool {
        guard let target = args.resolveTargetOrReportError(env, io) else { return false }
        let success = balance(target.workspace.rootTilingContainer)
        return success
    }
}

@MainActor
private func balance(_ parent: TilingContainer) -> Bool {
    // For dwindle layout, reset all split ratios to configured default
    if parent.layout == .dwindle {
        parent.dwindleCache.resetAllRatios()
    }

    // For master layout, reset master area percentage to configured default
    if parent.layout == .master {
        parent.masterCache.resetToDefault()
    }

    var allSucceeded = true
    for child in parent.children {
        switch parent.layout {
            case .tiles: child.setWeight(parent.orientation, 1)
            case .accordion: break // Do nothing
            case .dwindle: break // Ratios already reset above via cache
            case .master: break // Percentage already reset above via cache
            case .scroll: break // Do nothing
        }
        if let child = child as? TilingContainer {
            if !balance(child) {
                allSucceeded = false
            }
        }
    }
    return allSucceeded
}
