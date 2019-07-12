# ALAN Builder Test Suite

This directory tree contains various tests adventures and command scripts for running tests that should pass and others that should fail:

# Introduction

- [`/_skip/`](./_skip) — tests that should be ignored.
- [`/fail/`](./fail) — tests that should fail:
    + [`/adv/`](./fail/adv) — errors due to Alan source adventures.
    + [`/both/`](./fail/both) — errors due to both adventures and commands scripts.
    + [`/sol/`](./fail/sol) —  errors due to commands scripts.
- [`/pass/`](./pass) — tests that should pass.
- [`_skipped.a3sol`](./_skipped.a3sol) — should be ignored.
- [`_skipped.alan`](./_skipped.alan) — should be ignored.

The various filenames and paths describe the nature of the errors that should be detected and reported by the __ALAN Builder__.

For example, the file `test\fail\both\wont-compile+missing-sol.alan` should raise two errors: the adventure won't compile, and there's a missing commands script (aka "solution file"). And so on.

<!-- EOF -->