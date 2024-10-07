CC=zig
RUNNER=http-server
RUNNER_PARAMS=. -p 9000 -o -c-1
LICENSE_FILE=LICENSE.TXT
README_FILE=README.md
SRC_DIR=src
MAIN_FILE=checkerboard.zig
OUT_DIR=static
OUT_FILE=checkerboard.wasm
EXPORTS=--export=getCheckerboardBufferPointer --export=getCheckerboardSize --export=colorCheckerboard

.PHONY: default
default:
	@echo
	@echo "Make file to use Zig as a Wasm compiler."
	@echo
	@echo "Options:"
	@echo "default: Displays make options."
	@echo "license: Displays the license file."
	@echo "readme:  Displays the readme file."
	@echo "run:     Runs the HTML project."
	@echo "clean:   Cleans up the build artifacts."
	@echo "build:   Builds the binaries to the bin directory."
	@echo "test:    Runs the project tests."
	@echo

.PHONY: license
license:
	cat $(LICENSE_FILE)

.PHONY: readme
readme:
	cat $(README_FILE)

.PHONY: run
run:
	@cd $(OUT_DIR);$(RUNNER) $(RUNNER_PARAMS);cd ..;

.PHONY: test
test:
	@clear;cd $(SRC_DIR);$(RUNNER) $(TEST_FILE) $(INCLUDE_FILES);cd ..;

.PHONY: clean
clean:
	@rm -rf $(OUT_DIR)

.PHONY: build
build:
	@mkdir -p $(OUT_DIR);$(CC) build-exe ./$(SRC_DIR)/$(MAIN_FILE) -target wasm32-freestanding -fno-entry $(EXPORTS) -femit-bin=$(OUT_DIR)/$(OUT_FILE);
