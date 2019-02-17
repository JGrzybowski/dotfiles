#RUN FROM BOXSTARTER COMMAND LINE
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -DisableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar
Set-TaskbarOptions -Size Large -Lock -Dock Bottom -Combine Never
Move-LibraryDirectory "Desktop" "D:\User\Pulpit"
Move-LibraryDirectory "My Video" "D:\User\Video"
Move-LibraryDirectory "My Pictures" "D:\User\Obrazy"
Move-LibraryDirectory "My Music" "D:\User\Muzyka"
Move-LibraryDirectory "Personal" "D:\User\Dokumenty"