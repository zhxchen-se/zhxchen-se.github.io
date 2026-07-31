$ErrorActionPreference = "Stop"

$rubyCommand = Get-Command ruby -ErrorAction SilentlyContinue
if ($rubyCommand) {
    $rubyBin = Split-Path -Parent $rubyCommand.Source
} elseif (Test-Path -LiteralPath "D:\Ruby34-x64\bin\ruby.exe") {
    # Existing PowerShell/Conda sessions may not see RubyInstaller's PATH update.
    $rubyBin = "D:\Ruby34-x64\bin"
} elseif (Test-Path -LiteralPath "C:\Ruby34-x64\bin\ruby.exe") {
    $rubyBin = "C:\Ruby34-x64\bin"
} else {
    throw "Ruby was not found. Expected ruby.exe in PATH, D:\Ruby34-x64\bin, or C:\Ruby34-x64\bin."
}

$env:Path = "$rubyBin;$env:Path"
$bundle = Join-Path $rubyBin "bundle.bat"
$jekyll = Join-Path $rubyBin "jekyll.bat"

if (-not (Test-Path -LiteralPath $bundle)) {
    throw "Bundler was not found. Run: gem install bundler -v 4.0.6"
}

& $bundle check
if ($LASTEXITCODE -ne 0) {
    throw "Ruby dependencies are missing. Run: bundle install"
}

& $bundle exec $jekyll serve --livereload
