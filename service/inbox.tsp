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

    model UserInboxMessages<T> {
        @doc("The userId or the orgId of the inbox owner.")
        id: uuid;

        @doc("The inbox message this user inbox message refers to.")
        message: InboxMessages<T>;  

        @doc("Indicates whether the user has read the inbox message.")
        isRead: boolean;  

        @doc("User can mark the inbox message as starred.")
        isStarred: boolean;  

        @doc("User can archive the inbox message and hide it from the inbox view.")
        isArchived: boolean; 

        @doc("The category of the message in the inbox.")
        category: Category;

        @doc("The timestamp when the user inbox message was received.")
        receivedAt: utcDateTime;
    } 
    
    model MarkdownContent {
        markdown: string;
    }
    
    @doc("InboxMessageContent maybe a MarkdownContent or a Form.")
    @discriminated
    union InboxMessageContent {
        text : MarkdownContent;
        form: Forms.Form;
    }
    
    @doc("The structure of an full inbox message.")
    model InboxMessages<InboxMessageContent> {
        @doc("The unique identifier of an inbox message.")
        id: uuid;
        
        @doc("Sender may be the org-{orgId} or unit-{unitId}.")
        postedBy: uuid;

        @doc("The title of the inbox message.")
        title: string;
        
        @doc("The subtitle of the inbox message.")
        subtitle: string;
        
        @doc("The content of the inbox message.")
        content: InboxMessageContent;
        
        @doc("(Optional) The due date of the inbox message.")
        dueDate?: utcDateTime;
        
        @doc("The post timestamp of the inbox message.")
        createdAt: utcDateTime;
        
        @doc("The last updated timestamp of the inbox message.")
        updatedAt: utcDateTime;   
    }
    
    alias UserInboxMessage = UserInboxMessages<InboxMessageContent>;

    @doc("The simple preview of an inbox message without content.")
    model simpleUserInboxMessage is UserInboxMessages<never>;

    @doc("Show the inbox messages preview with customized page and pageSize.")
    @route("/inbox/simple")
    @get
    @list
    op listSimpleInboxMessages(@query @pageIndex page?: int32 = 1, @query @pageSize perPage?: int32 = 10):{
        @statusCode statusCode: 200;
        @body @pageItems messages: simpleUserInboxMessage[];
    } | errorResponse;

    @doc("List all existing inbox messages with customized page and pageSize.")
    @route("/inbox")
    @get
    @list
    op listInboxMessages(@query @pageIndex page?: int32 = 1, @query @pageSize perPage?: int32 = 10):{
        @statusCode statusCode: 200;
        @body @pageItems messages: UserInboxMessage[];
    } | errorResponse;
    
    alias errorResponse = {
        @statusCode statusCode: 401;
        @body error: Unauthorized;
    } | {
        @statusCode statusCode: 404;
        @body error: NotFound;
    };
}

