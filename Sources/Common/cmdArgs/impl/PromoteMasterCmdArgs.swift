public struct PromoteMasterCmdArgs: CmdArgs {
    public var commonState: CmdArgsCommonState

    public init(rawArgs: StrArrSlice) {
        self.commonState = .init(rawArgs)
    }
    public static let parser: CmdParser<Self> = cmdParser(
        kind: .promoteMaster,
        allowInConfig: true,
        help: promote_master_help_generated,
        flags: [
            "--window-id": optionalWindowIdFlag(),
        ],
        posArgs: [],
    )

    /*conforms*/ public var windowId: UInt32?
    /*conforms*/ public var workspaceName: WorkspaceName?
}
