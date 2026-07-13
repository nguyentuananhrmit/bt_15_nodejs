import express from "express";
import imageRouter from "./image.router.js";
import authRouter from "./auth.router.js";
import { authMiddleware } from "../common/middlewares/auth.middleware.js";
import wishlistRouter from "./wishlist.router.js";
import commentRouter from "./comment.router.js";
import userRouter from "./user.rooter.js";


const rootRouter = express.Router();

rootRouter.use("/images", imageRouter);
rootRouter.use("/auth", authRouter);
rootRouter.use("/wishlists", wishlistRouter);
rootRouter.use("/", commentRouter);
rootRouter.use("/users", userRouter); 
export default rootRouter;