---
title: Captain
status: Idea
---

# koksmat-captain

Responsible for coordinating the team.

## Web

in .koksmat/web run

### Initialize

```
npx shadcn init
```

Tasks include

## Issuing, monitoring, renewing and revoking

- GitHub access tokens
- Database access
- Azure resources

## Process Guidance

### Decision Tree for Organization, Repository, and Package Management

This document outlines the decision-making process for determining when to create a new organization, a new repository, or add new packages to an existing repository. The process takes into account the RACI (Responsible, Accountable, Consulted, Informed) model, risk appetite, and the nature of the solution being developed.

#### Decision Flow

The decision-making process follows these key steps:

1. Evaluate RACI differences
2. Assess the need for a new organization
3. Determine if a new repository is required
4. Consider adding a new package to an existing repository
5. Evaluate the complexity and isolation requirements of the solution

#### Flow Diagram

The following Mermaid flow diagram illustrates the decision-making process:

```mermaid title="Decision Tree for Org, Repo, and Package Management" type="diagram"
graph TD
    A[Start] --> B{Different Accountable?}
    B -->|Yes| C[Create New Organization]
    B -->|No| D{New Repo Needed?}
    D -->|Yes| E[Create New Repository]
    D -->|No| F{New Package Needed?}
    F -->|Yes| G[Add New Package to Existing Repo]
    F -->|No| H[Use Existing Solution]

    C --> I{Complex Logic?}
    E --> I
    G --> I

    I -->|Yes| J[Create Microservice]
    I -->|No| K{Web Application?}

    K -->|Yes| L[Create/Update Web App]
    K -->|No| M[Create/Update Action]

    L --> N[End]
    M --> N
    J --> N
    H --> N
```

#### Detailed Decision Process

1. **Different Accountable?**

   - If there is a difference in the RACI model, specifically a different Accountable, always create a new organization.
   - Accountable individuals are the only ones who can decide on the organization level.

2. **New Repository Needed?**

   - Within the scope of an Accountable, the Responsible should decide if a new repository or an existing one should be used.
   - This decision is based on risk appetite: more packages in the same repo increase the risk of errors in one package impacting others.
   - This risk can be mitigated by using multiple branches and branch protections.

3. **New Package Needed?**

   - If a new repository is not needed, consider adding a new package to an existing repository.
   - Keep the number of packages to a minimum, as their complexity makes them costly to establish and hard to maintain.
   - Instead of creating a new package, consider using features within an existing one when possible.

4. **Complex Logic?**

   - For application-specific logic of significant complexity, isolate it in work processes (Microservices).
   - Microservices should only communicate with each other and the web front-end through messaging.

5. **Web Application?**

   - Web applications are typically the only entry points, exposing REST APIs and web pages.
   - Keep web applications to a minimum due to their complexity and maintenance costs.
   - For new functionality, prefer adding features to existing web applications rather than creating new ones.

6. **Actions**
   - Repositories can contain actions that are executed automatically, scheduled, or manually.
   - These actions can be created or updated as needed without necessarily creating new packages or repositories.

#### Best Practices

- **Minimize Complexity**: Always strive to keep the number of organizations, repositories, and packages to a minimum to reduce complexity and maintenance overhead.
- **Isolation for Risk Management**: Use separate repositories or organizations when there's a need for strict isolation due to different accountabilities or high-risk components.
- **Leverage Existing Solutions**: Before creating new components, thoroughly evaluate if existing solutions can be extended or modified to meet the new requirements.
- **Microservices for Complex Logic**: Isolate complex, application-specific logic into microservices to maintain modularity and ease of maintenance.
- **Branch Protection**: Utilize branch protection rules and multiple branches to mitigate risks when multiple packages coexist in a single repository.
- **Regular Review**: Periodically review the structure of your organizations, repositories, and packages to ensure they still align with current needs and best practices.

By following this decision tree and associated best practices, you can maintain a well-organized and efficient GitHub structure that balances the needs for isolation, risk management, and ease of maintenance.
