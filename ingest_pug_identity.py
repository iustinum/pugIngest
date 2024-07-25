import json
from neo4j import GraphDatabase

# Neo4j connection details
URI = "neo4j://localhost:7687"
USER = "neo4j"
PASSWORD = "" # set password here

def connect_to_neo4j():
    return GraphDatabase.driver(URI, auth=(USER, PASSWORD))

def clear_database(session):
    # query to delete all nodes and relationships in the database
    query = "MATCH (n) DETACH DELETE n"
    session.run(query)
    print("Database cleared.")

def create_constraints(session, node_types):
    for node_type in node_types:
        constraint = f"CREATE CONSTRAINT IF NOT EXISTS FOR (n:{node_type['name']}) REQUIRE n.id IS UNIQUE"
        session.run(constraint)

def create_node(tx, label, properties):
    query = (
        f"CREATE (n:{label} $properties)"
    )
    tx.run(query, properties=properties)

def create_relationship(tx, start_node_type, start_node_id, end_node_type, end_node_id, relationship_type):
    query = (
        f"MATCH (a:{start_node_type} {{id: $start_id}}), (b:{end_node_type} {{id: $end_id}}) "
        f"CREATE (a)-[:{relationship_type}]->(b)"
    )
    tx.run(query, start_id=start_node_id, end_id=end_node_id)

def ingest_data(driver, node_types, nodes, relationships):
    with driver.session() as session:

        clear_database(session)

        create_constraints(session, node_types)

        # Create nodes
        for node in nodes:
            session.execute_write(create_node, node['type'], node['properties'])

        # Create relationships
        for rel in relationships:
            start_node_type, start_node_id = rel['startNode'].split(':')
            end_node_type, end_node_id = rel['endNode'].split(':')
            session.execute_write(
                create_relationship,
                start_node_type,
                start_node_id,
                end_node_type,
                end_node_id,
                rel['type']
            )

def main():
    # Load JSON data
    with open('pug_nodes.json', 'r') as file:
        node_data = json.load(file)

    with open('pug_relationships.json', 'r') as file:
        relationship_data = json.load(file)

    with open('pug_identity_data.json', 'r') as file:
        instance_data = json.load(file)

    # Connect to Neo4j
    driver = connect_to_neo4j()

    # Ingest data
    ingest_data(driver, node_data['nodeTypes'], 
                instance_data['nodes'], instance_data['relationships'])

    # Close the driver
    driver.close()

    print("Data ingestion complete!")

if __name__ == "__main__":
    main()