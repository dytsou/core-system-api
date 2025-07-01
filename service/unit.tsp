import "@typespec/http";

using Http;

@tag("Unit")
namespace CoreSystem.Unit {
    @title("Unit Management API")
    @description("API for managing units and organizations within the Core System.")
    
    @doc("Currently, there are 2 types of units: `unit` and `organization`.")
    enum UnitType {
        unit: 0;
        organization: 1;
    }

    @doc("Base model, containing common fields for both units and organizations.")
    model Base {
        @doc("The unit's unique identifier.")
        id: uuid;

        @doc("The name of the unit or organization")
        name: string;

        @doc("A brief description of the unit or organization")
        description: string;

        @doc("Metadata for the unit or organization, stored as key-value pairs")
        metadata: map<string, string>;

        @doc("The type of the unit, either 'unit' or 'organization'")
        type: UnitType;

        @doc("The creation timestamp of the unit or organization")
        createdAt: utcDateTime;

        @doc("The last updated timestamp of the unit or organization")
        updatedAt: utcDateTime;
    }

    model Unit {
        base: Base;
    }

    model Organization {
        base: Base;
        @doc("Unique slug for the organization, used for URL routing and identification")
        slug: string;
    }

    union GenericUnit = Unit | Organization;

    @doc("Model representing a member of a unit, linking unit and member by their unique identifiers")
    model UnitMember {
        @doc("The unique identifier of the unit")
        unitId: uuid;

        @doc("The unique identifier of the member")
        memberId: uuid;
    }

    @doc("Model representing a member of an organization, linking organization and member by their unique identifiers")
    model OrgMember {
        @doc("The unique identifier of the organization")
        orgId: uuid;

        @doc("The unique identifier of the member")
        memberId: uuid;
    }

    @doc("Model representing a parent-child relationship between units, allowing for hierarchical structures")
    model ParentChild {
        @doc("The unique identifier of the parent unit")
        parentId: uuid;
        
        @doc("The unique identifier of the child unit")
        childId: uuid;
    }

    // --- CRUD Operations for Generic Units ---
    @get
    @route("/units")
    @doc("List all units, optionally filtered by parent unit ID")
    op listSubUnits(
        @doc("The parent unit ID used to filter subunits by their parent-child relationship")
        @query parentId?: uuid,
    ): Unit[];

    @get
    @route("/units/{id}")
    @doc("Get a specific unit or organization by its unique identifier")
    op getUnitById(@path id: uuid): GenericUnit;

    @post
    @route("/units")
    @doc("Create a new unit or organization")
    op createUnit(@body base: Base, @body type: UnitType, @body slug?: string): GenericUnit;

    @put
    @route("/units/{id}")
    @doc("Update an existing unit or organization by its unique identifier")
    op updateUnit(
        @path id: uuid,
        @body base: Base,
        @body type: UnitType,
        @body slug?: string
    ): GenericUnit;

    @delete
    @route("/units/{id}")
    @doc("Delete a specific unit or organization by its unique identifier")
    op deleteUnit(@path id: uuid): {
        @statusCode statusCode: 204;
        @doc("Indicates successful deletion of the unit or organization")
    } | {
        @statusCode statusCode: 404;
        @doc("Indicates that the unit or organization was not found")
        error: string;
    };

    // --- Parent-Child CRUD ---
    @get
    @route("/units/{parentId}/children")
    @doc("List all child units under a specified parent unit")
    op listChildUnits(@path parentId: uuid): uuid[];

    @post
    @route("/units")
    @doc("Create a new parent-child relationship between units by linking them")
    op addParentChild(@body parentId: uuid, @body childId: uuid): ParentChild;

    @delete
    @route("/units")
    @doc("Remove a parent-child relationship between units by unlinking them")
    op removeParentChild(@body parentId: uuid, @body childId: uuid): {
        @statusCode statusCode: 204;
        @doc("Indicates successful deletion of the parent-child relationship")
    } | {
        @statusCode statusCode: 404;
        @doc("Indicates that the parent-child relationship was not found")
        error: string;
    };
}
