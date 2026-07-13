import "dotenv/config";
import { PrismaMariaDb } from "@prisma/adapter-mariadb";
import { PrismaClient } from "./generated/prisma/client.ts";
import { DATABASE_URL } from "../constant/app.constant.js";

const url = new URL(DATABASE_URL)
const adapter = new PrismaMariaDb({
    host: url.hostname,
    port: Number(url.port),
    user: url.username,
    password: url.password,
    database:url.pathname.substring(1),
    connectionLimit: 5,
});
const prisma = new PrismaClient({ adapter });
// Test kết nối 
async function testPrisma() {
    try {
        await prisma.$connect();

        if (prisma) {
            console.log("Kết nối Prisma thành công");
        } else {
            console.log("Kết nối Prisma thất bại");
        }
    } catch (error) {
        console.log("Kết nối Prisma thất bại");
        console.log(error.message);
    }
}

testPrisma();


export { prisma };