# envdir

A Haskell learning exercise through rewriting [`envdir`](https://cr.yp.to/daemontools/envdir.html).

## Usage

```bash
$ cat ~/Desktop/env/TEST
JOKER
$ stack exec envdir ~/Desktop/env/ env
TEST=JOKER
```
