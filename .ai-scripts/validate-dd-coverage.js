#!/usr/bin/env node
/**
 * validate-dd-coverage.js
 * 
 * Script to validate Detailed Design (DD) coverage against Basic Design (BD).
 * DD must cover 100% of elements defined in BD.
 * 
 * Usage: node validate-dd-coverage.js <project_folder>
 * Example: node validate-dd-coverage.js ./docs/改善提案プラットフォーム
 * 
 * Exit codes:
 *   0 - All validations passed
 *   1 - Validation failed (coverage < 100%)
 *   2 - File not found or parse error
 */

const fs = require('fs');
const path = require('path');

// Configuration
const CONFIG = {
    bdFolder: '基本設計書',
    ddFolder: '詳細設計書',
    files: {
        bdFunctional: '03-functional-design.md',
        bdScreen: '04-screen-design.md',
        bdData: '05-data-design.md',
        bdApi: '06-api-design.md',
        bdBatch: '07-batch-design.md',
        ddModule: '04-module-design.md',
        ddComponent: '05-component-design.md',
        ddDatabase: '06-database-design.md',
        ddApi: '07-api-design.md',
        ddUi: '08-ui-specifications.md'
    },
    // DD requires 100% coverage of BD elements
    threshold: 100
};

// Colors for console output
const COLORS = {
    reset: '\x1b[0m',
    red: '\x1b[31m',
    green: '\x1b[32m',
    yellow: '\x1b[33m',
    blue: '\x1b[34m',
    cyan: '\x1b[36m'
};

function log(message, color = COLORS.reset) {
    console.log(`${color}${message}${COLORS.reset}`);
}

function logHeader(message) {
    console.log('\n' + '='.repeat(60));
    log(message, COLORS.cyan);
    console.log('='.repeat(60));
}

/**
 * Extract Use Cases from BD functional design
 */
function extractUCsFromBD(filePath) {
    if (!fs.existsSync(filePath)) {
        return { items: [], error: `File not found: ${filePath}` };
    }

    const content = fs.readFileSync(filePath, 'utf-8');
    const items = [];

    // Pattern: | UC-XXX | Name | Actor | FR-XXX | Priority |
    const pattern = /\|\s*(UC-\d{3})\s*\|\s*([^|]+)\s*\|/gi;

    let match;
    while ((match = pattern.exec(content)) !== null) {
        items.push({
            id: match[1].trim(),
            name: match[2].trim(),
            type: 'UseCase'
        });
    }

    return { items, error: null };
}

/**
 * Extract Screens from BD screen design
 */
function extractScreensFromBD(filePath) {
    if (!fs.existsSync(filePath)) {
        return { items: [], error: `File not found: ${filePath}` };
    }

    const content = fs.readFileSync(filePath, 'utf-8');
    const items = [];

    // Pattern: | SCR-XXX | Name | Type | ... |
    const pattern = /\|\s*(SCR-\d{3})\s*\|\s*([^|]+)\s*\|/gi;

    let match;
    while ((match = pattern.exec(content)) !== null) {
        items.push({
            id: match[1].trim(),
            name: match[2].trim(),
            type: 'Screen'
        });
    }

    return { items, error: null };
}

/**
 * Extract Tables from BD data design
 */
function extractTablesFromBD(filePath) {
    if (!fs.existsSync(filePath)) {
        return { items: [], error: `File not found: ${filePath}` };
    }

    const content = fs.readFileSync(filePath, 'utf-8');
    const items = [];

    // Pattern for table definitions: ### X.X.X テーブル名 (table_name) or | TBL-XXX |
    const pattern1 = /###\s*[\d.]+\s*(.+?)\s*\(([a-z_]+)\)/gi;
    const pattern2 = /\|\s*(TBL-\d{3})\s*\|\s*([^|]+)\s*\|/gi;
    const pattern3 = /CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?([a-z_]+)/gi;

    let match;
    while ((match = pattern1.exec(content)) !== null) {
        items.push({
            id: match[2].trim(),
            name: match[1].trim(),
            type: 'Table'
        });
    }

    while ((match = pattern2.exec(content)) !== null) {
        if (!items.find(i => i.id === match[1].trim())) {
            items.push({
                id: match[1].trim(),
                name: match[2].trim(),
                type: 'Table'
            });
        }
    }

    return { items, error: null };
}

