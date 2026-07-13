import authService from "../services/auth.service.js";
import { responseSuccess } from "../common/helper/response.helper.js";

const COOKIE_OPTIONS = {
  httpOnly: true,
  sameSite: "lax",
  secure: false,
  maxAge: 7 * 24 * 60 * 60 * 1000,
};

const authController = {
  login: async (req, res, next) => {
    try {
      const result = await authService.login(req);
      res.cookie("refreshToken",result.refreshToken,COOKIE_OPTIONS);
      const data = {
        user: result.user,
        accessToken: result.accessToken
      }

      const response = responseSuccess(
        data,
        "Đăng nhập thành công",
      );

      res.status(response.statusCode).json(response);
    } catch (error) {
      next(error);
    }
  },
  register: async (req, res, next) => {
  try {
    const newUser = await authService.register(req);

    const response = responseSuccess(
      newUser,
      "Đăng ký thành công",
      201,
    );

    res.status(response.statusCode).json(response);
  } catch (error) {
    next(error);
  }
},
};

export default authController;