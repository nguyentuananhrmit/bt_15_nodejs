import express from "express";
import imageController from "../controllers/image.controller.js";
import { authMiddleware } from "../common/middlewares/auth.middleware.js";

const imageRouter = express.Router();

// Thêm image
imageRouter.post("/", authMiddleware, imageController.createImage);
imageRouter.get("/", imageController.getAllImages);
imageRouter.get("/search", imageController.searchImages);
imageRouter.delete("/:id", imageController.softDeleteImage);
imageRouter.get("/user/:userId", imageController.getImagesByUserId);
imageRouter.get("/:id", imageController.getImageById);
imageRouter.get(
    "/:id/detail",
    imageController.getImageDetailWithCreator,
);

export default imageRouter;