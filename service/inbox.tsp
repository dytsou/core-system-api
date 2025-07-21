import "@typespec/http";
import "@typespec/openapi";

using Http;

@tag("Inbox")
namespace CoreSystem.Inbox {
    
    @doc("The different sections of the inbox.")
    enum Category {
        announcement,
        needYourHelp,
        archive
    }

    @doc("The structure of a user inbox message with customized flag.")
    model UserInboxMessage {
        @doc("The userId or the orgId of the inbox owner.")
        id: uuid;

        @doc("The inbox message this user inbox message refers to.")
        message: InboxMessage;  

        @doc("Indicates whether the user has read the inbox message.")
        isRead: boolean;  

        @doc("User can mark the inbox message as starred.")
        isStarred: boolean;  

        @doc("User can archive the inbox message and hide it from the inbox view.")
        isArchived: boolean; 

        @doc("The category of the message in the inbox.")
        category: Category;
    } 
    
    @doc("ContentId may refers to a MarkdownContent or a Form.")
    @discriminated
    union contentId {
        textId : uuid;
        formId: uuid;
    }
    
    @doc("The structure of a full inbox message.")
    model InboxMessage {
        @doc("The unique identifier of an inbox message.")
        id: uuid;
        
        @doc("Sender may be the org-{orgId} or unit-{unitId}.")
        postedBy: uuid;

        @doc("The title of the inbox message.")
        title: string;
        
        @doc("The subtitle of the inbox message.")
        subtitle: string;

        @doc("The contentId will reference the actual content from MarkdownText API or Forms API.")
        contentId: contentId;
        
        @doc("(Optional) The due date of the inbox message.")
        dueDate?: utcDateTime;
        
        @doc("The post timestamp of the inbox message.")
        createdAt: utcDateTime;
        
        @doc("The last updated timestamp of the inbox message.")
        updatedAt: utcDateTime;   
    }

    @doc("Show the preview of all the inbox messages with pagination.")
    @route("/inbox")
    @get
    @list
    op listInboxMessages(@query @pageIndex page?: int32 = 1, @query @pageSize perPage?: int32 = 10):{
        @statusCode statusCode: 200;
        @body body: {
            @pageItems messages: UserInboxMessage[];
            page: int32;
            perPage: int32;
        }
    } | errorResponse;

    @doc("Show the full content of the inbox message.")
    @route("/inbox/{id}")
    @get
    op listInboxMessage(@path id: uuid):{
        @statusCode statusCode: 200;
        @body message: UserInboxMessage;
    } | errorResponse;
    
    alias errorResponse = {
        @statusCode statusCode: 401;
        @body error: Unauthorized;
    } | {
        @statusCode statusCode: 404;
        @body error: NotFound;
    };
}

