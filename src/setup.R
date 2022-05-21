# Setup project. Get and initialize renv - package for management
# of project environment.

# install package
if (!require("renv")) {
  install.packages("renv")
}

# initialize - used only for creating project setup
# renv::init()

# get dependencies required by the project
renv::restore()
