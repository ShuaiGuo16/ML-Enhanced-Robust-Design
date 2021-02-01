## Effective Risk Mitigation Strategies for the Occurance of Combustion Instability using Machine Learning

<img src="./Images/Highlight.png" width=500 />

### 1. Highlight

- This work proposed and benchmarked various strategies to mitigate combustion instability risk given different robust design tasks.
- We trained Gaussian Process models to approximate the expensive physical simulations, thus achieving instant risk calculation.
- We integrate the trained machine learning models into global optimization routines, which allows us to efficiently identify the best design parameters that are robust against uncertain operating conditions.

This work was firstly presented in [ASME Turbo Expo 2019](https://event.asme.org/Turbo-Expo-2019), and was later published in the journal:

Guo S., Silva C. F., Polifke W., [Efficient Robust Design for Thermoacoustic Instability Analysis: A Gaussian Process Approach](https://asmedigitalcollection.asme.org/gasturbinespower/article-abstract/142/3/031026/955389/Efficient-Robust-Design-for-Thermoacoustic?redirectedFrom=fulltext). *Journal of Engineering for Gas Turbines and Power*, 2020, 142(3), pp. 031026.

### 2. Motivation

Effectively mitigate the combustion instability risk at the design stage is crucial for eliminating the costly design iterations and promoting an overall more reliable and competitive gas turbine product.

Risk mitigating requires finding the design parameters that are robust against various sources of uncertainties. Towards that end, an integration of risk analysis and global optimization is usually desired, where at each optimization iteration, a new set of design parameters are fed into the risk analysis module to calculate the associated instability risk value.


### 3. Methodology

To address the above-mentioned "optimization under uncertainty" problem, we firstly trained Gaussian Process models to approximate the expensive physical simulations. Subsequently, we integrated the trained GP model into the global optimization routines.

As a result, at each optimization iteration, the computational cost of the involved risk analysis can be significantly reduced, thus yielding an overall efficient combustor robust design.

<img src="./Images/Robust.png" width=200 />


### 4. Results

- Our trained GP models are sufficiently accurate to approximate the outputs of the expensive physical solver. 

<img src="./Images/GP_Prediction.png" width=500 />

- We systematically explored 4 different scenarios where risk mitigation is important. We  provided mathematical formulation and proposed efficient solution strategy for each of these problems. 

<img src="./Images/Mitigation.png" width=500 />

- Enabled by the trained GP models, we can now map the risk distribution across the entire parameter space, giving practitioners a powerful tool to realize robust design

<img src="./Images/Risk.png" width=400 />


### 5. Folder structure

**1. Presentation**: the slides presented in [ASME Turbo Expo 2019](https://event.asme.org/Turbo-Expo-2019) conference.

**2. MatlabScripts**: MATLAB source code and data to reproduce the results. The code and data are organized in individual folders corresponding to different sections in the paper. 