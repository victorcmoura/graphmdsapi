# GraphMDS-API

This application was created to allow the use of Dijkstra's shortest path algorithm using real data from the context where I, an University of Brasília student, am inserted.

MDS (Software Development Methods) and GPP (Portfolio and Software Project Management, now named as EPS, or Engenharia de Produto de Software) are UnB's Software Engineering subjects that, together, are responsible for providing real software project experience to the students.

This API fetches, via GitHub API, all the members that belong to [the subjects' official GitHub organization](https://github.com/fga-eps-mds) and processes this information as a graph where the nodes are the contributors and the edges represent a partnership in any repository inside the organization.

To run the API:

- `bundle install`
- `rails db:create db:migrate`
- `rails s`

To feed the API database, you have to send HTTP requests in which the header must contain a valid GitHub API token as it follows:

`Authorization: "your token goes here"`

The correct request order to fill the database is:

- `GET /get_repositories_from_github`

- `GET /get_users_from_github`

- `GET /make_associations_between_users`

Keep in mind that, due to the data volume and processing, the request may take some time (or even timeout).

To get the graph nodes:

- `GET /users`

To get the edges:

- `GET /association_with_users`

To get the shortest path between two users:

- `POST /dijkstra`

```ruby
# For shortest path between users with ids 1 and 2:

body: {"user_one_id": "1", "user_two_id": "2"}
```
The result will be given as a list of edges.

With a filled database, you can visually check the resultant graph and check the shortest path with a javascript application made by [@lucasssm](https://github.com/lucasssm):

[https://github.com/lucasssm/graphmds](https://github.com/lucasssm/graphmds)
