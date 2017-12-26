# where do you want your files to go?
New-Variable -name dst 				-value $env:USERPROFILE\Documents

# what regular expression should the files match that get excluded?
# if you have no idea how to make regexes, check www.rubular.com
$excludeRegex=".*\.((git)|(ps1)).*"


New-Variable -name directory 		-value ($(get-item $pwd).Name)
foreach($line in Get-Content .\$directory.txt) {
    if($line -match [regex] '(?<=^##\sVersion:\s)[\d\W]+(?=$)'){
       New-Variable -name version -value $matches[0]
    }
}

New-Variable -name compressionLevel -value [System.IO.Compression.CompressionLevel]::Optimal
New-Variable -name path 			-value (split-path -parent $PSCommandPath)
New-Variable -name zipName 			-value ($directory + "_" + $version)
New-Variable -name zipfile 			-value ("$dst\$zipName.zip")

echo "zipping :" 
echo $path
echo $zipfile
echo ""

#delete if exist
If(Test-path $zipfile) {Remove-item $zipfile}


#clean up zip file 
Add-Type -Assembly "System.IO.Compression.FileSystem";
Compress-Archive -Path $path -DestinationPath $zipfile -CompressionLevel Fastest

$stream = New-Object IO.FileStream($zipfile, [IO.FileMode]::Open)
$mode   = [IO.Compression.ZipArchiveMode]::Update
$zip    = New-Object IO.Compression.ZipArchive($stream, $mode)

($zip.Entries | ? { $_.FullName -match $excludeRegex }) | % { 
	# echo "deleting" $_.FullName
	$_.Delete()
}

$zip.Dispose()
$stream.Close()
$stream.Dispose()
