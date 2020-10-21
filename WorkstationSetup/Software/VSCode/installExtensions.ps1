$vsCodeExtensions = `
    "mhutchie.git-graph", `
    "CoenraadS.bracket-pair-colorizer-2", `
    "esbenp.prettier-vscode", `
    "wmaurer.change-case ", `
    "Azurite.azurite", `
    "ms-dotnettools.csharp", `
    "ms-vscode.powershell", `
    "ms-vsliveshare.vsliveshare", `
    "brenosolutions.sqlformatter", `
    "dsznajder.es7-react-js-snippets", `
    "lonefy.vscode-JS-CSS-HTML-formatter ", `
    "mohsen1.prettify-json", `
    "Orta.vscode-jest", `
    "jock.svg"

Foreach ($extensionName in $vsCodeExtensions) { & code --install-extension "$extensionName" }