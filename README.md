# Piece Table

[![Travis CI](https://img.shields.io/travis/com/buttercrab/dart-piece-table)](https://travis-ci.com/buttercrab/dart-piece-table)
[![LICENSE](https://img.shields.io/github/license/buttercrab/dart-piece-table)](https://github.com/buttercrab/dart-piece-table/blob/master/LICENSE)
[![Version](https://img.shields.io/pub/v/piece_table)](https://pub.dev/packages/piece_table)

A piece table package for dart. 

## Speed!

1. Insert test

   insert string from random place

```
Piece Table Write Benchmark(RunTime): 6.610980176975939 us.
```

## How it is implemented?

It uses custom splay tree to implement the table.

_Benchmark:_

1. Insert test
   
   insert from empty tree for 2 second
   
2. Insert & Erase test

   insert & erase each time from tree size of 1,000,000 for 2 second 

```
Splay Tree Insert Benchmark(RunTime): 3.387535569105691 us.
Splay Tree Insert & Erase Benchmark(RunTime): 4.377287132526745 us.
```

Above value is for each one insert / one erase.

## Feature, Bugs and Speed

If you want to request feature, found bug, or make this faster, go to github issue.

