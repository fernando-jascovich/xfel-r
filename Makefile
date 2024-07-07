.PHONY: build-all
build-all: build-base build-pandoc build-rstudio

.PHONY: build-base
build-base: Dockerfile.base
	docker build -t xfel-r-base -f Dockerfile.base .

.PHONY: build-pandoc
build-pandoc: Dockerfile.pandoc
	docker build -t xfel-r-pandoc -f Dockerfile.pandoc .

.PHONY: build-rstudio
build-rstudio: Dockerfile.rstudio
	docker build -t xfel-r-rstudio -f Dockerfile.rstudio .

install:
	cp bin/R ~/.local/bin/R
	cp bin/Rscript ~/.local/bin/Rscript
	cp bin/rstudio ~/.local/bin/rstudio

uninstall:
	rm ~/.local/bin/R
	rm ~/.local/bin/Rscript
	rm ~/.local/bin/rstudio
