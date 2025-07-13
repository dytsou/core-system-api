import "@typespec/http";
import "@typespec/openapi";

using Http;

@tag("Forms")
namespace CoreSystem.Forms {
  @doc("The request body for creating/updating a form.")
  model FormRequest {
    @doc("The title of the form.")
    title: string;

    @doc("The description of the form.")
    description: string;
  }

  @doc("The structure of a form.")
  model Form {
    @doc("The form's unique identifier.")
    id: uuid;

    @doc("The title of the form.")
    title: string;

    @doc("The description written in the form to show user info.")
    description: string;

    @doc("The user who last editted the form.")
    lastEdit: uuid;

    @doc("The creation timestamp of the form.")
    createdAt: utcDateTime;

    @doc("The last updated timestamp of the form")
    updatedAt: utcDateTime;
  }

  @doc("The current types of question")
  enum QuestionTypes {
    shortText: "short_text",
    longText: "long_text",
    singleChoice: "single_choice",
    multipleChoice: "multiple_choice",
    date: "date",
    file: "file",
    array: "array",
    grid: "grid",
  }

  @doc("The structure of a question.")
  model Question {
    @doc("The question's unique identifier.")
    id: uuid;

    @doc("The form's id that the question belongs to. ")
    formId: uuid;

    @doc("Whether the question is required to answer or not.")
    required: boolean;

    @doc("The type of the question.")
    type: QuestionTypes;

    @doc("What is the question.")
    label: string;

    @doc("More details of this question.")
    description: string;

    @doc("What is the number of this question in the form.")
    order: int32;

    @doc("The creation timestamp of the question.")
    createdAt: utcDateTime;

    @doc("The updated timestamp of the question.")
    updatedAt: utcDateTime;
  }

  @doc("The request body for creating/updating a question.")
  model QuestionRequest {
    required: boolean;
    type: QuestionTypes;
    label: string;
    description: string;
    order: int32;
  }

  @doc("Create a new form.")
  @route("/forms")
  @post
  op createForm(@body createFormRequest: FormRequest): Form;

  @doc("Update an existing form by its unique identifier.")
  @route("/forms/{id}")
  @put
  op updateForm(@path id: uuid, @body updateFormRequest: FormRequest): Form;

  @doc("Delete an existing form by its unique identifier.")
  @route("/forms/{id}")
  @delete
  op deleteForm(@path id: uuid): {
    @statusCode statusCode: 204;
  };

  @doc("Get a specific form by its unique identifier.")
  @route("/forms/{id}")
  @get
  op getFormById(@path id: uuid): Form;

  @doc("List all existing forms.")
  @route("/forms")
  @get
  op listForms(): Form[];

  @doc("Create a new question for a specific form.")
  @route("/forms/{formId}/questions")
  @post
  op createQuestion(@path formId: uuid, @body q: QuestionRequest): Question;

  @doc("Update an existing question by its unique identifier.")
  @route("/forms/{formId}/questions/{questionId}")
  @put
  op updateQuestion(
    @path formId: uuid,
    @path questionId: uuid,
    @body q: QuestionRequest,
  ): Question;

  @doc("Delete an existing question by its unique identifier.")
  @route("/forms/{formId}/questions/{questionId}")
  @delete
  op deleteQuestion(@path formId: uuid, @path questionId: uuid): {
    @statusCode statusCode: 204;
  };

  @doc("List all the questions of a specific form.")
  @route("/forms/{formId}/questions")
  @get
  op listQuestions(@path formId: uuid): Question[];
}
