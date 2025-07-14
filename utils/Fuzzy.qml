pragma Singleton

import "root:/";
import Quickshell;
import QtQuick;

Singleton {
  function levenshteinDistance(a: string, b: string): int {
    if (a.length === 0) return b.length;
    if (b.length === 0) return a.length;

    let matrix = [];

    // Initialise first row and column
    for (let i=0; i <= b.length; i++) {
      matrix[i] = [i];
    }
    for (let i=0; i <= a.length; i++) {
      matrix[0][i] = i;
    }

    for (let i=1; i <= b.length; i++) {
      for (let j=1; j <= a.length; j++) {
        if (b.charAt(i-1) === a.charAt(j-1)) {
          matrix[i][j] = matrix[i-1][j-1];
        } else {
          matrix[i][j] = Math.min(
            matrix[i-1][j-1] + 1,  // Substitution
            matrix[i][j-1] + 1,    // Insertion
            matrix[i-1][j] + 1     // Deletion
          );
        }
      }
    }

    return matrix[b.length][a.length]
  }

  // Calculate the similarity ratio between two strings (0-1, case sensitive)
  function distanceSimilarity(a: string, b: string): real {
    const maxLen = Math.max(a.length, b.length);
    if (maxLen === 0) return 1;

    const distance = levenshteinDistance(a, b);
    return (maxLen - distance) / maxLen;
  }

  function substringSimilarity(a: string, b: string): real {
    if (a.includes(b)) {
      return 1;
    }

    let bestScore = 0;
    for (let i=0; i <= b.length - a.length; i++) {
      const window = b.substring(i, i+ a.length);
      const score = distanceSimilarity(a, window);
      bestScore = Math.max(bestScore, score);
    }
    return bestScore
  }

  function similarity(a: string, b: string): real {
    const substringScore = substringSimilarity(a, b);
    const distanceScore = distanceSimilarity(a, b);
    return Math.max(substringScore, distanceScore);
  }

  function fuzzySearch(items: var, query: string, key: string, threshold: real): var {
    threshold = threshold || 0.6;
    key = key || null;

    if (!query || query.length === 0) {
      return items;
    }

    query = query.toLowerCase();

    let result = [];

    for (let i=0; i < items.length; i++) {
      const item = items[i];
      const searchText = (!!key ? item[key] : item).toLowerCase();

      if (typeof searchText !== 'string') {
        continue;
      }

      let score = similarity(query, searchText);

      if (score >= threshold) {
        result.push({
          item: item,
          score: score
        })
      }
    }

    result.sort((a,b) => b.score - a.score);

    return result.map((item) => item.item);
  }
}