/**
 * Extract APIs from BD API design
 */
function extractAPIsFromBD(filePath) {
    if (!fs.existsSync(filePath)) {
        return { items: [], error: `File not found: ${filePath}` };
    }

    const content = fs.readFileSync(filePath, 'utf-8');
    const items = [];

    // Pattern: | API-XXX | Name | Method | Path |
    const pattern = /\|\s*(API-\d{3})\s*\|\s*([^|]+)\s*\|/gi;

    let match;
    while ((match = pattern.exec(content)) !== null) {
        items.push({
            id: match[1].trim(),
            name: match[2].trim(),
            type: 'API'
        });
    }

    // Also check for Action names in Struts format
    const actionPattern = /\|\s*([A-Z][a-zA-Z]+Action)\s*\|\s*([^|]+)\s*\|/gi;
    while ((match = actionPattern.exec(content)) !== null) {
        if (!items.find(i => i.id === match[1].trim())) {
            items.push({
                id: match[1].trim(),
                name: match[2].trim(),
                type: 'Action'
            });
        }
    }

    return { items, error: null };
}

/**
 * Extract Batch jobs from BD batch design
 */
function extractBatchesFromBD(filePath) {
    if (!fs.existsSync(filePath)) {
        return { items: [], error: `File not found: ${filePath}` };
    }

    const content = fs.readFileSync(filePath, 'utf-8');
    const items = [];

    // Pattern: | BAT-XXX | Name | Schedule | ... |
    const pattern = /\|\s*(BAT-\d{3})\s*\|\s*([^|]+)\s*\|/gi;

    let match;
    while ((match = pattern.exec(content)) !== null) {
        items.push({
            id: match[1].trim(),
            name: match[2].trim(),
            type: 'Batch'
        });
    }

    return { items, error: null };
}

/**
 * Check if DD contains detailed design for BD elements
 */
function checkDDCoverage(ddFolderPath, bdItems, itemType) {
    const covered = [];
    const notCovered = [];

    // Read all DD files
    let ddContent = '';
    if (fs.existsSync(ddFolderPath)) {
        const files = fs.readdirSync(ddFolderPath);
        files.forEach(file => {
            if (file.endsWith('.md')) {
                const filePath = path.join(ddFolderPath, file);
                ddContent += fs.readFileSync(filePath, 'utf-8') + '\n';
            }
        });
    }

    bdItems.forEach(item => {
        // Check if item ID or name appears in DD
        const idRegex = new RegExp(item.id.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'i');
        const nameRegex = new RegExp(item.name.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'i');

        if (idRegex.test(ddContent) || nameRegex.test(ddContent)) {
            covered.push(item);
        } else {
            notCovered.push(item);
        }
    });

    return { covered, notCovered };
}

/**
 * Generate mapping report
 */
