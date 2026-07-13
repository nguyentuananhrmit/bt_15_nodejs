import express from "express";
import wishlistController from "../controllers/wishlist.controller.js";
import { authMiddleware } from "../common/middlewares/auth.middleware.js";

const wishlistRouter = express.Router();

// Lấy danh sách image đã lưu của user đang đăng nhập
wishlistRouter.get(
    "/",
    authMiddleware,
    wishlistController.getMyWishlist,
);

// Thêm image vào wishlist
wishlistRouter.post(
    "/",
    authMiddleware,
    wishlistController.addImageToWishlist,
);

// Xoá image khỏi wishlist theo imageId
wishlistRouter.delete(
    "/:imageId",
    authMiddleware,
    wishlistController.removeImageFromWishlist,
);
wishlistRouter.get(
    "/check/:imageId",
    authMiddleware,
    wishlistController.checkImageSaved,
);


export default wishlistRouter;