$vsEdition = "Community"
#$vsEdition = "Enterprise"
Invoke-WebRequest "https://aka.ms/vs/17/release/vs_$vsEdition.exe" -OutFile vs_Installer.exe

$workloads = `
    "Microsoft.VisualStudio.Workload.CoreEditor", #Visual Studio core editor (included with Visual Studio Community 2019) `
    "Microsoft.VisualStudio.Workload.Azure", #Azure development `
    "Microsoft.VisualStudio.Workload.Data", #Data storage and processing `
    #"Microsoft.VisualStudio.Workload.DataScience", #Data science and analytical applications `
    "Microsoft.VisualStudio.Workload.ManagedDesktop", #.NET desktop development `
    "Microsoft.VisualStudio.Workload.ManagedGame", #Game development with Unity `
    #"Microsoft.VisualStudio.Workload.NativeCrossPlat", #Linux development with C++ `
    #"Microsoft.VisualStudio.Workload.NativeDesktop", #Desktop development with C++ `
    #"Microsoft.VisualStudio.Workload.NativeGame", #Game development with C++ `
    #"Microsoft.VisualStudio.Workload.NativeMobile", #Mobile development with C++ `
    #"Microsoft.VisualStudio.Workload.NetCrossPlat", #Mobile development with .NET `
    "Microsoft.VisualStudio.Workload.NetWeb", #ASP.NET and web development `
    "Microsoft.VisualStudio.Workload.Node", #Node.js development `
    #"Microsoft.VisualStudio.Workload.Office", #Office/SharePoint development `
    #"Microsoft.VisualStudio.Workload.Python", #Python development `
    #"Microsoft.VisualStudio.Workload.Universal", #Universal Windows Platform development ``
    "Microsoft.Net.ComponentGroup.4.6.2-4.7.1.DeveloperTools"

$workloadArgs = $workloads | ForEach-Object { "--add $_" }
$workloadArgs = $workloadArgs -join " "

$command = " & .\vs_Installer.exe --lang en-US $workloadArgs --includeRecommended --passive --norestart --wait"

Invoke-Expression $command