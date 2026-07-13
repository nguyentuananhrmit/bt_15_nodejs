import commentService from "../services/comment.service.js";

const commentController = {
  createComment: async (req, res, next) => {
    try {
      const { imageId } = req.params;
      const { content } = req.body;

      // userId lấy từ auth middleware
      const userId = req.user.userId;

      const newComment = await commentService.createComment({
        userId,
        imageId,
        content,
      });

      return res.status(201).json({
        statusCode: 201,
        message: "Bình luận thành công",
        data: newComment,
      });
    } catch (error) {
      next(error);
    }
  },

  getCommentsByImageId: async (req, res, next) => {
    try {
      const { imageId } = req.params;

      const comments =
        await commentService.getCommentsByImageId(imageId);

      return res.status(200).json({
        statusCode: 200,
        message: "Lấy danh sách bình luận thành công",
        data: comments,
      });
    } catch (error) {
      next(error);
    }
  },
};

export default commentController;