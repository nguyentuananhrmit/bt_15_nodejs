import bcrypt from "bcryptjs";

import { prisma } from "../common/commonPrisma/connect.prisma.js";
import AppError from "../common/helper/appError.helper.js";
import {
  signAccessToken,
  signRefreshToken,
} from "../common/helper/jwt.helper.js";

const authService = {
  login: async (req) => {
    const { email, password } = req.body;

    if (!email || email.trim() === "") {
      throw AppError.badRequest("Email không được để trống");
    }

    if (!password || password.trim() === "") {
      throw AppError.badRequest("Password không được để trống");
    }

    const userExist = await prisma.users.findUnique({
      where: {
        email: email.trim(),
      },
    });

    if (!userExist) {
      throw AppError.badRequest("Email hoặc mật khẩu không đúng");
    }

    if (!userExist.is_active) {
      throw AppError.badRequest("Tài khoản đã bị khóa");
    }

    const isPasswordCorrect = await bcrypt.compare(
      password,
      userExist.password,
    );

    if (!isPasswordCorrect) {
      throw AppError.badRequest("Email hoặc mật khẩu không đúng");
    }

    const payload = {
      userId: userExist.id,
      email: userExist.email,
    };
    //tạo access token
    const accessToken = signAccessToken(payload);
    //tạo refress token
    const refreshToken = signRefreshToken(payload);

    return {
      user: {
        id: userExist.id,
        full_name: userExist.full_name,
        email: userExist.email,
      },
      accessToken,
      refreshToken,
    };
  },
  register: async (req) => {
    const { full_name, email, password } = req.body;

    if (!full_name || full_name.trim() === "") {
      throw AppError.badRequest("Họ tên không được để trống");
    }

    if (!email || email.trim() === "") {
      throw AppError.badRequest("Email không được để trống");
    }

    if (!password || password.trim() === "") {
      throw AppError.badRequest("Password không được để trống");
    }

    if (password.length < 6) {
      throw AppError.badRequest("Password phải có ít nhất 6 ký tự");
    }

    const userExist = await prisma.users.findUnique({
      where: {
        email: email.trim(),
      },
    });

    if (userExist) {
      throw AppError.badRequest("Email đã tồn tại");
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = await prisma.users.create({
      data: {
        full_name: full_name.trim(),
        email: email.trim(),
        password: hashedPassword,
        is_active: true,
      },
    });

    return {
      id: newUser.id,
      full_name: newUser.full_name,
      email: newUser.email,
      is_active: newUser.is_active,
    };
  },
};

export default authService;