$vsCodeExtensions = @(
    "mhutchie.git-graph",
    "CoenraadS.bracket-pair-colorizer-2",
    "esbenp.prettier-vscode",
    "wmaurer.change-case",
    "Azurite.azurite",
    "ms-dotnettools.csharp",
    "ms-vscode.powershell",
    "ms-vsliveshare.vsliveshare",
    "brenosolutions.sqlformatter",
    "dsznajder.es7-react-js-snippets",
    "lonefy.vscode-JS-CSS-HTML-formatter ",
    "Orta.vscode-jest",
    "jock.svg",
    "janisdd.vscode-edit-csv",
    "mechatroner.rainbow-csv",
    "github.vscode-pull-request-github",
    "jeff-hykin.macro-commander"
)

Foreach ($extensionName in $vsCodeExtensions) { & code --install-extension "$extensionName" }
