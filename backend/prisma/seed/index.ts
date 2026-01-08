import 'dotenv/config';
import { PrismaClient } from '@prisma/client';
import { seedTranslationPractice } from './translation-seed';

const prisma = new PrismaClient();

async function main() {
    console.log('🌱 Starting database seeding...\n');

    try {
        // Seed Translation Practice data
        await seedTranslationPractice();

        console.log('\n✅ Database seeding completed successfully!');
    } catch (error) {
        console.error('❌ Error during seeding:', error);
        throw error;
    }
}

main()
    .catch((e) => {
        console.error(e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });
