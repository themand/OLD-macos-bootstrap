# Tarsnap

[Download](https://www.tarsnap.com/download.html#source) source code and verify it

Install openssl-devel:

```bash
brew install openssl
```

Make openssl-devel available to compilers:
```bash
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
```

Compile tarsnap:
```bash
./configure && make all
```

Install tarsnap:
```bash
sudo make install
```

... @todo