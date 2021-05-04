<p align="center">
  <img width="500" src=MitC_logo.png>
</p>

_The MitC software is currently under development and in a pre-release state._

The Mitigation Controller (MitC) deals with the development of an automated risk-mitigation tool for construction projects. The MitC is a state-of-the-art tool that can assist project managers to have a full grip on the progress of their running construction projects. It takes as input a complete project schedule and returns several outputs that help the project manager take actions to prevent potential delays. 


The source code was developed and tested with MATLAB R2019a.

The following is a step-by-step guide to help users get started with the MitC software. It includes two parts: 1) Installation and 2) Working with the software. 

In case you encouteed any issue, please let us know by creating a new issue using the appropriate [templates](https://github.com/mitigation-controller/mitc/issues/new/choose).

## Installation

* Download the reposity as a zip file. For the latest release, please check [releases page](https://github.com/mitigation-controller/mitc/releases) for available downloads. Please download the newest release.
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

Note that the MitC comes in two versions, the basic and te advanced versions. The advanced version allows incorporating penalty and reward in the optimiation problem. It also allows accounting for the correlations among the activities' durations. Students are recommended to use the basic version in their work and ignore all steps that are related to the advanced version.

### Input data
Data must be structured following a predefined spreadsheet form (.xlsx). A template is already provided in the package directory. 

* Locate the data file template `Case study`, or other available templates, in the package directory
* Insert data related to the project activities: activities' descriptions, activities' durations (three estimates for each: optimistic, most likely, and pessimistic), and activities' predecessors. A predecessor is an activity that precedes another activity – not in the chronological sense but according to their dependency to each others. You may insert more than one predecessor by separating them with a `space` or a comma `,`.

<p align="center">
  <img width="500" src=figures/Slide6.PNG>
</p>

* Data related to the mitigation measures. Mitigation measures are corrective activities that are implemented to reduce the durations of other activities, and thus the duration of the project. 

* Insert data related to the mitigation measures: measures' descriptions, measures' durations (three estimates for each: minimum, most likely, and maximum), measures' cost (three estimates for each: minimum, most likely, and maximum), and the relationships between the measures and the activities. One Mitigation measure can influence (i.e., reduce the time of) one or more activities. You may insert more than one activity by separating them with a `space` or a comma `,`.


<p align="center">
  <img width="500" src=figures/Slide7.PNG>
</p>

* Data related to the risk events. Risk events are additional source of delay if they occur. Risk events have a probability of occurance. If they occur, they can negatively affect the durations of project activities.

* Insert data related to the risk events: risks' descriptions, risks durations (the delay induced by each risk; three estimates for each risk event: minimum, most likely, and maximum), and the relationships between the risk events and the activities. One risk event can influence (i.e., increase the time of) one or more activities. You may insert more than one activity by separating them with a `space` or a comma `,`.

<p align="center">
  <img width="500" src=figures/Slide8.PNG>
</p>

* Factors such as site conditions, labor skills, and weather can have an impact on the duration of construction activities. These factors may simultaneously influence multiple activities in a particular project and may cause activity durations to be correlated. The MitC allows including these shared factors to account for the correlations between the activities' durations.
* Insert data related to activities' correlation: description of the shared uncertainty factors, durations of the shared uncertainties (three estimates for each factor: minimum, most likely, and maximum), where the most likely factor should be set to zero, and the relations with activities (i.e., the activities that share the uncertainty factor).
 
Note that the correlation section is only necessary for the advanced version. Students should ignore filling this field of the spreadsheet if they intend to use the basic version

<p align="center">
  <img width="500" src=figures/Slide9.PNG>
</p>

### Analysis
* Import your data using the `Load project data` button.

<p align="center">
  <img width="500" src=figures/Slide10.PNG>
</p>

The MitC algorithm uses Monte Carlo simulation. Every Monte Carlo iteration is a possible scenario. In every Monte Carlo iteration, the MitC chooses random values for the projects durations, Mitigation measures durations, and risks durations from the defined durations ranges (mminimum, most ikely, and Maximum). In ever iteration, the MitC finds the most effective set of mitigations measures (i.e., mitigation strategy) that is best for that iteration.

* Select the number of Monte Carlo iterations (The minimum recommended value is 2000).
* Select the taget duration of the project. This is the duration that you would like to finish your project within. 

<p align="center">
  <img width="500" src=figures/Slide11.PNG>
</p>

* Choose between the `basic` and `advanced` versions of the software. The advanced version allows considering the effect of penalty and reward in the optimization problem. It additionally allows considering the correlations between the activities' durations. Students are advised to choose the `basic` version. 

<p align="center">
  <img width="500" src=figures/Slide12.PNG>
</p>

* If you select the `advanced` version, you should insert the amount of daily penlaty in case of delay and the amount of daily reward in case of early finish of the project. These will be used in the optimization problem to further tune the optimal completion date of the project so that the net cost is minimum.

<p align="center">
  <img width="500" src=figures/Slide13.PNG>
</p>


* Select the folder where you want to save the results of the simulation. You may choose the `results` folder that already exists in the package directory

<p align="center">
  <img width="500" src=figures/Slide14.PNG>
</p>

* Run the simulation
* You can see the status of the MitC using the status indicator. You can also read the history of your actions using history box.
* You may reset the MitC by clicking on the `Reset` button

<p align="center">
  <img width="500" src=figures/Slide15.PNG>
</p>

### Output 
The results will be saved in the selected output folder. The results below have been obtained using the `basic` version.

Figure below:
* Left figure: project network with nodes being the activities and links being the activities relationships. The number on the link represents the duration of the activity on the start edge of the link and the number on the node represents the activity's ID.

* Right figure: the cumulative probability of project completion time for three cases:
1) No Mit: simulation with NO mitigation measures included;
2) Permanent: simulation with ALL mitigation measures included;
3) Tentative: simuation with the OPTIMAL mitigation measures (the MitC).

<p align="center">
  <img width="500" src=figures/Slide16.PNG>
</p>

Figure below:

* Left figure: probability density function (PDF) of the mitigation cost for two cases:
1) Permanent: the distribution of mitigation cost when ALL mitigtion measures are included;
2) Tentative: the distribution of mitigation cost when only the OPTIMAL mitigation measures are included (the MitC).

* Right figure: cumulative distribution function (CDF) of the mitigation cost for two cases above.


<p align="center">
  <img width="500" src=figures/Slide17.PNG>
</p>

Figure below:

* Top left figure: Criticality Index of project activities-the criticality index expresses how often a particular activity was on the Critical Path during the Monte Carlo simulation (the ratio between the number of iterations where a given activity was on the critical path over the total number of iterations);
* Top right figure: Criticality Index of project paths-the ratio between the number of iterations where a given path was a critical path over the total number of iterations;
* Botton figure: Criticality Index of mitigation measures-the ratio between the number of iterations where a given mitigation measure was included in the mitigation strategy over the total number of iterations.

<p align="center">
  <img width="500" src=figures/Slide18.PNG>
</p>

### Further reading material
* Journal paper on the basic version (in press): to be added
* Journal paper on the advanced version (under review): to be added
* Recorded tutorial on the use of the Mitigation controller (basic version). Please note that more features have been implemented so you may find some differences. The results, however, should be the same.
