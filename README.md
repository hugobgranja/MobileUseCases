# Introduction
Implementation of common mobile use cases for educational purposes.

MUCServer contains a server created using Vapor.  
MUCApp contains an iOS app.

# Table of Contents
- [Use Cases](#use-cases)
  - [1. Storage of Secrets](#1-storage-of-secrets)
  - [2. Authentication](#2-authentication)
  - [3. Dependency Injection](#3-dependency-injection)
  - [3. Coordinator Pattern using NavigationStack](#3-coordinator-pattern-using-navigationstack)

# Use cases
## 1. Storage of secrets
Storage of secrets is exemplified in the SecureStorage module.

## 2. Authentication
Example views and infrastructure to manage authentication can be found in the MUCCore and MUCLogin modules.

## 3. Dependency Injection
The iOS app uses [BackpackDI](https://github.com/hugobgranja/BackpackDI), a simple dependency injection framework that can be easily analyzed, it only has 4 files and few lines of code.
Usage of the library can be seen on the main app target, look at MUCApp.swift and the DependencyInjection folder.

## 3. Coordinator pattern using NavigationStack
Examples on the Coordinators folder of the main app target. 
