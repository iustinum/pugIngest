// Example Queries

// Find all applications a user has access to
MATCH (u:PugUser {Username: 'Alice'})-[:HAS_ACCESS]->(a:PugApplication)
RETURN u.Username, collect(a.AppName) AS AccessibleApps;

// Find all permissions granted to a user
MATCH (u:PugUser {Username: 'Bob'})-[:HAS_ROLE]->(r:PugRole)-[:GRANTS_PERMISSION]->(p:PugPermission)
RETURN u.Username, collect(p.PermissionName) AS GrantedPermissions;

// Find users who have access to a specific application
MATCH (u:PugUser)-[:HAS_ACCESS]->(a:PugApplication {AppName: 'HR Portal'})
RETURN collect(u.Username) AS UsersWithAccess;

// Find applications that require a specific permission
MATCH (a:PugApplication)-[:REQUIRES_PERMISSION]->(p:PugPermission {PermissionName: 'Write'})
RETURN collect(a.AppName) AS AppsRequiringWritePermission;