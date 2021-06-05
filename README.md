# Product-Remainder-Tree
A Haskell implementation of the product-remainder tree in the paper *[Mining Your Ps and Qs: Detection of Widespread Weak Keys in Network Devices](https://www.cs.umd.edu/class/fall2018/cmsc818O/papers/ps-and-qs.pdf)*. This implementation takes roughly 2.5 seconds to process 10,000 of 1024 bit RSA public keys on an average home computer. 

## Usage
Assuming `moduli.hex` contains hex-encoded moduli to be factored, one of each line. Runing `cabal run . --ghc-options="-threaded -Wall" -- moduli ./moduli.hex ./save.txt` should save results to `save.txt`. 
