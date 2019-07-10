$VERSION="v0.2-alpha"
$DST_DIR=".cradle"
$DST_FILE="$DST_DIR/cradle.hpp"
$DST_SHA256="08a98cb5136dbf670a1bc40683c0b6284ac0ce70a2009a9c135bf55f53fd4f97" # Leave empty to ignore
$BUILD_DIR="build"

If (-Not (Test-Path $DST_DIR)) {
	New-Item -ItemType directory -Path $DST_DIR
}
If (-Not (Test-Path $BUILD_DIR)) {
	New-Item -ItemType directory -Path $BUILD_DIR
}

If (-Not (Test-Path $DST_FILE)) {
	[Net.ServicePointManager]::SecurityProtocol = "Tls12, Tls11, Tls, Ssl3"
	Invoke-WebRequest -Uri https://github.com/mohaque0/cradle/releases/download/$VERSION/cradle.hpp -OutFile $DST_FILE
}

$actualHash = $(CertUtil -hashfile build\cradle.hpp SHA256)[1]
If ([string]::IsNullOrEmpty($DST_SHA256)) {
	Write-Output "Not checking hash because expected hash is empty."
} ELSE {
	Write-Output "Checking cradle hash."
	If (-Not (($actualHash) -Eq ($DST_SHA256))) {
		Write-Output "Downloaded file hash $actualHash doesn't match the expected $DST_SHA256."
		return
	}
}

Write-Output "Compiling Cradle..."
iex "cl /I$DST_DIR build.cpp /std:c++14 /Fo:$DST_DIR/build.obj /Fe:$BUILD_DIR/cradle"

iex "$BUILD_DIR\cradle $args"
