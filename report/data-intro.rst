Dataset
-------

The dataset used came from the US Forest Service inventory information and
information derived from standard digital spatial data processed in a geographic
information system as gathered by Jock A. Blackard and Denis J. Dean
[original]_.

The classification variable is the forest cover type, this is one of seven
mutually exclusive classes.  The cover type maps were created by the US Forest
Service and derived from large-scale aerial photography.

The rest of the variables were derived from digital spatial data obtained from
the US Geological Survey and the US Forest Service.  The variables used were:

 1. Elevation (m)
 2. Aspect (azimuth from true north)
 3. Slope (°)
 4. Horizontal distance to nearest surface water feature (m)
 5. Vertical distance to nearest surface water feature (m)
 6. Horizontal distance to nearest roadway (m)
 7. A relative measure of incident sunlight at 09:00 h on the summer solstice (index)
 8. A relative measure of incident sunlight at noon on the summer solstice (index)
 9. A relative measure of incident sunlight at 15:00 h on the summer solstice (index)
 10. Horizontal distance to nearest historic wildfire ignition point (m)
 11. Wilderness area designation (four binary values, one for each wilderness area)
 12. Soil type designation (40 binary values, one for each soil type).

All numeric values in the dataset were mapped into the range (-1,1), this makes
ensuring that any constants generated are in the right range a lot easier.

The dataset was then split into three mutually exclusive and distinct sets, a training set, validation set and
test set.  The full data set contained 581 012 observations, the training set
was composed of 1620 randomly selected observations from each cover type (11 340
observations total), the validation set was composed of 540 randomly selected
observations from each cover type (3780 observations total) and the test set was
the rest of the observations (565 892).

These sets were chosen to match the original study by Blackard and Dean, this
way the results of this study could easily be compared to that study.

.. [original] temp
