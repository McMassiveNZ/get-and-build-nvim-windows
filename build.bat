@echo off

IF "%~1" == "--clean" (
	PUSHD ..
	IF EXIST "neovim" (
		ECHO "Removing old neovim directory"
		rmdir /s /q "neovim"
	)
	POPD
)

PUSHD ..
IF NOT EXIST "neovim" (
	git clone https://github.com/neovim/neovim.git
)

PUSHD neovim

cmake -S cmake.deps -B .deps -D CMAKE_BUILD_TYPE=Release
cmake --build .deps --config Release
cmake -S . -B build -D CMAKE_BUILD_TYPE=Release
cmake --build build --config Release
cmake --install build --config Release --prefix "C:\Program Files\nvim"

POPD
PUSHD get-and-build-nvim-windows
