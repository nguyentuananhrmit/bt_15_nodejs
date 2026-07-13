import { prisma } from "../common/commonPrisma/connect.prisma.js";
import AppError from "../common/helper/appError.helper.js";

const wishlistService = {
  // =========================================================
  // 1. LẤY DANH SÁCH IMAGE ĐÃ LƯU CỦA USER
  // =========================================================
  getMyWishlist: async (req) => {
    const userId = req.user.userId;

    const wishlistItems = await prisma.wishlists.findMany({
      where: {
        user_id: userId,

        // Chỉ lấy image chưa bị soft delete
        images: {
          is_active: true,
        },
      },

      // Lấy kèm dữ liệu image
      include: {
        images: true,
      },

      // Image lưu gần nhất nằm trên đầu
      orderBy: {
        created_at: "desc",
      },
    });

    // Chỉ trả về danh sách image cho FE
    const imageList = wishlistItems.map((item) => item.images);

    return imageList;
  },

  // =========================================================
  // 2. THÊM IMAGE VÀO WISHLIST
  // =========================================================
  addImageToWishlist: async (req) => {
    const { image_id } = req.body;

    // Lấy user đang đăng nhập từ access token
    const userId = req.user.userId;

    if (image_id === undefined || image_id === null) {
      throw AppError.badRequest("image_id không được để trống");
    }

    const imageId = Number(image_id);

    if (Number.isNaN(imageId)) {
      throw AppError.badRequest("image_id không hợp lệ");
    }

    // Kiểm tra image có tồn tại và chưa bị soft delete
    const imageExist = await prisma.images.findFirst({
      where: {
        id: imageId,
        is_active: true,
      },
    });

    if (!imageExist) {
      throw AppError.notFound("Không tìm thấy image");
    }

    // Kiểm tra user đã lưu image này chưa
    const wishlistExist = await prisma.wishlists.findFirst({
      where: {
        user_id: userId,
        image_id: imageId,
      },
    });

    if (wishlistExist) {
      throw AppError.badRequest("Image đã có trong wishlist");
    }

    const newWishlist = await prisma.wishlists.create({
      data: {
        user_id: userId,
        image_id: imageId,
      },
    });

    return newWishlist;
  },

  // =========================================================
  // 3. XOÁ IMAGE KHỎI WISHLIST
  // =========================================================
  removeImageFromWishlist: async (req) => {
    const { imageId } = req.params;

    // Lấy user đang đăng nhập từ access token
    const userId = req.user.userId;

    const parsedImageId = Number(imageId);

    if (Number.isNaN(parsedImageId)) {
      throw AppError.badRequest("image_id không hợp lệ");
    }

    // Tìm đúng wishlist của user và image
    const wishlistExist = await prisma.wishlists.findFirst({
      where: {
        user_id: userId,
        image_id: parsedImageId,
      },
    });

    if (!wishlistExist) {
      throw AppError.notFound("Image không có trong wishlist");
    }

    // Xoá bản ghi quan hệ wishlist
    const deletedWishlist = await prisma.wishlists.delete({
      where: {
        id: wishlistExist.id,
      },
    });

    return deletedWishlist;
  },
  checkImageSaved: async (req) => {
  // Lấy imageId từ URL
  const { imageId } = req.params;

  // Lấy user đang đăng nhập từ access token
  const userId = req.user.userId;

  const parsedImageId = Number(imageId);

  // Kiểm tra imageId có hợp lệ không
  if (Number.isNaN(parsedImageId)) {
    throw AppError.badRequest("image_id không hợp lệ");
  }

  // Kiểm tra image có tồn tại và chưa bị soft delete không
  const imageExist = await prisma.images.findFirst({
    where: {
      id: parsedImageId,
      is_active: true,
    },
  });

  if (!imageExist) {
    throw AppError.notFound("Không tìm thấy image");
  }

  // Tìm xem user đã lưu image này chưa
  const wishlistExist = await prisma.wishlists.findFirst({
    where: {
      user_id: userId,
      image_id: parsedImageId,
    },
  });

  return {
    isSaved: wishlistExist !== null,
  };
},
};

export default wishlistService;