Spatial Allocator v4.4 (June 2019 release)
======

The Spatial Allocator (SA) is a set of tools that helps users manipulate and generate data files related to emissions and air quality modeling. The tools perform functions similar to Geographic Information Systems (GIS), but are provided to the modeling community free of charge. In addition, the tools are designed to support some of the unique aspects of the file formats used for Community Multiscale Air Quality (CMAQ), Sparse Matrix Operator Kernel Emissions (SMOKE), and Weather Research and Forecasting (WRF) modeling.

The SA is licensed as open-source Linux software that was developed with funding from the U.S. EPA. The SA uses GIS industry standard ESRI shapefiles, image files supported by GDAL, netCDF files and plain text data files as input and output data.

Getting the Spatial Allocator from GitHub
---

```
git clone https://github.com/CMASCenter/Spatial-Allocator.git
```

Getting Test Data for the Spatial Allocator
---
Download data to test your Spatial Allocator installation from http://www.cmascenter.org.

Spatial Allocator Repository Guide
---
The SA code, scripts, and executables are organized in the following directories:

- **bin** - SA 32-bit and 64-bit Linux executables
- **data** - Input data for testing the SA installation (download from the [CMAS Center](http://www.cmascenter.org))
- **docs** - SA Documentation
- **pg_srgtools** - C-shell scripts for running the PostgreSQL and Java driver version of [Surrogate Tools](docs/User_Manual/SA_ch05_surrogate.md#postgres)
- **raster_scripts** - C-shell scripts for running the [Raster Tools](docs/User_Manual/SA_ch04_raster.md)
- **ref** - location of reference data for verifying the SA installation (download from the [CMAS Center](http://www.cmascenter.org))
- **scripts** - C-shell scripts for running the [Vector Tools](docs/User_Manual/SA_ch03_vector.md)
- **src** - SA source code and 3rd-party libraries
- **srgtools** - C-shell scripts for running the C/C++ and Java driver version of [Surrogate Tools](docs/User_Manual/SA_ch05_surrogate.md)
- **util** - miscellaneous utility scripts to support the SA tools

Documentation
---

[Spatial Allocator User's Guide](docs/User_Manual/README.md)

[Spatial Allocator version 4.4 Release Notes](docs/Release_Notes/README.md)
