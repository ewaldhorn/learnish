OUT_DIR=zig-out

.PHONY: default
default:
	@echo
	@echo "Zig with WebUI."
	@echo
	@echo "Options:"
	@echo "default: Displays options."
	@echo "clean:   Cleans up the build artifacts."
	@echo "build:   Builds the binaries to the 'zig-out' directory."
	@echo "run:     Runs the project."
	@echo

.PHONY: run
run:
	@zig build run;

.PHONY: build
build:
	@zig build;

.PHONY: clean
clean:
	@rm -rf $(OUT_DIR)
