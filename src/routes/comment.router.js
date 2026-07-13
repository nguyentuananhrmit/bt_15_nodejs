import express from "express";
import commentController from "../controllers/comment.controller.js";
import { authMiddleware } from "../common/middlewares/auth.middleware.js";

const commentRouter = express.Router();

// GET không bắt buộc đăng nhập
commentRouter.get(
  "/images/:imageId/comments",
  commentController.getCommentsByImageId,
);

// POST bắt buộc đăng nhập
commentRouter.post(
  "/images/:imageId/comments",
  authMiddleware,
  commentController.createComment,
);

export default commentRouter;