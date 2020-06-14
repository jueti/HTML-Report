$Header = @"
<style>
    body {
        margin-top: 50px;
        margin-left: 60px;
    }
    
    h1 {
        font-family: "Segoe UI Light", "sans-serif";
        font-size: 20.0pt;
        color: #2A2A2A;
        padding-bottom: 34px;
        margin: 0;
        font-weight: 400;
    }

    table {
        width: 80%;
        border: 1px;
        border-collapse: collapse;
    }
    
    table th {
        font-family: "Segoe UI Semibold", "sans-serif";
        font-size: 11.0pt;
        color: #000000;
        text-decoration: none;
        height: 30px;
        font-weight: 400;
        text-align: left;
        border-bottom: 1px solid #000000;
    }

    table tr td.Regular {
        height: 20px;
        vertical-align: text-top;
        font-family: "Segoe UI SemiLight", "sans-serif";
        font-size: 11.0pt;
        color: #000000;
        text-decoration: none;
    }

    table tr td.Secondary {
        height: 20px;
        vertical-align: text-top;
        font-family: "Segoe UI SemiLight", "sans-serif";
        font-size: 11.0pt;
        color: #707070;
        text-decoration: none;
    }
</style>
<script tpye="text/javascript">
    function tableStyle() {
        if(document.getElementsByTagName) {
            var table = document.getElementsByTagName("table")[0];
            var col = document.getElementsByTagName("col");
            var thead = document.createElement("thead");
            var tbody = document.getElementsByTagName("tbody")[0];
            var cells_tr = document.getElementsByTagName("tr");
            var cells_th = document.getElementsByTagName("th");
            var cells_td = document.getElementsByTagName("td");
        }
        
        table.insertBefore(thead, tbody);
        thead = document.getElementsByTagName("thead")[0]
        
        var tempNode = tbody.firstChild.cloneNode(true);
        tbody.removeChild(tbody.firstChild)
        thead.appendChild(tempNode);
        
        //table.setAttribute('rules', 'groups')
        //table.setAttribute('frame', 'void')
        
        cells_th[0].setAttribute('style', 'width: 55%');
        cells_th[1].setAttribute('style', 'width: 35%');
        cells_th[2].setAttribute('style', 'width: 10%');
        cells_th[0].innerHTML = "应用名称";
        cells_th[1].innerHTML = "发布者";
        cells_th[2].innerHTML = "版本";
        
        cells_td[0].setAttribute('style', 'padding-top: 10px');
        
        for(i = 0; i < cells_td.length; i++) {
            if(i % 3 == 0) {
                cells_td[i].className = "Regular";
            } else {
                cells_td[i].className = "Secondary";
            }
        }
    }
    
    window.onload=function(){tableStyle();}
</script>
"@

$CurrentDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Title = 'Installed UWP Packages'

Get-AppxPackage |
select @{name="Name";expression={(Get-AppxPackageManifest $_.PackageFullName).package.properties.displayname}},
@{name="Publisher";expression={(Get-AppxPackageManifest $_.PackageFullName).package.properties.publisherdisplayname}},
Version |
? {$_.Publisher -notlike "Microsoft Corporation"} |
? {$_.Publisher -notlike "Microsoft Platform Extensions"} |
? {$_.Name -notlike "*ms-resource*"} |
ConvertTo-Html -Title $Title -Head $Header -PreContent "<h1>$Title</h1>" -Property Name, Publisher, Version | 
Out-File "${CurrentDir}\Appxpackage.html"
