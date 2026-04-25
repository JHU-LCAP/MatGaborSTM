
# STM MATLAB functions

MATLAB functions to compute **spectrotemporal modulation representations** from audio signals.

This pipeline allows you to:
- compute a **cochlear spectrogram**
- estimate a **spectrotemporal modulation profile** (MPS/MRF)

## Example output

### Spectrogram
![Spectrogram](examples/Spectrogram.png)

### Modulation profile
![Modulation profile](examples/STM.png)


---

## Getting started

Add the functions to your MATLAB path:

```matlab
addpath(genpath('path_to_repo/functions'));
```

Then run one of the scripts in the `examples/` folder.

---

## Getting started

Add the functions to your MATLAB path:

```matlab
addpath(genpath('path_to_repo/functions'));
```

Then run one of the scripts in the `examples/` folder.

---

## Dependencies

This code requires:

- MATLAB
- Auditory Modeling Toolbox (AMToolbox)

Download AMToolbox:  
https://amtoolbox.org

Add it to your MATLAB path:

```matlab
addpath(genpath('path_to_amtoolbox'));
```

---

## Example audio

The example audio file is derived from the **LJ Speech Dataset** (public domain):  
https://keithito.com/LJ-Speech-Dataset/

## Author

Moïra-Phoebé Huet  
Johns Hopkins University  
mphuet@jhu.edu
