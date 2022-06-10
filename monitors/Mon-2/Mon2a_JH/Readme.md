This version of MON2 is largely no different from the original listing of MON2, as written by Ken Stone, except it was decompiled by John Hardy in 2018 and commented to a large extent.
It was then further corrected and commented by Mark Jelic in 2021, who also added a Keyboard Remap feature, based on code designed by Ben Grimmett.
It is byte correct to the original MON2 written by Ken Stone except for the following changes:
1. The NMI routine at $0066 is changed to allow for the Keyboard Remap.
2. Code is added at $0700 and $0720 for the Keyboard Remap routine.
3. The frequency tables have been corrected to escalate in an a more natural audible sequence.

To modify the keyboard map, edit the table at $0700 and you too could end up with a keyboard like this!
![image](https://user-images.githubusercontent.com/13119623/150658355-a8cf0b0e-6d3f-4f7e-86ce-2c565873ef79.png)