function generateReport(results, projectFolder) {
    const report = [];

    report.push('# DD Coverage Validation Report');
    report.push('');
    report.push(`> Generated: ${new Date().toISOString()}`);
    report.push(`> Project: ${projectFolder}`);
    report.push('');

    // Summary
    report.push('## 1. Summary');
    report.push('');
    report.push('| Category | In BD | Covered in DD | Not Covered | Rate | Status |');
    report.push('|----------|-------|---------------|-------------|------|--------|');

    let totalBD = 0;
    let totalCovered = 0;
    let allPassed = true;

    Object.keys(results).forEach(category => {
        const r = results[category];
        const total = r.bdItems.length;
        const covered = r.covered.length;
        const rate = total > 0 ? Math.round((covered / total) * 100) : 100;
        const status = rate >= CONFIG.threshold ? '✅ PASS' : '❌ FAIL';

        if (rate < CONFIG.threshold) allPassed = false;

        totalBD += total;
        totalCovered += covered;

        report.push(`| ${category} | ${total} | ${covered} | ${total - covered} | ${rate}% | ${status} |`);
    });

    const overallRate = totalBD > 0 ? Math.round((totalCovered / totalBD) * 100) : 100;
    report.push(`| **Total** | **${totalBD}** | **${totalCovered}** | **${totalBD - totalCovered}** | **${overallRate}%** | **${allPassed ? '✅' : '❌'}** |`);
    report.push('');

    // Not covered items
    const allNotCovered = [];
    Object.keys(results).forEach(category => {
        results[category].notCovered.forEach(item => {
            allNotCovered.push({ ...item, category });
        });
    });

    if (allNotCovered.length > 0) {
        report.push('## 2. Items Not Covered in DD');
        report.push('');
        report.push('| Category | ID | Name | Action Required |');
        report.push('|----------|-----|------|-----------------|');

        allNotCovered.forEach(item => {
            report.push(`| ${item.category} | ${item.id} | ${item.name} | ❌ Add detailed design |`);
        });
        report.push('');
    }

    // Detailed mapping per category
    report.push('## 3. Detailed Coverage by Category');
    report.push('');

    Object.keys(results).forEach(category => {
        const r = results[category];
        report.push(`### 3.${Object.keys(results).indexOf(category) + 1} ${category}`);
        report.push('');

        if (r.bdItems.length === 0) {
            report.push('No items found in BD.');
            report.push('');
            return;
        }

        report.push('| ID | Name | Status |');
        report.push('|----|------|--------|');

        r.bdItems.forEach(item => {
            const status = r.covered.find(c => c.id === item.id) ? '✅ Covered' : '❌ NOT COVERED';
            report.push(`| ${item.id} | ${item.name} | ${status} |`);
        });
        report.push('');
    });

    // Validation result
    report.push('## 4. Validation Result');
    report.push('');

    if (allPassed) {
        report.push('✅ **VALIDATION PASSED**');
        report.push('');
        report.push('All BD elements are covered in DD.');
    } else {
        report.push('❌ **VALIDATION FAILED**');
        report.push('');
        report.push('Some BD elements are not covered in DD. Please add detailed design for the missing items.');
        report.push('');
        report.push('**Action Required:**');
        report.push('1. Review the "Items Not Covered in DD" section above');
        report.push('2. Add detailed design specifications for each missing item');
        report.push('3. Re-run validation');
    }

    return { report: report.join('\n'), allPassed, overallRate };
}

/**
 * Main function
 */
