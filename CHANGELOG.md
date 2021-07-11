# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2021-07-11

### Fixed
- Fix `remove_missing.m` to check for data type "missing"

### Added
- Testing environment coupled with GitHub actions and Codecov
- Penalty/incentive functionality
- Add verification of project data

### Changed
- Update GUI layout to include penalty/incentive
- Update GUI with document and feedback buttons
- Update GUI to show T_orig
- Update GUI to verify raw data
- Update messages and errors
- General code refactoring

## [0.1.1] - 2021-01-18

### Fixed
- Issue with missing T_pl in `select_critical_path.m`

## [0.1.0] - 2020-12-18

### Added

- MATLAB GUI 
- MitC stand-alone installer 
- MATLAB package 
- README.md
- CITATION.cff
- CHANGELOG.md

### Changed
- Restructured repository directories
- Create modular code base to make it callable by GUI

## [0.0.1] - 2020-10-02

### Added

- This is the initial version of mitc.
- 
[0.2.0]: https://github.com/mitigation-controller/mitc/releases/tag/0.2.0
[0.1.1]: https://github.com/mitigation-controller/mitc/releases/tag/0.1.1
[0.1.0]: https://github.com/mitigation-controller/mitc/releases/tag/0.1.0
[0.0.1]: https://github.com/mitigation-controller/mitc/releases/tag/0.0.1
