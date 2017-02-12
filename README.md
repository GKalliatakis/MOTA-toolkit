# Moving Object Tracking Algorithms (MOTA) evaluation toolkit

### An  evaluation toolkit for visual object tracking using different techniques. This repository contains the evaluation toolkit as a set of Matlab scripts, a documentation and a set of integration examples.
![alt tag](https://raw.githubusercontent.com/GKalliatakis/MOTA-toolkit/master/mota_overview.png)


### Introduction
The goal of this Visual Tracking exercise is to learn how to use basic tracking algorithms and evaluate their performances. 

The first technique is Background Subtraction, which can be used to initialize the tracker, i.e. to find the target’s position in the first frame of a sequence, or to track the target through the entire sequence.
There are different methods to estimate a model of the background, that is the static part of the scene. These include frame differencing (FD), running Gaussian averaging (RGA) and eigenbackground (EB) among others.

Another very effective technique for real-time tracking called Mean-Shift. Mean-Shift is a deterministic algorithm, as opposed to probabilistic ones, which solves the data association problem (matching) in a very effective way. Mean- Shift considers feature space as an empirical probability density function (pdf). 

### Overview
1. Background Subtraction
    - Frame Differencing (FD) Approach
    - Running Average Gaussian (RGA) Approach
    - Eigen Background (EB) Approach
    

2. Mean SHIFT


### Usage
Two different image sequences can be used car or highway. 
The variable "imPath" must be modifiedl accordingly in every Matlab script.
```sh
imPath = 'car'; imExt = 'jpg';
imPath = 'highway'; imExt = 'jpg';
```

### Examples: 

Open Matlab and add the current folder and subfolders to path then run one of the following commands for  Background Subtraction
```sh
EigenBackground
FrameDifferencing
RunningAverageGaussian
```

Open Matlab and add the current folder and subfolders to path then run one the following command for Mean SHIFT
```sh
Mean_Shift_Tracking
```

License
----
MOTA evaluation toolkit is released under the MIT License (refer to the LICENSE file for details).

**This app is for learning purposes, and not meant for any use in production / commercial purposes.**

### Question and Comments
If you would like to file a bug report or a feature request, use the Github issue tracker.

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax)


   [dill]: <https://github.com/joemccann/dillinger>
   [git-repo-url]: <https://github.com/joemccann/dillinger.git>
   [john gruber]: <http://daringfireball.net>
   [@thomasfuchs]: <http://twitter.com/thomasfuchs>
   [df1]: <http://daringfireball.net/projects/markdown/>
   [markdown-it]: <https://github.com/markdown-it/markdown-it>
   [Ace Editor]: <http://ace.ajax.org>
   [node.js]: <http://nodejs.org>
   [Twitter Bootstrap]: <http://twitter.github.com/bootstrap/>
   [keymaster.js]: <https://github.com/madrobby/keymaster>
   [jQuery]: <http://jquery.com>
   [@tjholowaychuk]: <http://twitter.com/tjholowaychuk>
   [express]: <http://expressjs.com>
   [AngularJS]: <http://angularjs.org>
   [Gulp]: <http://gulpjs.com>

   [PlDb]: <https://github.com/joemccann/dillinger/tree/master/plugins/dropbox/README.md>
   [PlGh]:  <https://github.com/joemccann/dillinger/tree/master/plugins/github/README.md>
   [PlGd]: <https://github.com/joemccann/dillinger/tree/master/plugins/googledrive/README.md>
   [PlOd]: <https://github.com/joemccann/dillinger/tree/master/plugins/onedrive/README.md>
