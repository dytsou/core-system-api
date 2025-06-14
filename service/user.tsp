import "@typespec/http";

using Http;

@tag("User")
namespace CoreSystem.User {
  enum Role {
    user: "user",
  }

  model User {
    @doc("The user's username, unique across the system.")
    username: string;

    @doc("The user's name, usually the first and last name.")
    name: string;

    @doc("Avatar URL of the user.")
    avatarUrl: string;

    @doc("Global role of the user.")
    roles: Role[];
  }

  @get
  @route("/user/me")
  @doc("Get the current user's information.")
  op getMe(): {
    @statusCode statusCode: 200;
    @body user: User;
  } | {
    @statusCode
    statusCode: 401;

    @body error: Unauthorized;
  };
}
