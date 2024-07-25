# pugIngest

This project provides a sandbox environment for ingesting and visualizing graph data using Neo4j.

## Prerequisites

- Docker
- Python 3.x

## Steps to Reproduce

1. Install the official Neo4j image:
   ```
   docker pull neo4j
   ```

2. Initialize Neo4j with Docker:
   ```
   docker run \
       --restart always \
       --publish=7474:7474 --publish=7687:7687 \
       --env NEO4J_AUTH=neo4j/your_password \
       neo4j:5.22.0
   ```
   Note: Replace `your_password` with your desired password.

3. Access the Neo4j browser at `http://localhost:7474/` and authenticate with the credentials set in step 2.

4. Install the Neo4j Python driver:
   ```
   pip install neo4j
   ```

5. In the project folder, run the ingest script:
   ```
   python ingest_pug_identity.py
   ```

6. Return to the Neo4j browser to view the ingested nodes and visualization.

## Additional Information

- For manual node creation and ingestion, follow the steps in `manual_ingest.cql`.
- `example_queries.cql` contains basic queries to get you started.
- `pug_nodes.json` and `pug_relationships.json` define the structure of node types and relationship types.

## Troubleshooting

If you encounter issues, ensure that:
- Docker is running and the Neo4j container is active.
- The Neo4j browser is accessible at `http://localhost:7474/`.
- The Python script uses the correct Neo4j credentials and connection details.