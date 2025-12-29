#!/usr/bin/env node
/**
 * validate-bd-coverage.js
 * 
 * Script to validate Basic Design coverage against SRS functional requirements.
 * 
 * Usage: node validate-bd-coverage.js <project_folder>
 * Example: node validate-bd-coverage.js ./docs/改善提案プラットフォーム
 * 
 * Exit codes:
 *   0 - All validations passed
 *   1 - Validation failed (Must < 100% or Should < 80%)
 *   2 - File not found or parse error
 */

const fs = require('fs');
const path = require('path');

// Configuration
const CONFIG = {
    srsFolder: 'システム要件定義書',
    bdFolder: '基本設計書',
    frFile: '03-functional-requirements.md',
    ucFile: '03-functional-design.md',
    mappingFile: 'requirement-mapping.md',
    // BD requires 100% coverage for ALL priority levels
    thresholds: {
        must: 100,
        should: 100,
        could: 100
    }
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
 * Extract FR list from SRS functional requirements file
 */
function extractFRsFromSRS(filePath) {
    if (!fs.existsSync(filePath)) {
        throw new Error(`SRS file not found: ${filePath}`);
    }

    const content = fs.readFileSync(filePath, 'utf-8');
    const frs = [];

    // Pattern to match FR table rows: | FR-XXX | Module | Name | Priority |
    const frPattern = /\|\s*(FR-\d{3})\s*\|\s*([^|]+)\s*\|\s*([^|]+)\s*\|\s*(Must|Should|Could)\s*\|/gi;

    let match;
    while ((match = frPattern.exec(content)) !== null) {
        frs.push({
            id: match[1].trim(),
            module: match[2].trim(),
            name: match[3].trim(),
            priority: match[4].trim()
        });
    }

    return frs;
}

/**
 * Extract UC list and their FR references from BD functional design file
 */
function extractUCsFromBD(filePath) {
    if (!fs.existsSync(filePath)) {
        throw new Error(`BD file not found: ${filePath}`);
    }

    const content = fs.readFileSync(filePath, 'utf-8');
    const ucs = [];

    // Pattern to match UC table rows: | UC-XXX | Name | Actor | FR-XXX, FR-YYY | Priority |
    const ucPattern = /\|\s*(UC-\d{3})\s*\|\s*([^|]+)\s*\|\s*([^|]+)\s*\|\s*([^|]+)\s*\|\s*(Must|Should|Could)?\s*\|/gi;

    let match;
    while ((match = ucPattern.exec(content)) !== null) {
        const frRefs = match[4].trim();
        const frIds = frRefs.match(/FR-\d{3}/g) || [];

        ucs.push({
            id: match[1].trim(),
            name: match[2].trim(),
            actor: match[3].trim(),
            frReferences: frIds,
            priority: match[5] ? match[5].trim() : null
        });
    }

    return ucs;
}

/**
 * Calculate coverage statistics
 */
function calculateCoverage(frs, ucs) {
    // Create a set of all FR IDs that are referenced by UCs
    const coveredFRs = new Set();
    ucs.forEach(uc => {
        uc.frReferences.forEach(frId => coveredFRs.add(frId));
    });

    // Categorize FRs by priority and coverage status
    const stats = {
        must: { total: 0, covered: 0, notCovered: [] },
        should: { total: 0, covered: 0, notCovered: [] },
        could: { total: 0, covered: 0, notCovered: [] }
    };

    frs.forEach(fr => {
        const priority = fr.priority.toLowerCase();
        if (stats[priority]) {
            stats[priority].total++;
            if (coveredFRs.has(fr.id)) {
                stats[priority].covered++;
            } else {
                stats[priority].notCovered.push(fr);
            }
        }
    });

    // Calculate percentages
    Object.keys(stats).forEach(priority => {
        const s = stats[priority];
        s.percentage = s.total > 0 ? Math.round((s.covered / s.total) * 100) : 100;
    });

    return {
        totalFRs: frs.length,
        totalUCs: ucs.length,
        coveredFRs: coveredFRs.size,
        stats
    };
}

/**
 * Generate mapping report
 */
function generateReport(frs, ucs, coverage, projectFolder) {
    const report = [];

    report.push('# Requirement Coverage Validation Report');
    report.push('');
    report.push(`> Generated: ${new Date().toISOString()}`);
    report.push(`> Project: ${projectFolder}`);
    report.push('');

    // Summary
    report.push('## 1. Summary');
    report.push('');
    report.push('| Metric | Value |');
    report.push('|--------|-------|');
    report.push(`| Total FRs in SRS | ${coverage.totalFRs} |`);
    report.push(`| Total UCs in BD | ${coverage.totalUCs} |`);
    report.push(`| FRs Covered | ${coverage.coveredFRs} |`);
    report.push(`| FRs Not Covered | ${coverage.totalFRs - coverage.coveredFRs} |`);
    report.push(`| **Overall Coverage** | **${Math.round((coverage.coveredFRs / coverage.totalFRs) * 100)}%** |`);
    report.push('');

    // Coverage by Priority
    report.push('## 2. Coverage by Priority');
    report.push('');
    report.push('| Priority | Total | Covered | Not Covered | Rate | Threshold | Status |');
    report.push('|----------|-------|---------|-------------|------|-----------|--------|');

    const { stats } = coverage;
    Object.keys(stats).forEach(priority => {
        const s = stats[priority];
        const threshold = CONFIG.thresholds[priority];
        const status = s.percentage >= threshold ? '✅ PASS' : '❌ FAIL';
        report.push(`| ${priority.charAt(0).toUpperCase() + priority.slice(1)} | ${s.total} | ${s.covered} | ${s.total - s.covered} | ${s.percentage}% | ≥${threshold}% | ${status} |`);
    });
    report.push('');

    // Not Covered FRs
    const allNotCovered = [
        ...stats.must.notCovered,
        ...stats.should.notCovered,
        ...stats.could.notCovered
    ];

    if (allNotCovered.length > 0) {
        report.push('## 3. FRs Not Covered');
        report.push('');
        report.push('| FR ID | FR Name | Module | Priority | Suggested Action |');
        report.push('|-------|---------|--------|----------|------------------|');

        allNotCovered.forEach(fr => {
            const action = fr.priority === 'Must' ? '❌ MUST ADD UC' :
                fr.priority === 'Should' ? '⚠️ Add UC or justify' :
                    'ℹ️ Defer to Open Issues';
            report.push(`| ${fr.id} | ${fr.name} | ${fr.module} | ${fr.priority} | ${action} |`);
        });
        report.push('');
    }

    // FR to UC Mapping
    report.push('## 4. Full FR to UC Mapping');
    report.push('');
    report.push('| FR ID | FR Name | Priority | Mapped UC(s) | Status |');
    report.push('|-------|---------|----------|--------------|--------|');

    frs.forEach(fr => {
        const mappedUCs = ucs
            .filter(uc => uc.frReferences.includes(fr.id))
            .map(uc => uc.id)
            .join(', ') || '-';
        const status = mappedUCs !== '-' ? '✅ Covered' : '⚠️ NOT COVERED';
        report.push(`| ${fr.id} | ${fr.name} | ${fr.priority} | ${mappedUCs} | ${status} |`);
    });
    report.push('');

    // Validation Result
    report.push('## 5. Validation Result');
    report.push('');

    const mustPass = stats.must.percentage >= CONFIG.thresholds.must;
    const shouldPass = stats.should.percentage >= CONFIG.thresholds.should;
    const overallPass = mustPass && shouldPass;

    if (overallPass) {
        report.push('✅ **VALIDATION PASSED**');
        report.push('');
        report.push('All coverage thresholds met:');
        report.push(`- Must: ${stats.must.percentage}% (≥${CONFIG.thresholds.must}%)`);
        report.push(`- Should: ${stats.should.percentage}% (≥${CONFIG.thresholds.should}%)`);
    } else {
        report.push('❌ **VALIDATION FAILED**');
        report.push('');
        report.push('Coverage thresholds not met:');
        if (!mustPass) {
            report.push(`- ❌ Must: ${stats.must.percentage}% (required: ${CONFIG.thresholds.must}%)`);
        }
        if (!shouldPass) {
            report.push(`- ❌ Should: ${stats.should.percentage}% (required: ${CONFIG.thresholds.should}%)`);
        }
        report.push('');
        report.push('**Action Required:** Add Use Cases for the missing FRs listed above.');
    }

    return report.join('\n');
}

/**
 * Main function
 */
function main() {
    const args = process.argv.slice(2);

    if (args.length === 0) {
        log('Usage: node validate-bd-coverage.js <project_folder>', COLORS.yellow);
        log('Example: node validate-bd-coverage.js ./docs/改善提案プラットフォーム', COLORS.yellow);
        process.exit(2);
    }

    const projectFolder = args[0];

    logHeader('BD Coverage Validation');
    log(`Project: ${projectFolder}`, COLORS.blue);

    try {
        // Construct file paths
        const srsPath = path.join(projectFolder, CONFIG.srsFolder, CONFIG.frFile);
        const bdPath = path.join(projectFolder, CONFIG.bdFolder, CONFIG.ucFile);

        log(`\nSRS File: ${srsPath}`);
        log(`BD File: ${bdPath}`);

        // Extract data
        log('\n[1/4] Extracting FRs from SRS...', COLORS.cyan);
        const frs = extractFRsFromSRS(srsPath);
        log(`   Found ${frs.length} functional requirements`, COLORS.green);

        log('[2/4] Extracting UCs from BD...', COLORS.cyan);
        const ucs = extractUCsFromBD(bdPath);
        log(`   Found ${ucs.length} use cases`, COLORS.green);

        // Calculate coverage
        log('[3/4] Calculating coverage...', COLORS.cyan);
        const coverage = calculateCoverage(frs, ucs);

        // Display summary
        logHeader('Coverage Summary');

        const { stats } = coverage;
        Object.keys(stats).forEach(priority => {
            const s = stats[priority];
            const threshold = CONFIG.thresholds[priority];
            const color = s.percentage >= threshold ? COLORS.green : COLORS.red;
            log(`${priority.toUpperCase()}: ${s.covered}/${s.total} (${s.percentage}%) - Threshold: ≥${threshold}%`, color);
        });

        // Generate and save report
        log('\n[4/4] Generating report...', COLORS.cyan);
        const report = generateReport(frs, ucs, coverage, projectFolder);

        const reportPath = path.join(projectFolder, 'validation-report.md');
        fs.writeFileSync(reportPath, report, 'utf-8');
        log(`   Report saved to: ${reportPath}`, COLORS.green);

        // Final result
        const mustPass = stats.must.percentage >= CONFIG.thresholds.must;
        const shouldPass = stats.should.percentage >= CONFIG.thresholds.should;
        const overallPass = mustPass && shouldPass;

        logHeader('Validation Result');

        if (overallPass) {
            log('✅ VALIDATION PASSED', COLORS.green);
            process.exit(0);
        } else {
            log('❌ VALIDATION FAILED', COLORS.red);

            if (!mustPass) {
                log(`\n⚠️  Must requirements: ${stats.must.percentage}% (required: ${CONFIG.thresholds.must}%)`, COLORS.red);
                log('   Missing Must FRs:', COLORS.red);
                stats.must.notCovered.forEach(fr => {
                    log(`   - ${fr.id}: ${fr.name}`, COLORS.red);
                });
            }

            if (!shouldPass) {
                log(`\n⚠️  Should requirements: ${stats.should.percentage}% (required: ${CONFIG.thresholds.should}%)`, COLORS.yellow);
                log('   Missing Should FRs:', COLORS.yellow);
                stats.should.notCovered.forEach(fr => {
                    log(`   - ${fr.id}: ${fr.name}`, COLORS.yellow);
                });
            }

            log('\nAction: Add Use Cases for the missing FRs and re-run validation.', COLORS.yellow);
            process.exit(1);
        }

    } catch (error) {
        log(`\n❌ Error: ${error.message}`, COLORS.red);
        process.exit(2);
    }
}

// Run
main();
