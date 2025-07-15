import "@typespec/http";
import "@typespec/openapi";

using Http;

@tag("Responses")
namespace CoreSystem.Responses {
  @doc("The available answer types")
  enum AnswerType {
    shortText: "short_text",
    longText: "long_text",
    singleChoice: "single_choice",
    multipleChoice: "multiple_choice",
    date: "date",
  }

  @doc("A form response submission")
  model Response {
    @doc("The response's unique identifier.")
    id: uuid;

    @doc("The form that this response belongs to.")
    formId: uuid;

    @doc("The user who submitted this response.")
    submittedBy: uuid;

    @doc("The creation timestamp of the response.")
    createdAt: utcDateTime;

    @doc("The last updated timestamp of the response.")
    updatedAt: utcDateTime;
  }

  @doc("An individual answer")
  model Answer {
    @doc("The answer's unique identifier.")
    id: uuid;

    @doc("The response this answer belongs to.")
    responseId: uuid;

    @doc("The question this answer is for.")
    questionId: uuid;

    @doc("The type of answer, determines how to parse value.")
    type: AnswerType;

    @doc("The answer value stored as string, parsed based on type.")
    value: string;

    @doc("The creation timestamp of the answer.")
    createdAt: utcDateTime;

    @doc("The last updated timestamp of the answer.")
    updatedAt: utcDateTime;
  }

  @doc("Request model for submitting an individual answer")
  model AnswerRequest {
    @doc("The question being answered.")
    questionId: uuid;

    @doc("The type of answer.")
    answerType: AnswerType;

    @doc("The answer value (format depends on answerType).")
    answerValue: string;
  }

  @doc("Request model for submitting a complete form response")
  model SubmitFormResponseRequest {
    @doc("All answers for this form submission.")
    answers: AnswerRequest[];
  }

  @doc("Complete response with all related data")
  model FormResponse {
    @doc("The response metadata.")
    response: Response;

    @doc("All answers for this response.")
    answers: Answer[];
  }

  // API Endpoints

  @doc("List all responses for a specific form.")
  @route("/forms/{formId}/responses")
  @get
  op listFormResponses(@path formId: uuid): {
    @statusCode statusCode: 200;
    @body responses: Response[];
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  };

  @doc("Get a specific response by ID.")
  @route("/forms/{formId}/responses/{responseId}")
  @get
  op getFormResponse(@path formId: uuid, @path responseId: uuid): {
    @statusCode statusCode: 200;
    @body response: FormResponse;
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  };

  @doc("Delete a response and all its associated data.")
  @route("/forms/{formId}/responses/{responseId}")
  @delete
  op deleteFormResponse(@path formId: uuid, @path responseId: uuid): {
    @statusCode statusCode: 204;
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  };

  @doc("Submit a new response to a form.")
  @route("/forms/{formId}/responses")
  @post
  op submitFormResponse(
    @path formId: uuid,
    @body request: SubmitFormResponseRequest,
  ): {
    @statusCode statusCode: 201;
    @body response: Response;
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  } | {
    @statusCode statusCode: 400;
    @body error: ProblemDetail;
  };

  @doc("Get all answers for a specific question across all form responses.")
  @route("/forms/{formId}/questions/{questionId}")
  @get
  op getQuestionAnswers(@path formId: uuid, @path questionId: uuid): {
    @statusCode statusCode: 200;
    @body data: {
      answers: Answer[];
    };
  } | {
    @statusCode statusCode: 404;
    @body error: NotFound;
  };
}
