TINIBA
===========================
TINIBA is a program to do ab-initio calculations of optical responses of crystalline solids, based on the popular ABINIT.

Introduction
-------------------

This is the official 3.0 release. New features and fixes are added all the time via different branches, and then merged into the master branch. Full documentation for the project is located in the tiniba-manual repository. It is a work in progress but will allow the average user to get up and running without too many problems.

This project was built by the PRONASIS group of the Centro de Investigaciones en Óptica, A.C. in Mexico. It has been a collaborative project spanning almost a decade. TINIBA has been used in (at least) the following articles:
* J Opt Soc Am B 28 1882 (2011)
* Mod Phys Lett B 24, 1507 (2010)
* Opt Laser Eng 49, 668 (2011)
* Opt Mater 29, 1 (2006)
* Phys Rev B 73, 195330 (2006)
* Phys Rev B 74, 075318 (2006)
* Phys Rev B 76, 205113 (2007)
* Phys Rev B 79, 245132 (2009)
* Phys Rev B 80, 155205 (2009)
* Phys Rev B 80, 201312 (2009)
* Phys Rev B 80, 245204 (2009)
* Phys Rev B 84, 165316 (2011)
* Phys Rev B 84, 195326 (2011)
* Phys Rev B 85, 165324 (2012)
* Phys Status Solidi B 242, 3022 (2005)
* Phys Status Solidi B 247, 1979 (2010)
* Phys Status Solidi C 8, 2604 (2008)
* Phys Status Solidi C 9, 1378 (2012)
* Surf Sci 605, 941 (2011)

Installation
-------------------

To clone the repo simple run:
```
git clone --recursive git@github.com:roguephysicist/tiniba.git
git submodule update --init --recursive
```

To update submodules:
```
git submodule foreach git pull
```

I suggest adding these lines to the appropriate shell file:

```bash
export TINIBA=$HOME/tiniba
export PATH="$TINIBA/clustering/itaxeo:$TINIBA/utils:$PATH"
```


Work in Progress
-------------------
A PSP warning for spin/vnl would be supremely useful. Remember that `pspnc` is NO spin, good for Vnl. `hgh` is spin enabled, and unusable for Vnl.

### Not working
* 26 : ndotccp : layer carrier injection

### rho
* pmn.f90: lines 354 - 367
* ndotccp: calrho is seriously FUBAR
* sub_pmn_ascii.f90: lines 1145 - 1150


Adding Responses
-----------------------
### `latm/SRC_1setinput`
* `integrands.f90`:
    - [ ] add new case => new number and new subroutine
* `inparams.f90`:
    - [ ] add new case at the top of the program 
    - [ ] change: number_of_known_spectrum_types
    - [ ] add spectrum_factor() at the end of it
    - [ ] add new case so one knows what's calculated
* `symmetry_operations.f90`:
    - [ ] add new case at the top of the program
    - [ ] add new case for the correct transformation
