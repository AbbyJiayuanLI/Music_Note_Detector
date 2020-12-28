# Introduction
In this project, we developed a note detection system which can receive a piece of monophonic music played by piano and identify which note is present at each moment in the music. We utilized the frequency relationship between pitch and harmonics components in music and estimated the music notes by calculating the signal period within a short time window. 

Altogether 5 methods from time domain, frequency domain, and time-frequency domain are presented with detection accuracy all above 32/33 and detection error rate around lower than 22%. We also tried to apply down-sampling to reduce computational complexity and addressed our newly-found octave jump problem using subtraction method. Further improvements such as end-point detection and polyphonic music note detection are discussed as well.

# Basic Concept
  1. Pitch, harmonics, standing wave
      - https://www.zhihu.com/topic/20762575/intro
      - https://en.wikipedia.org/wiki/Fundamental_frequency
      
# Project Structure
  1. Music Recording
  2. Framing
  3. Silence Checking
  4. Note Detection
  5. Smoothing
  6. Result Evaluation
  
# Detection Methods
  1. Method Overview
     - http://mirlab.org/jang/books/audiosignalprocessing/
  2. Time Domain
     - Short-term autocorrelation method (ACF)
     - Short-term average amplitude difference function (AMDF)
  3. Frequency Domain
     - Harmonic product spectrum (HPS)
     - Cepstrum
  4. Wavelet Transform 小波变换
      - For non-stationary signal, non-decaying FT is not a good choice
      - localize frequency and time by scaling and shifting wavelet
          - https://zhuanlan.zhihu.com/p/22450818
          - http://users.rowan.edu/~polikar/WTtutorial.html
          - https://zhuanlan.zhihu.com/p/44215123
          - https://zhuanlan.zhihu.com/p/44217268
          
# Extension
  1. Down-sampling
  2. Octave Jump Error: subtraction method
  
# Work Division
  1. Li Jiayuan: Time domain methods, Wavelet Transform
  2. Xiao Nan: Frequency domain methods, Wavelet Transform
  
# Milestones
I would like to continue this topic after finishing the project. Here I list some future goals to achieve.

1. End-point Detection
2. Weak Note Detection
3. Polyphonic Music Note Detection
    - Iterative Subtraction: Harmonic Model? Overlapping Harmonics?

