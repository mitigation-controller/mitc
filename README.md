<p align="center">
  <img width="500" src=doc/MitC_logo.png>
</p>

![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/mitigation-controller/mitc?include_prereleases)
![GitHub](https://img.shields.io/github/license/mitigation-controller/mitc)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4507336.svg)](https://doi.org/10.5281/zenodo.4507336)
[![codecov](https://codecov.io/gh/mitigation-controller/mitc/branch/main/graph/badge.svg?token=9OZ7V9WWY2)](https://codecov.io/gh/mitigation-controller/mitc)

The ongoing research deals with the development of an automated risk-mitigation tool for construction projects, namely the Mitigation Controller (MitC). MitC is a state-of-the-art tool that can assist project managers to have a full grip on the progress of their running construction projects. It takes as input a complete project schedule and returns several outputs that help the project manager take actions to prevent potential delays. 

The source code was developed and tested with MATLAB R2019a and R2020b.

Work done by:

* Omar Kammouh: Algorithm development
* Maurits Kok: GUI development
* Maria Nogal Macho: Supervision and Software maintenance
* Rogier Wolfert: Concept development and supervision
* Ruud Binnekamp: Concept development and supervision

## Installation
* Download the reposity as a zip file. For the latest release, please check [releases page](https://github.com/mitigation-controller/mitc/releases) for available downloads.
* Extract the zip archive on your computer.

### MATLAB installation:
User has access to MATLAB version 2019a or higher. The code requires the _Optimization Toolbox_ and the _Statistics and Machine Learning Toolbox_ to be installed.

* Run MATLAB and click `Install App` under the `APPS` tab. 
* Locate the file `MitC_app` in the package directory to install the app.
* The app can now be run from the Apps menu in MATLAB.

### Stand-alone installation:
User does not have access to MATLAB: 

* Navigate to the installer directory and execute the installer `MitC setup`. The installer will download the MATLAB Runtime (~700 MB) and install the MitC application.
* Run the installed application. 

## User documentation
For a detailed explanation about installing and using the software, please look at out [user documentation](https://github.com/mitigation-controller/mitc/tree/main/doc/User_Manual.md).

## Did you find a bug or have a feature request?
Excellent, please have a look at our contribution [guidelines](https://github.com/mitigation-controller/mitc/blob/main/CONTRIBUTING.md).

## Contributing
You are welcome to contribute as developer to the code via pull requests. Please look at the contribution [guidelines](https://github.com/mitigation-controller/mitc/blob/main/CONTRIBUTING.md).

#### Prerequisites:
* MATLAB 2019a or higher.
* The _Optimization Toolbox_ , _Statistics and Machine Learning Toolbox_, and _Application Compiler_.

#### Installation
* Download the MitC repository from via a terminal:
`git clone https://github.com/mitigation-controller/mitc.git`
* All source code can be found in the mitc directory.

## Licensing
The source code and data of MitC are licensed under the Apache License, version 2.0. 
