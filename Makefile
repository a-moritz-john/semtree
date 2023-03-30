PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename `pwd`)

all: rd readme check clean

pkgdown:
	Rscript -e 'pkgdown::build_site()'

rd:
	Rscript -e 'roxygen2::roxygenise(".")'

readme:
	Rscript -e 'rmarkdown::render("README.Rmd", "md_document")'

build:
	cd ..;\
	R CMD build $(PKGSRC)

buildfast:
	cd ..;\
	R CMD build --no-build-vignettes $(PKGSRC)

install:
	cd ..;\
	R CMD INSTALL $(PKGNAME)_$(PKGVERS).tar.gz


check: build
	cd ..;\
	R CMD check --as-cran $(PKGNAME)_$(PKGVERS).tar.gz
	
dockercheck:
	docker run r-devel-local `R CMD check --as-cran ../$(PKGNAME)_$(PKGVERS).tar.gz`

clean:
	cd ..;\
	$(RM) -r $(PKGNAME).Rcheck/

vignette:
	Rscript -e 'devtools::build_vignettes()'
	
