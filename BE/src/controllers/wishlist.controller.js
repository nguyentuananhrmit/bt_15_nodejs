import wishlistService from "../services/wishlist.service.js";
import { responseSuccess } from "../common/helper/response.helper.js";

const wishlistController = {
  // =========================================================
  // 1. LẤY DANH SÁCH IMAGE ĐÃ LƯU
  // =========================================================
  getMyWishlist: async (req, res, next) => {
    try {
      const result = await wishlistService.getMyWishlist(req);

      const response = responseSuccess(
        result,
        "Lấy danh sách wishlist thành công",
      );

      res.status(response.statusCode).json(response);
    } catch (error) {
      next(error);
    }
  },

  // =========================================================
  // 2. THÊM IMAGE VÀO WISHLIST
  // =========================================================
  addImageToWishlist: async (req, res, next) => {
    try {
      const result = await wishlistService.addImageToWishlist(req);

      const response = responseSuccess(
        result,
        "Thêm image vào wishlist thành công",
      );

      res.status(201).json(response);
    } catch (error) {
      next(error);
    }
  },

  // =========================================================
  // 3. XOÁ IMAGE KHỎI WISHLIST
  // =========================================================
  removeImageFromWishlist: async (req, res, next) => {
    try {
      const result =
          await wishlistService.removeImageFromWishlist(req);

      const response = responseSuccess(
        result,
        "Xoá image khỏi wishlist thành công",
      );

      res.status(response.statusCode).json(response);
    } catch (error) {
      next(error);
    }
  },
  checkImageSaved: async (req, res, next) => {
  try {
    const result = await wishlistService.checkImageSaved(req);

    const response = responseSuccess(
      result,
      "Kiểm tra trạng thái lưu image thành công",
    );

    res.status(response.statusCode).json(response);
  } catch (error) {
    next(error);
  }
},
};

export default wishlistController;