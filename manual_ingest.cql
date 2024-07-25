// Cypher queries to manually ingest instance data

// Example: pug_identity_data.json

// Step 1: Create Constraints
CREATE CONSTRAINT IF NOT EXISTS FOR (u:PugUser) REQUIRE u.id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (a:PugApplication) REQUIRE a.id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (r:PugRole) REQUIRE r.id IS UNIQUE;
CREATE CONSTRAINT IF NOT EXISTS FOR (p:PugPermission) REQUIRE p.id IS UNIQUE;

// Step 2: Create PugUser Nodes
CREATE (:PugUser {id: 'User1', Username: 'Alice', Email: 'alice@example.com'});
CREATE (:PugUser {id: 'User2', Username: 'Bob', Email: 'bob@example.com'});

// Step 3: Create PugApplication Nodes
CREATE (:PugApplication {id: 'App1', AppName: 'Email', URL: 'https://email.example.com'});
CREATE (:PugApplication {id: 'App2', AppName: 'HR Portal', URL: 'https://hr.example.com'});

// Step 4: Create PugRole Nodes
CREATE (:PugRole {id: 'Role1', RoleName: 'AdminRole'});
CREATE (:PugRole {id: 'Role2', RoleName: 'UserRole'});

// Step 5: Create PugPermission Nodes
CREATE (:PugPermission {id: 'Permission1', PermissionName: 'Read'});
CREATE (:PugPermission {id: 'Permission2', PermissionName: 'Write'});

// Step 6: Create HAS_ROLE Relationships
MATCH (u:PugUser {id: 'User1'}), (r:PugRole {id: 'Role1'})
CREATE (u)-[:HAS_ROLE]->(r);

MATCH (u:PugUser {id: 'User2'}), (r:PugRole {id: 'Role2'})
CREATE (u)-[:HAS_ROLE]->(r);

// Step 7: Create GRANTS_PERMISSION Relationships
MATCH (r:PugRole {id: 'Role1'}), (p:PugPermission {id: 'Permission1'})
CREATE (r)-[:GRANTS_PERMISSION]->(p);

MATCH (r:PugRole {id: 'Role1'}), (p:PugPermission {id: 'Permission2'})
CREATE (r)-[:GRANTS_PERMISSION]->(p);

MATCH (r:PugRole {id: 'Role2'}), (p:PugPermission {id: 'Permission1'})
CREATE (r)-[:GRANTS_PERMISSION]->(p);

// Step 8: Create REQUIRES_PERMISSION Relationships
MATCH (a:PugApplication {id: 'App2'}), (p:PugPermission {id: 'Permission2'})
CREATE (a)-[:REQUIRES_PERMISSION]->(p);

MATCH (a:PugApplication {id: 'App1'}), (p:PugPermission {id: 'Permission1'})
CREATE (a)-[:REQUIRES_PERMISSION]->(p);

// Step 9: Create HAS_ACCESS Relationships
MATCH (u:PugUser {id: 'User1'}), (a:PugApplication {id: 'App1'})
CREATE (u)-[:HAS_ACCESS]->(a);

MATCH (u:PugUser {id: 'User1'}), (a:PugApplication {id: 'App2'})
CREATE (u)-[:HAS_ACCESS]->(a);

MATCH (u:PugUser {id: 'User2'}), (a:PugApplication {id: 'App1'})
CREATE (u)-[:HAS_ACCESS]->(a);

// Step 10: Verify Data Ingestion
// Count nodes of each type
MATCH (u:PugUser) RETURN count(u) AS UserCount;
MATCH (a:PugApplication) RETURN count(a) AS AppCount;
MATCH (r:PugRole) RETURN count(r) AS RoleCount;
MATCH (p:PugPermission) RETURN count(p) AS PermissionCount;

// Count relationships of each type
MATCH ()-[r:HAS_ROLE]->() RETURN count(r) AS HasRoleCount;
MATCH ()-[r:GRANTS_PERMISSION]->() RETURN count(r) AS GrantsPermissionCount;
MATCH ()-[r:REQUIRES_PERMISSION]->() RETURN count(r) AS RequiresPermissionCount;
MATCH ()-[r:HAS_ACCESS]->() RETURN count(r) AS HasAccessCount;