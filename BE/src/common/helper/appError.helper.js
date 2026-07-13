class AppError extends Error {
  constructor(message, statusCode) {
    super(message);
    this.statusCode = statusCode;
  }

  static badRequest(message = "Bad Request") {
    return new AppError(message, 400);
  }

  static notFound(message = "Not Found") {
    return new AppError(message, 404);
  }

  static forbidden(message = "Forbidden") {
    return new AppError(message, 403);
  }

  static unauthorized(message = "Unauthorized") {
    return new AppError(message, 401);
  }

  static internalServer(message = "Internal Server Error") {
    return new AppError(message, 500);
  }
}

export default AppError;