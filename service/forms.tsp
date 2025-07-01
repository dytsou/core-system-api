import "@typespec/http";
import "@typespec/openapi";

using Http;

@tag("Forms")
namespace CoreSystem.Forms {
  model FormInput {
    @doc("The title of the form.")
    title: string;

    @doc("The description of the form.")
    description: string;
  }

  model Form {
    id: uuid;
    title: string;
    description: string;
    lastEdit: uuid;
    createdAt: utcDateTime;
    updatedAt: utcDateTime;
  }

  enum QuestionTypes {
    shortText: "short_text",
    longText: "long_text",
    singleChoice: "single_choice",
    multipleChoice: "multiple_choice",
    date: "date",
  }

  model Question {
    id: uuid;
    formID: uuid;
    required: boolean;
    type: QuestionTypes;
    label: string;
    description: string;
    order: int32;
    createdAt: utcDateTime;
    updatedAt: utcDateTime;
  }

  model QuestionInput {
    required: boolean;
    type: QuestionTypes;
    label: string;
    description: string;
    order: int32;
  }
  // Create Form
  @route("/forms/create")
  @post
  op createForm(@body createFormInput: FormInput): Form;
  // Update Form
  @route("/forms/{formID}")
  @put
  op updateForm(@path formID: uuid, @body updateFormInput: FormInput): Form;

  // Delete Form
  @route("/forms/{formID}")
  @delete
  op deleteForm(@path formID: uuid): {
    @statusCode statusCode: 204;
  };

  // Get Form
  @route("/forms/{formID}")
  @get
  op getForm(@path formID: uuid): Form;

  // List Forms
  @route("/forms")
  @get
  op listForms(): Form[];

  // Create Question
  @route("/forms/{formID}/questions")
  @post
  op createQuestion(@path formID: uuid, @body q: QuestionInput): Question;

  // Update Question
  @route("/forms/{formID}/questions/{questionID}")
  @put
  op updateQuestion(
    @path formID: uuid,
    @path questionID: uuid,
    @body q: QuestionInput,
  ): Question;

  // Delete Question
  @route("/forms/{formID}/questions/{questionID}")
  @delete
  op deleteQuestion(@path formID: uuid, @path questionID: uuid): {
    @statusCode statusCode: 204;
  };

  // List Questions
  @route("/forms/{formID}/questions")
  @get
  op listQuestions(@path formID: uuid): Question[];
}
