# Alan Projects Builder

    v0.0.1-Alpha | PureBasic 5.70 LTS | Alan SDK v3.0beta6

A standalone binary automation tool for building and validating [ALAN IF] text-adventures projects, both locally and on GitHub via [Travis CI]. 

Created in [PureBasic] by [Tristano Ajmone] on July 12, 2019. MIT License.

- https://github.com/alan-if/Alan-Builder

-----

**Table of Contents**

<!-- MarkdownTOC autolink="true" bracket="round" autoanchor="false" lowercase="only_ascii" uri_encoding="true" levels="1,2,3" -->

- [Project Contents](#project-contents)
- [Introduction](#introduction)
    - [Supported Platforms](#supported-platforms)
    - [Compiling](#compiling)
- [Usage Instructions](#usage-instructions)
- [License](#license)
    - [Third Party Components](#third-party-components)

<!-- /MarkdownTOC -->

-----

# Project Contents

- [`/_dev/AlanSDK/`](./_dev/AlanSDK/) — [Alan SDK v3.0beta6] executables (for testing).
- [`/test/`](./test/) — test suite contents.
- [`ABuilder.exe`](./ABuilder.exe) — precompiled app (32-bit) for Windows.
- [`ABuilder.pb`](./ABuilder.pb) — main source file.
- [`ABuilder_mod_Errors.pbi`](./ABuilder_mod_Errors.pbi) — additional source module.
- [`LICENSE`](./LICENSE) — MIT License.
- [`RUN_TESTS.bat`](./RUN_TESTS.bat) — test suite launcher.

# Introduction

The __Alan Builder__ tool will scan your project for all Alan adventures, compile them and run them against their associated commands scripts to generate game transcripts files, and provide a detailed report (viewable on GitHub commits) of all the operations carried out and the problems encountered, including letter-casing inconsistency in files extensions.

This tool was designed with big Alan projects in mind, for validating a large collection of source adventures and commands scripts scattered across multiple folders — e.g. library projects with a test suite, or large examples collections. But it can be used with projects of any size, including single-adventure projects.

The benefits of adding the __Alan Builder__ to an Alan IF project are manifold:

- It's designed to work with [Travis CI], allowing to validate GitHub commits and pull requests via continuous integration.
- It offers end users an easy way to build and update the project locally.
- It allows collaborators to test their contributed material locally, before submitting it to the project (via Git or otherwise).
- It enforces on any Alan project good standards, consistent naming conventions and best practices.
- It ensures that all adventures are compilable and runnable with a specific version of the [Alan SDK].

## Supported Platforms

Currently, the __Alan Builder__ only works under Windows; but with very slight adjustments it could also be compiled for Linux and macOS. In the future I might create a Linux and Mac version too (although for testing and compiling the latter I would require access to a Mac computer, which I currently don't), but this won't happen until the application reaches a stable release.

## Compiling

In order to compile the __Alan Builder__ you'll need [PureBasic] 32-bit for Windows (other platforms currently unsupported). The application must be compiled as console executable, 32-bit.

Since [PureBasic] is a commercial product, I've included the precompiled binaries directly in the repository.

> __NOTE__ — If you want to compile the app as x64, just uncomment the lines of code that currently prevent it:
> 
> ```purebasic
> CompilerIf #PB_Compiler_ExecutableFormat <> #PB_Compiler_Console Or
>            #PB_Compiler_Processor <> #PB_Processor_x86
>   CompilerError "Compile as 32-bit console executable!"
> CompilerEndIf
> ```
> 
> The above checks were placed only in order to prevent accidentally compiling it as 64-bit inside the repository. Overall, sticking to 32-bit compilation makes more sense, for the benefits of 64-bit compilation are negligible in this context, and would only prevent the executable from being run on 32-bit machines. 

# Usage Instructions

The project doesn't provide any documentation right now (still in the making). For more information, refer to the __[ALAN by Examples]__ project — for which this tool was created. You'll find practical usage examples there, including [Travis CI] integration, and some explanatory notes.

# License

- [`LICENSE`](./LICENSE)

The __Alan Builder__ was created by [Tristano Ajmone] and donated to the [Alan Interactive Fiction Development team] under the MIT License.

This means that both its author and the Alan IF Team own the rights of this software, both parties being independently eligible to use it as they wish, including releasing it under different license terms, granting special use permissions to third parties, as well as being both eligible for compensation claims in case of misuses and license violations of this software.

Tristano, as an individual, represents himself for all matters regarding his license ownership.

The [Alan Interactive Fiction Development team], as an organization, is represented by [Thomas Nilefalk], main developer of [Alan] and founder of the [Alan Interactive Fiction Development team], who represents and acts on behalf of the Team.

```
MIT License

Copyright (c) 2019 Tristano Ajmone and the Alan IF Development team
https://github.com/alan-if/Alan-Builder

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Third Party Components

Please, note that the [`LICENSE`](./LICENSE) file contains additional licenses for [third party components used by the PureBasic compiler], which _must_ be included with any distribution of the __Alan Builder__ application in compiled binary format (but not necessarily so if only the source code is being distributed).

<!-----------------------------------------------------------------------------
                               REFERENCE LINKS
------------------------------------------------------------------------------>

[Travis CI]: https://travis-ci.com "Visit Travis CI website"
[ALAN by Examples]: https://github.com/alan-if/alan-by-examples "Visit the 'ALAN by Examples' project on GitHub"

<!-- ALAN -->

[ALAN]: https://www.alanif.se/ "Visit the ALAN website"
[ALAN IF]: https://www.alanif.se/ "Visit the ALAN website"
[ALAN Yahoo Group]: https://groups.yahoo.com/neo/groups/alan-if/info "Visit the Alan-IF group on Yahoo"
[ALAN Bitbucket]: https://bitbucket.org/alanif/alan/ "Visit the ALAN source repository on Bitbucket"
[Alan Interactive Fiction Development team]: https://github.com/alan-if "Visit the Alan Interactive Fiction Development team organization on GitHub"

<!-- ALAN SDK -->

[Alan SDK]: https://www.alanif.se/download-alan-v3/development-kits "Go to the Alan SDK section of the ALAN website"
[Alan SDK v3.0beta6]: https://www.alanif.se/download-v3/official-releases/development-kits/development-kits-3-0beta6

<!-- PureBasic -->

[PureBasic]: https://www.purebasic.com "Visit PureBasic website."
[third party components used by the PureBasic compiler]:https://www.purebasic.com/documentation/reference/license_application.html "Read full details on PureBasic online documentation"

<!-- people -->

[Thomas Nilefalk]: https://github.com/thoni56 "View Thomas Nilefalk's GitHub profile"
[Tristano Ajmone]: https://github.com/tajmone "View Tristano Ajmone's GitHub profile"

<!-- EOF -->