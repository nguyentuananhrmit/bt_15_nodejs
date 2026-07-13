import { prisma } from "../common/commonPrisma/connect.prisma.js";
import AppError from "../common/helper/appError.helper.js";

const userService = {
  getUserById: async (id) => {
    const userId = Number(id);

    if (Number.isNaN(userId)) {
      throw AppError.badRequest("User id không hợp lệ");
    }

    const user = await prisma.users.findUnique({
      where: {
        id: userId,
      },
      select: {
        id: true,
        full_name: true,
        email: true,
        is_active: true,
        created_at: true,
        updated_at: true,
      },
    });

    if (!user) {
      throw AppError.notFound("Không tìm thấy user");
    }

    return user;
  },
};

export default userService;