export const responseSuccess = (
  data,
  message = "Thành công",
  statusCode = 200
) => {
  return {
    statusCode: statusCode,
    message: message,
    data: data,
  };
};