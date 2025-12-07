# Advanced SQL Portfolio

## Overview
This repository demonstrates advanced database engineering skills using Microsoft SQL Server . It contains two distinct projects that showcase my ability to design complex relational schemas, implement server-side business logic, and solve algorithmic problems directly within the database engine.

##Project 1: Car Dealership Management System (OLTP)

A complete transactional database system designed for an automotive dealership network. It handles inventory management, sales transactions, and dealer-model relationships with strict data integrity enforcement.


## Project 2: Hierarchical Data Processing in SQL


An algorithmic project focusing on storing and querying hierarchical data structures  in a flat relational database. 

###  Approaches Implemented:
1.  **Adjacency List Model:**
    * Implements parent-child relationships using self-referencing foreign keys.
    * Uses Recursive CTEs to traverse the tree and fetch all descendants of a node.
    * Includes logic to safely move subtrees to new parents.

2.  **Path Enumeration Model:**
    * Stores the full lineage of a node as a string path
    * Demonstrates string manipulation techniques in SQL for efficient subtree querying without recursion.



##  Tech Stack
* **Database Engine:** MS SQL Server
* **Language:** T-SQL
* **Tools:** SQL Server Management Studio (SSMS), Azure Data Studio
* **Concepts:** OLTP Design, Normalization, ACID Transactions, Recursion, Stored Procedures, Indexing Strategies.



