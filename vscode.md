

### Markdown PDF

    ERROR: exportPdf()
    Error: spawn Unknown system error -86

https://github.com/yzane/vscode-markdown-pdf/issues/336

```bash
rm -rf ~/.vscode/extensions/yzane.markdown-pdf-1.5.0/node_modules/puppeteer-core/.local-chromium/mac-722234/chrome-mac/Chromium.app

cp -r /Applications/Chromium.app ~/.vscode/extensions/yzane.markdown-pdf-1.5.0/node_modules/puppeteer-core/.local-chromium/mac-722234/chrome-mac/
```
