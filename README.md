# MazeRunners

This is a little Rails app that creates a grid (currently defaulting to 10x10, but could be any size), turns the grid into a maze, and then solves the maze. The maze is generated using a random version of the depth-first search algorithm. The iterator will pick a path through the grid, removing walls between cells as it goes, and marking them as "visited." If it reaches a point where all neighboring cells are visited, it will backtrack until it finds a cell with unvisited neighbors, or until all cells have been visited. The grid gets a random start point that is on the edge, and an end point that is located on the opposite edge.

The iterator solves the maze by filling in dead ends. it fills in a dead end by blocking off cells until it reaches a junction. Once it has filled in all the dead ends, the solution(s) remain. These mazes only have one solution, but this approach would also expose multiple solutions if they existed.

## To Run Locally

```
$ git clone
```
```
$ bundle
```
```
$ rails db:create db:migrate
```
```
$ rails s
```

## To Test
Currently, the app is using Minitest, and the tests can be run with the $ rails test command.

## License
The app is available under the terms of the [MIT License](https://opensource.org/licenses/MIT).
