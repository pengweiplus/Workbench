# 在函数外部定义，只在 Profile 加载时检查一次
$script:hasGit = Get-Command git -ErrorAction SilentlyContinue
$script:currentUserHost = "$Env:USERNAME@$Env:COMPUTERNAME"

function prompt {
    # 基础信息
    $user = $Env:USERNAME
    $computer = $Env:COMPUTERNAME
    $location = (Get-Location).Path -split "\\"
    
    # 路径截断逻辑
    if ($location.Count -gt 5) {
        $displayPath = "..\" + ($location[-5..-1] -join "\")
    } else {
        $displayPath = (Get-Location).Path
    }

    # 获取 Git 分支 (2>$null 确保不在 git 目录时不报错)
    $gitBranch = ""
    if ($script:hasGit -and (Test-Path .git -ErrorAction SilentlyContinue)) {
        $branch = git branch --show-current 2>$null
        if ($branch) { $gitBranch = " [$branch]" }
    }

    # 时间戳
    $timestamp = [System.DateTime]::Now.ToString('HH:mm:ss')

    # 输出提示符
    Write-Host -NoNewline -ForegroundColor Cyan $script:currentUserHost
    Write-Host -NoNewline " in "
    Write-Host -NoNewline -ForegroundColor Yellow $displayPath
    
    # 时间标识
    Write-Host -NoNewline " [$timestamp]"

    # Git分支标识
    if ($gitBranch) {
        Write-Host -NoNewline -ForegroundColor Magenta $gitBranch
    }

    # 换行后返回输入提示符
    "`n> "
}
# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# 2. 修改 Tab 键补全方式：按一次 Tab 显示菜单，而不是一个个切换
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

# 3. 设置智能历史搜索
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward