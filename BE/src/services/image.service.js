import { prisma } from "../common/commonPrisma/connect.prisma.js";
import AppError from "../common/helper/appError.helper.js";

const imageService = {
   //tạo hình
   createImage: async (req) => {
      const { title, description, image_url } = req.body;

      const userId = req.user.userId;

      if (!title || title.trim() === "") {
         throw AppError.badRequest("title không được để trống");
      }

      if (!image_url || image_url.trim() === "") {
         throw AppError.badRequest("image_url không được để trống");
      }

      const newImage = await prisma.images.create({
         data: {
            user_id: userId,
            title,
            description,
            image_url,
         },
      });

      return newImage;
   },
   //lấy ds image
   getAllImages: async () => {
      const images = await prisma.images.findMany({
         where: {
            is_active: true,
         },
         orderBy: {
            id: "desc",
         },
      });

      return images;
   },
   //tìm kiếm
   searchImages: async (req) => {
      const keyword = req.query.keyword?.trim() || "";

      const images = await prisma.images.findMany({
         where: {
            is_active: true,
            title: {
               contains: keyword,
            },
         },
         orderBy: {
            id: "desc",
         },
      });

      return images;
   },

   //  soft xoá hình
   softDeleteImage: async (id) => {
      const imageId = Number(id);

      if (Number.isNaN(imageId)) {
         throw AppError.badRequest("Image id không hợp lệ");
      }

      const imageExist = await prisma.images.findUnique({
         where: {
            id: imageId,
         },
      });

      if (!imageExist) {
         throw AppError.notFound("Không tìm thấy image");
      }

      if (imageExist.is_active === false) {
         throw AppError.badRequest("Image đã bị xoá trước đó");
      }

      const deletedImage = await prisma.images.update({
         where: {
            id: imageId,
         },
         data: {
            is_active: false,
         },
      });

      return deletedImage;
   },
   // lấy danh sách image theo từng user.
   getImagesByUserId: async (userId) => {
      const id = Number(userId);

      if (Number.isNaN(id)) {
         throw AppError.badRequest("User id không hợp lệ");
      }

      const userExist = await prisma.users.findUnique({
         where: {
            id: id,
         },
      });

      if (!userExist) {
         throw AppError.notFound("Không tìm thấy user");
      }

      const images = await prisma.images.findMany({
         where: {
            user_id: id,
            is_active: true,
         },
         orderBy: {
            created_at: "desc",
         },
      });

      return images;
   },
   getImageById: async (id) => {
      const imageId = Number(id);

      if (Number.isNaN(imageId)) {
         throw AppError.badRequest("Image id không hợp lệ");
      }

      const image = await prisma.images.findUnique({
         where: {
            id: imageId,
         },
      });

      if (!image) {
         throw AppError.notFound("Không tìm thấy image");
      }

      return image;
   },
   getImageDetailWithCreator: async (id) => {
      const imageId = Number(id);

      if (Number.isNaN(imageId)) {
         throw AppError.badRequest("Image id không hợp lệ");
      }

      const image = await prisma.images.findUnique({
         where: {
            id: imageId,
         },
         select: {
            id: true,
            user_id: true,
            title: true,
            description: true,
            image_url: true,
            is_active: true,
            created_at: true,
            updated_at: true,

            users: {
               select: {
                  id: true,
                  email: true,
                  full_name: true,
                  avatar: true,
               },
            },
         },
      });

      if (!image) {
         throw AppError.notFound("Không tìm thấy image");
      }

      return image;
   },
};

export default imageService;