import json
from neo4j import GraphDatabase

# Neo4j connection details
URI = "neo4j://localhost:7687"
USER = "neo4j"
PASSWORD = "" # set password here

def connect_to_neo4j():
    return GraphDatabase.driver(URI, auth=(USER, PASSWORD))

def create_constraints(session):
    constraints = [
        "CREATE CONSTRAINT IF NOT EXISTS FOR (u:PugUser) REQUIRE u.id IS UNIQUE",
        "CREATE CONSTRAINT IF NOT EXISTS FOR (a:PugApplication) REQUIRE a.id IS UNIQUE",
        "CREATE CONSTRAINT IF NOT EXISTS FOR (r:PugRole) REQUIRE r.id IS UNIQUE",
        "CREATE CONSTRAINT IF NOT EXISTS FOR (p:PugPermission) REQUIRE p.id IS UNIQUE"
    ]
    for constraint in constraints:
        session.run(constraint)

def create_node(tx, label, properties):
    query = (
        f"CREATE (n:{label} $properties)"
    )
    tx.run(query, properties=properties)

def create_relationship(tx, start_node_label, start_node_id, end_node_label, end_node_id, relationship_type):
    query = (
        f"MATCH (a:{start_node_label} {{id: $start_id}}), (b:{end_node_label} {{id: $end_id}}) "
        f"CREATE (a)-[:{relationship_type}]->(b)"
    )
    tx.run(query, start_id=start_node_id, end_id=end_node_id)

def ingest_data(driver, data):
    with driver.session() as session:

        create_constraints(session)

        # Create nodes
        for node in data['nodes']:
            session.execute_write(create_node, node['type'], node['properties'])

        # Create relationships
        for rel in data['relationships']:
            session.execute_write(
                create_relationship,
                rel['startNode'].split(':')[0],  # Assuming format "Label:id"
                rel['startNode'].split(':')[1],
                rel['endNode'].split(':')[0],
                rel['endNode'].split(':')[1],
                rel['type']
            )

def main():
    # Load JSON data
    with open('pug_identity_data.json', 'r') as file:
        data = json.load(file)

    # Connect to Neo4j
    driver = connect_to_neo4j()

    # Ingest data
    ingest_data(driver, data)

    # Close the driver
    driver.close()

    print("Data ingestion complete!")

if __name__ == "__main__":
    main()