function main() {
    const args = process.argv.slice(2);

    if (args.length === 0) {
        log('Usage: node validate-dd-coverage.js <project_folder>', COLORS.yellow);
        log('Example: node validate-dd-coverage.js ./docs/改善提案プラットフォーム', COLORS.yellow);
        process.exit(2);
    }

    const projectFolder = args[0];

    logHeader('DD Coverage Validation');
    log(`Project: ${projectFolder}`, COLORS.blue);

    try {
        const bdPath = path.join(projectFolder, CONFIG.bdFolder);
        const ddPath = path.join(projectFolder, CONFIG.ddFolder);

        log(`\nBD Folder: ${bdPath}`);
        log(`DD Folder: ${ddPath}`);

        // Check if DD folder exists
        if (!fs.existsSync(ddPath)) {
            log(`\n⚠️  DD folder not found: ${ddPath}`, COLORS.yellow);
            log('DD has not been created yet. This validation is for post-DD-generation.', COLORS.yellow);
            process.exit(2);
        }

        const results = {};

        // Extract and check Use Cases
        log('\n[1/5] Checking Use Cases...', COLORS.cyan);
        const ucs = extractUCsFromBD(path.join(bdPath, CONFIG.files.bdFunctional));
        if (ucs.error) {
            log(`   ⚠️  ${ucs.error}`, COLORS.yellow);
        } else {
            const ucCoverage = checkDDCoverage(ddPath, ucs.items, 'UseCase');
            results['Use Cases'] = { bdItems: ucs.items, ...ucCoverage };
            log(`   Found ${ucs.items.length} UCs in BD, ${ucCoverage.covered.length} covered in DD`, COLORS.green);
        }

        // Extract and check Screens
        log('[2/5] Checking Screens...', COLORS.cyan);
        const screens = extractScreensFromBD(path.join(bdPath, CONFIG.files.bdScreen));
        if (screens.error) {
            log(`   ⚠️  ${screens.error}`, COLORS.yellow);
        } else {
            const screenCoverage = checkDDCoverage(ddPath, screens.items, 'Screen');
            results['Screens'] = { bdItems: screens.items, ...screenCoverage };
            log(`   Found ${screens.items.length} Screens in BD, ${screenCoverage.covered.length} covered in DD`, COLORS.green);
        }

        // Extract and check Tables
        log('[3/5] Checking Tables...', COLORS.cyan);
        const tables = extractTablesFromBD(path.join(bdPath, CONFIG.files.bdData));
        if (tables.error) {
            log(`   ⚠️  ${tables.error}`, COLORS.yellow);
        } else {
            const tableCoverage = checkDDCoverage(ddPath, tables.items, 'Table');
            results['Tables'] = { bdItems: tables.items, ...tableCoverage };
            log(`   Found ${tables.items.length} Tables in BD, ${tableCoverage.covered.length} covered in DD`, COLORS.green);
        }

        // Extract and check APIs
        log('[4/5] Checking APIs...', COLORS.cyan);
        const apis = extractAPIsFromBD(path.join(bdPath, CONFIG.files.bdApi));
        if (apis.error) {
            log(`   ⚠️  ${apis.error}`, COLORS.yellow);
        } else {
            const apiCoverage = checkDDCoverage(ddPath, apis.items, 'API');
            results['APIs'] = { bdItems: apis.items, ...apiCoverage };
            log(`   Found ${apis.items.length} APIs in BD, ${apiCoverage.covered.length} covered in DD`, COLORS.green);
        }

        // Extract and check Batches
        log('[5/5] Checking Batches...', COLORS.cyan);
        const batches = extractBatchesFromBD(path.join(bdPath, CONFIG.files.bdBatch));
        if (batches.error) {
            log(`   ⚠️  ${batches.error}`, COLORS.yellow);
        } else {
            const batchCoverage = checkDDCoverage(ddPath, batches.items, 'Batch');
            results['Batches'] = { bdItems: batches.items, ...batchCoverage };
            log(`   Found ${batches.items.length} Batches in BD, ${batchCoverage.covered.length} covered in DD`, COLORS.green);
        }

        // Generate report
        log('\nGenerating report...', COLORS.cyan);
        const { report, allPassed, overallRate } = generateReport(results, projectFolder);

        const reportPath = path.join(projectFolder, 'dd-validation-report.md');
        fs.writeFileSync(reportPath, report, 'utf-8');
        log(`Report saved to: ${reportPath}`, COLORS.green);

        // Final result
        logHeader('Validation Result');

        Object.keys(results).forEach(category => {
            const r = results[category];
            const rate = r.bdItems.length > 0 ? Math.round((r.covered.length / r.bdItems.length) * 100) : 100;
            const color = rate >= CONFIG.threshold ? COLORS.green : COLORS.red;
            log(`${category}: ${r.covered.length}/${r.bdItems.length} (${rate}%)`, color);
        });

        console.log('');
        log(`Overall Coverage: ${overallRate}%`, overallRate >= CONFIG.threshold ? COLORS.green : COLORS.red);

        if (allPassed) {
            log('\n✅ VALIDATION PASSED', COLORS.green);
            process.exit(0);
        } else {
            log('\n❌ VALIDATION FAILED', COLORS.red);
            log('\nAction: Add detailed design for the missing BD elements and re-run validation.', COLORS.yellow);
            process.exit(1);
        }

    } catch (error) {
        log(`\n❌ Error: ${error.message}`, COLORS.red);
        process.exit(2);
    }
}

// Run
main();
