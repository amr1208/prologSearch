Prolog Pathfinding Program
This program implements uninformed search strategies in Prolog to solve pathfinding problems in a graph representing a house's layout. Key features include:

Pathfinding between locations: The program computes all possible paths between two specified locations in the house, avoiding loops. If multiple paths exist, it returns each one.

Bidirectional search: It supports searching from two different starting points to meet at a common destination. The program can combine multiple valid paths and also determine the shortest combined path.

Cost-based search: The program extends pathfinding to consider the cost (distance) between locations. It computes and ranks paths by cost, returning the least expensive ones first. It also supports meeting at a common destination from two origins with equal total costs.

This solution demonstrates knowledge of depth-first search and other uninformed search strategies, effectively applying them to real-world pathfinding scenarios.
