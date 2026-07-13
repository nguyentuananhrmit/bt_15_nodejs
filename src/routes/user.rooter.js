import express from "express";

import { authMiddleware } from "../common/middlewares/auth.middleware.js";
import userController from "../controllers/user.conmtroller.js";

const userRouter = express.Router();
userRouter.get("/:id", userController.getUserById);

export default userRouter;