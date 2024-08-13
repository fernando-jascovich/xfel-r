# xfel-r

This repo has some software for using R.

## Environment

This repository contains 3 docker images for working in R. 
All images have their correspondent build command in [Makefile](./Makefile).

* base: base R lang installation and some common os libraries for r packages compilation.

* pandoc: this image adds to _base_ all required system dependencies to have pandoc and being able to export htmls and pdfs from Rmarkdown files.

* rstudio: this image adds to _pandoc_ a working rstudio server. When invoked, this image will run a very very very basic script to hold foreground execution waiting for a `ctrl+c` to tear rstudio server down.

## Execution

This repo has a [bin](./bin) directory which contains some bash scripts which could be automatically placed on `~/.local/bin` running `make install`. 

All those scripts depends on a successful `make all` command. This means all docker images built locally.

## nvim

I wrote a simple nvim plugin to have some basic R execution right into nvim. Given that this plugin is using `Rscript` executable, it should work in any (dockerized or not) environment with `Rscript` available at path. 

This nvim plugin offers the following commands:

| Command     | Description                                                   | Shortcut    |
| ---         | ---                                                           | ---         |
| Rexecute    | It executes R code passed as arg or visually selected         | `<leader>R` |
| RexecuteAll | It executes all code in current buffer                        |             |
| Rclear      | It clears R environment and default libraries added           |             |
| Rmarkdown   | It renders current rmarkdown file                             |             |
