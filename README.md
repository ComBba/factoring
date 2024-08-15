# Factoring
Mining code for the FACT0RN blockchain. For the binaries and instructions on how to run a node see [FACT0RN](https://github.com/FACT0RN/FACT0RN). To run the miner you will need Docker. 

You will need the scriptPubKey from an address in your wallet. For instructions on how to get a wallet, 
an address in your wallet and get the scriptPubKey for that address see the instructions on [FACT0RN](https://github.com/FACT0RN/FACT0RN).

These instructions are for the case where you are mining on the same machine where you have a node running:

1. From the parent folder of this repo, build the image:
```
docker build -t factorn_mining .
```

2. Now, to run a container do this:

```
docker run -ti -e SCRIPTPUBKEY="ValidScriptPubKey" -e RPC_USER="Your node's rpc username" -e RPC_PASS="Your node rpc's password" -e YAFU_THREADS=max_core_count_minus_one -e YAFU_LATHREADS=max_core_count_minus_one -e MSIEVE_BIN="/tmp/ggnfs-bin/" --network host factorn_mining  bash -c "python3.10 FACTOR.py"
```

I'd recommend to run one container. Use as many threads as you have cores, minus one so the OS has on core to do normal system stuff. If you run htop you will see how many cores you have.


Happy factoring!

Note: There are a few sophiscated software implemntations for factoring. Currently, we use YAFU by default. For advanced users, you can look into YAFU, ECM-GMP and CADO-NFS. A setup using CADO-NFS is welcomed. If you create one, please let us know.

# Contact

Website: https://fact0rn.io <br>
Whitepaper: https://fact0rn.io/FACT0RN_whitepaper.pdf <br>
Coinbase: https://blog.coinbase.com/fact0rn-blockchain-integer-factorization-as-proof-of-work-pow-bc48c6f2100b <br>
E-mail: fact0rn@pm.me <br>
Discord: https://discord.gg/tE2BNpgmtH <br>
Twitter: https://twitter.com/FACT0RN <br>
Reddit: https://www.reddit.com/r/FACT0RN/


# For Windows 10 with WSL Ubuntu 22.04
```bash
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo apt update
sudo apt install -y g++-11 gcc-11 cmake autoconf libtool vim curl git perl zlib1g-dev zlib1g yasm texinfo subversion apt-utils wget lzip
sudo apt install g++ gdb make ninja-build rsync zip
```

```bash
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 11
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 11
sudo update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 11
sudo update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 11
sudo update-alternatives --set c++ /usr/bin/g++
sudo update-alternatives --set cc /usr/bin/gcc
```

```bash
mkdir tmp
cd tmp
wget https://github.com/FACT0RN/GMP/releases/download/release_6.2.1/gmp-6.2.1.tar.lz
tar --lzip -xf gmp-6.2.1.tar.lz
mkdir ~/factoring
mv gmp-6.2.1 ~/factoring/gmp-6.2.1
cd ~/factoring/gmp-6.2.1
autoreconf -i
find . -type f -exec touch {} +
chmod +x ./mpn/m4-ccas
./configure --enable-cxx
make -j8
sudo make install
```

```bash
cd ~/factoring
git clone https://gitlab.inria.fr/zimmerma/ecm.git
cd ecm
autoreconf -i
./configure --with-gmp=/usr/local/
make -j8
sudo make install
```

```bash
cd ~/factoring
git clone https://github.com/FACT0RN/ggnfs.git
cd ggnfs/src/experimental/lasieve4_64
./build.sh
```

```bash
cd ~/factoring
cp -r /mnt/c/Github/factoring/docker/msieve-code-r1044-trunk/ ~/factoring/msieve
cd ./msieve
CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ \
    make all WIN64=1 ECM=1 NO_ZLIB=1
```

```bash
cd ~/factoring
git clone https://github.com/bbuhrow/ytools.git
cd ytools
make -j8 CC=gcc-11 CPP=g++-11 CXX=g++-11 LD=g++-11
```

```bash
cd ~/factoring
git clone https://github.com/bbuhrow/ysieve.git
cd ysieve
make -j8
```

```bash
cd ~/factoring
git clone https://github.com/wbhart/mpir.git
cd mpir
./autogen.sh
./configure
sudo make install
```

```bash
cd ~/factoring
git clone https://github.com/bbuhrow/yafu.git
cd yafu
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/home/centisgood/factoring/gmp-6.2.1/.libs
make yafu NFS=1
```

```bash
sudo apt install -y python3-minimal python3-pip
pip3 install --upgrade pip
pip3 install sympy gmpy2 numpy base58 factordb-python
```

```bash
echo 'export MSIEVE_BIN="/tmp/ggnfs-bin"' >> ~/.bashrc
echo 'export YAFU_BIN="/tmp/yafu/yafu"' >> ~/.bashrc
source ~/.bashrc
```

```bash
mkdir -p /mnt/c/Tools/factoring
cp ~/factoring/yafu/*.exe /mnt/c/Tools/factoring/
cp ~/factoring/msieve/msieve /mnt/c/Tools/factoring/msieve.exe
cp ~/factoring/ggnfs/src/experimental/lasieve4_64/gnfs-lasieve4* /mnt/c/Tools/factoring/
```

```PowerShell Script
[Environment]::SetEnvironmentVariable("Path", $Env:Path + ";C:\Tools\factoring", [EnvironmentVariableTarget]::Machine)
```