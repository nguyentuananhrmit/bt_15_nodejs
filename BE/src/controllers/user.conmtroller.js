import userService from "../services/user.service.js";


const userController = {
  getUserById: async (req, res, next) => {
    try {
      const { id } = req.params;

      const user = await userService.getUserById(id);

      return res.status(200).json({
        statusCode: 200,
        message: "Lấy thông tin user thành công",
        data: user,
      });
    } catch (error) {
      next(error);
    }
  },
};

export default userController;