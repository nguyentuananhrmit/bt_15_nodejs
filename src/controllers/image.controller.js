import imageService from "../services/image.service.js";
import { responseSuccess } from "../common/helper/response.helper.js";

const imageController = {
    createImage: async (req, res) => {
        try {
            const result = await imageService.createImage(req);

            const response = responseSuccess(
                result,
                "Thêm image thành công",
                201
            );

            res.status(201).json(response);
        } catch (error) {
            res.status(error.statusCode || 500).json({
                statusCode: error.statusCode || 500,
                message: error.message || "Lỗi server",
            });
        }
    },

    getAllImages: async (req, res, next) => {
        try {
            const images = await imageService.getAllImages();

            const response = responseSuccess(
                images,
                "Lấy danh sách image thành công",
            );

            res.status(response.statusCode).json(response);
        } catch (error) {
            next(error);
        }
    },
    searchImages: async (req, res, next) => {
        try {
            const images = await imageService.searchImages(req);

            const response = responseSuccess(
                images,
                "Tìm kiếm image thành công",
            );

            res.status(response.statusCode).json(response);
        } catch (error) {
            next(error);
        }
    },
    softDeleteImage: async (req, res, next) => {
        try {
            const { id } = req.params;

            const result = await imageService.softDeleteImage(id);

            const response = responseSuccess(
                result,
                "Xoá image thành công",
            );

            res.status(response.statusCode).json(response);
        } catch (error) {
            next(error);
        }
    },
    getImagesByUserId: async (req, res, next) => {
        try {
            const { userId } = req.params;

            const result = await imageService.getImagesByUserId(userId);

            const response = responseSuccess(
                result,
                "Lấy danh sách image theo user thành công",
            );

            res.status(response.statusCode).json(response);
        } catch (error) {
            next(error);
        }
    },
    getImageById: async (req, res, next) => {
        try {
            const { id } = req.params;

            const image = await imageService.getImageById(id);

            return res.status(200).json({
                statusCode: 200,
                message: "Lấy chi tiết image thành công",
                data: image,
            });
        } catch (error) {
            next(error);
        }
    },
    getImageDetailWithCreator: async (req, res, next) => {
        try {
            const { id } = req.params;

            const image =
                await imageService.getImageDetailWithCreator(id);

            return res.status(200).json({
                statusCode: 200,
                message: "Lấy chi tiết image kèm người tạo thành công",
                data: image,
            });
        } catch (error) {
            next(error);
        }
    },

};

export default imageController;