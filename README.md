# Piece Table

[![Travis CI](https://img.shields.io/travis/buttercrab/piece_table)](https://travis-ci.org/buttercrab/piece_table)
[![LICENSE](https://img.shields.io/github/license/buttercrab/piece_table)](https://github.com/buttercrab/piece_table/blob/master/LICENSE)
[![Version](https://img.shields.io/pub/v/piece_table)](https://pub.dev/packages/piece_table)

A piece table package for dart. 

## Speed!

1. Insert test

   insert string from random place

```
Piece Table insert test:
Template(RunTime): 7.122959723345074 us.
```

## How it is implemented?

It uses custom splay tree to implement the table.

_Benchmark:_

1. Insert test
   
   insert from empty tree for 2 second
   
2. Insert & Erase test

   insert & erase each time from tree size of 1,000,000 for 2 second 

```
Splay Tree insert test:
Template(RunTime): 3.356173762453496 us.

Splay Tree insert & erase test:
Template(RunTime): 4.436266441896058 us.
```

Above value is for each one insert / one erase.

## Feature, Bugs and Speed

If you want to request feature, found bug, or make this faster, go to github issue.

