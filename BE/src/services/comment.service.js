import { prisma } from "../common/commonPrisma/connect.prisma.js";
import AppError from "../common/helper/appError.helper.js";

const commentService = {
  // POST bình luận
  createComment: async ({ userId, imageId, content }) => {
    const parsedImageId = Number(imageId);
    const parsedUserId = Number(userId);

    // Kiểm tra imageId
    if (Number.isNaN(parsedImageId)) {
      throw AppError.badRequest("Image id không hợp lệ");
    }

    // Kiểm tra userId
    if (Number.isNaN(parsedUserId)) {
      throw AppError.badRequest("User id không hợp lệ");
    }

    // Kiểm tra nội dung bình luận
    if (!content || content.trim() === "") {
      throw AppError.badRequest(
        "Nội dung bình luận không được để trống",
      );
    }

    // Kiểm tra user có tồn tại không
    const userExist = await prisma.users.findUnique({
      where: {
        id: parsedUserId,
      },
    });

    if (!userExist) {
      throw AppError.notFound("Không tìm thấy user");
    }

    // Kiểm tra image có tồn tại không
    const imageExist = await prisma.images.findUnique({
      where: {
        id: parsedImageId,
      },
    });

    if (!imageExist) {
      throw AppError.notFound("Không tìm thấy image");
    }

    // Tạo bình luận mới
    const newComment = await prisma.comments.create({
      data: {
        user_id: parsedUserId,
        image_id: parsedImageId,
        content: content.trim(),
      },
      include: {
        users: {
          select: {
            id: true,
            email: true,
            full_name: true,
          },
        },
      },
    });

    return newComment;
  },

  // GET bình luận theo imageId
  getCommentsByImageId: async (imageId) => {
    const parsedImageId = Number(imageId);

    // Kiểm tra imageId
    if (Number.isNaN(parsedImageId)) {
      throw AppError.badRequest("Image id không hợp lệ");
    }

    // Kiểm tra image có tồn tại không
    const imageExist = await prisma.images.findUnique({
      where: {
        id: parsedImageId,
      },
    });

    if (!imageExist) {
      throw AppError.notFound("Không tìm thấy image");
    }

    // Lấy danh sách bình luận
    const comments = await prisma.comments.findMany({
      where: {
        image_id: parsedImageId,
      },
      include: {
        users: {
          select: {
            id: true,
            email: true,
            full_name: true,
          },
        },
      },
      orderBy: {
        created_at: "desc",
      },
    });

    return comments;
  },
};

export default commentService;