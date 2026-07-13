import AppError from "../helper/appError.helper.js";
import { verifyAccessToken } from "../helper/jwt.helper.js";

export const authMiddleware = (req, res, next) => {
    try {
        const authHeader = req.headers.authorization;


        if (!authHeader || !authHeader.startsWith("Bearer ")) {
            throw AppError.unauthorized("Vui lòng đăng nhập");
        }

        const accessToken = authHeader.split(" ")[1];

        if (!accessToken) {
            throw AppError.unauthorized("Access token không hợp lệ");
        }

        const decoded = verifyAccessToken(accessToken);

        req.user = decoded;

        next();


    } catch (error) {
        next(
            AppError.unauthorized(
                "Access token không hợp lệ hoặc đã hết hạn",
            ),
        );
    }
};
