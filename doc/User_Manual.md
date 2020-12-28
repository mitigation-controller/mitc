<p align="center">
  <img width="500" src=MitC_logo.png>
</p>

_The MitC software is currently under development and in a pre-release state._

The Nitigation Controller (MitC) deals with the development of an automated risk-mitigation tool for construction projects, namely the Mitigation Controller (MitC). MitC is a state-of-the-art tool that can assist project managers to have a full grip on the progress of their running construction projects. It takes as input a complete project schedule and returns several outputs that help the project manager take actions to prevent potential delays. 

The source code was developed and tested with MATLAB R2019a.

The following is a step-by-step guide to help users get started with the MitC software. It includes two parts: 1) Installation and 2) Working with the software. 

Work done by:

* Omar Kammouh: Algorithm development
* Maurits Kok: GUI development
* Maria Nogal Macho: Supervision and Software maintenance

## Installation

* Download the reposity as a zip file. For the latest release, please check [releases page](https://github.com/mitigation-controller/mitc/releases) for available downloads.
* Extract the zip archive on your computer.

<p align="center">
  <img width="500" src=figures/Slide1.PNG>
</p>

### Installation using MATLAB:
User has access to MATLAB version 2019a or higher. The code requires the _Optimization Toolbox_ and the _Statistics and Machine Learning Toolbox_ to be installed. If you do not have Matlab installed yet, make sure to select these toolboxes to be installed with Matlab. If you do have Matlab installed, you could independently install these two toolboxes by searching in the `Get More Apps` under the `APPS` tab. When the toolboxes are installed, proceed with installing the MitC:

* Run MATLAB and click `Install App` under the `APPS` tab.
* Locate the file `MitC_app` in the package directory to install the app.

<p align="center">
  <img width="500" src=figures/Slide2.PNG>
</p>

* The app can now be run from the Apps menu in MATLAB.

<p align="center">
  <img width="500" src=figures/Slide3.PNG>
</p>

### Stand-alone installation:
User does not have access to MATLAB: 

* Navigate to the installer directory and execute the installer `MitC setup`. The installer will download the MATLAB Runtime (~700 MB) and install the MitC application.

<p align="center">
  <img width="500" src=figures/Slide4.PNG>
</p>

* Run the installed application.

<p align="center">
  <img width="500" src=figures/Slide5.PNG>
</p>

## Working with the software

### Input data
Data must be structured following a predefined spreadsheet form (.xls). A template is already provided in the package directory.

* Locate the data file `Case study` in the package directory
* Insert data related to the project activities: activities' descriptions, activities' durations (three estimates for each: optimistic, most likely, and pessimistic), and activities' predecessors. A predecessor is an activity that precedes another activity – not in the chronological sense but according to their dependency to each others. You may insert more than one predecessor by separating them with a `space` or a comma `,`.

<p align="center">
  <img width="500" src=figures/Slide6.PNG>
</p>

Mitigation measures are corrective activities that are implemented to reduce the durations of other activities, and thus the duration of the project. 

Insert data related to the mitigation measures: measures' descriptions, measures' durations (three estimates for each: minimum, most likely, and maximum), measures' cost (three estimates for each: minimum, most likely, and maximum), and the relationships between the measures and the activities. One Mitigation measure can influence (i.e., reduce the time of) one or more activities. You may insert more than one activity by separating them with a `space` or a comma `,`.


<p align="center">
  <img width="500" src=figures/Slide7.PNG>
</p>

Risk events are additional source of delay if they occur. Risk events have a probability of occurance. If they occur, they can negatively affect the durations of project activities.

Insert data related to the risk events: risks' descriptions, risks durations (the delay induced by each risk; three estimates for each risk event: minimum, most likely, and maximum), and the relationships between the risk events and the activities. One risk event can influence (i.e., increase the time of) one or more activities. You may insert more than one activity by separating them with a `space` or a comma `,`.

<p align="center">
  <img width="500" src=figures/Slide8.PNG>
</p>

### Analysis

<p align="center">
  <img width="500" src=figures/Slide9.PNG>
</p>

<p align="center">
  <img width="500" src=figures/Slide10.PNG>
</p>

<p align="center">
  <img width="500" src=figures/Slide11.PNG>
</p>

<p align="center">
  <img width="500" src=figures/Slide12.PNG>
</p>

### Output 

<p align="center">
  <img width="500" src=figures/Slide13.PNG>
</p>

<p align="center">
  <img width="500" src=figures/Slide14.PNG>
</p>

<p align="center">
  <img width="500" src=figures/Slide15.PNG>
</p>
