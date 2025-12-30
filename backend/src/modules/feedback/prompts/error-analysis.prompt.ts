export const ERROR_ANALYSIS_PROMPT = (text: string, level: string): string => `
Analyze the following English text for errors.
Student Level: ${level}

Text: "${text}"

Return JSON with corrections:
{
  "corrections": [
    {
      "type": "grammar" | "vocabulary" | "pronunciation",
      "original": "incorrect phrase",
      "corrected": "correct phrase",
      "explanation": "brief explanation in English",
      "explanationJa": "brief explanation in Japanese",
      "severity": "low" | "medium" | "high"
    }
  ]
}

Rules:
- Only include significant errors appropriate for the student's level
- Maximum 3 corrections per message
- For Beginner: focus on basic grammar
- For Intermediate: include vocabulary and naturalness
- For Advanced: include subtle nuances
`.trim();

export const SUGGESTION_PROMPT = (
  context: string,
  level: string,
  topic?: string,
): string => `
Based on the conversation context, generate helpful speaking suggestions.

Topic: ${topic || 'General conversation'}
Level: ${level}
Context: ${context}

Return JSON with:
{
  "template": "sentence template with [___] blanks",
  "vocabulary": [
    {"word": "word", "meaning": "Japanese meaning", "pronunciation": "IPA"}
  ],
  "alternativeResponses": ["example response 1", "example response 2"]
}

Rules:
- Template should be appropriate for the student's level
- Include 2-5 vocabulary items
- Provide 2-3 alternative responses
`.trim();

export const VOCABULARY_EXTRACTION_PROMPT = (
  texts: string[],
  level: string,
): string => `
Extract new vocabulary from the following conversation texts that would be useful for a ${level} level student.

Texts:
${texts.map((t, i) => `${i + 1}. "${t}"`).join('\n')}

Return JSON with:
{
  "vocabulary": [
    {
      "word": "word or phrase",
      "pronunciation": "IPA pronunciation",
      "meaning": "Japanese meaning",
      "partOfSpeech": "noun/verb/adjective/etc",
      "exampleSentence": "example usage"
    }
  ]
}

Rules:
- Maximum 5 vocabulary items
- Focus on useful, high-frequency words
- Appropriate for the student's level
- Avoid words that are too basic or too advanced
`.trim();
