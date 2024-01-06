@echo off

SET DEFAULT_INSTALL_DIR=%USERPROFILE%\apps\nvim
SET INSTALL_DIR=%DEFAULT_INSTALL_DIR%

:PARSE_ARGS

IF "%~1" == "" (
	goto END_PARSE
)

IF "%~1" == "--help" (
	ECHO Parameters:
	ECHO 	--clean: Deletes an existing neovim directory forcing a new one to be pulled from Github
	ECHO 	--install_dir "<directory>" Specifies that the neovim binary data will be copied to "<directory>" after its built
	ECHO:
	ECHO	If "<directory>" is empty of --install_dir isn't passed at all then the data will be copied to
	ECHO	the default dir %USERPROFILE%\apps\nvim		

	GOTO EXIT
)

IF "%~1" == "--clean" (
	PUSHD ..
	IF EXIST "neovim" (
		ECHO "Removing old neovim directory"
		rmdir /s /q "neovim"
	)
	POPD
)

IF "%~1" == "--install_dir" (
	IF "%~2" == "" (
		ECHO A directory to install neovim into is required. Using Default Path %DEFAULT_INSTALL_DIR%
		SET INSTALL_DIR=%DEFAULT_INSTALL_DIR%
	) ELSE (
		SET INSTALL_DIR="%~2"
	)
)
SHIFT
GOTO PARSE_ARGS
:END_PARSE

PUSHD ..
IF NOT EXIST "neovim" (
	git clone https://github.com/neovim/neovim.git
)

PUSHD neovim

cmake -S cmake.deps -B .deps
cmake --build .deps --config Release
cmake -S . -B build
cmake --build build --config Release

ECHO installing into %INSTALL_DIR%
cmake --install build --config Release --prefix %INSTALL_DIR%

POPD
PUSHD get-and-build-nvim-windows

:EXIT