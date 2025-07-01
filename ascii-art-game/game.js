// ASCII Art Generator Game
class ASCIIArtGame {
    constructor() {
        this.stats = {
            artCount: 0,
            score: 0,
            level: 1,
            colorsUsed: new Set(),
            stylesUsed: new Set(),
            wordsCreated: new Set()
        };
        
        this.achievements = {
            'first-art': false,
            'speed-demon': false,
            'rainbow-master': false,
            'word-wizard': false,
            'style-explorer': false,
            'art-collector': false
        };
        
        this.currentColor = '#00ff00';
        this.lastGenerationTime = 0;
        this.savedArt = [];
        
        this.loadProgress();
        this.initializeEventListeners();
        this.updateDisplay();
    }
    
    initializeEventListeners() {
        // Color picker
        document.querySelectorAll('.color-option').forEach(option => {
            option.addEventListener('click', (e) => {
                document.querySelectorAll('.color-option').forEach(opt => opt.classList.remove('selected'));
                e.target.classList.add('selected');
                this.currentColor = e.target.dataset.color;
                document.getElementById('asciiOutput').style.color = this.currentColor;
            });
        });
        
        // Enter key support
        document.getElementById('textInput').addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                generateArt();
            }
        });
    }
    
    generateASCII(text, style) {
        const styles = {
            block: {
                chars: ['█', '▓', '▒', '░'],
                height: 5
            },
            shadow: {
                chars: ['▄', '▀', '█', '▌', '▐'],
                height: 4
            },
            double: {
                chars: ['╔', '╗', '╚', '╝', '║', '═'],
                height: 3
            },
            bubble: {
                chars: ['●', '○', '◐', '◑', '◒', '◓'],
                height: 4
            },
            digital: {
                chars: ['▓▓▓', '░░░', '▒▒▒', '███'],
                height: 5
            }
        };
        
        if (!text.trim()) return 'Enter some text to generate ASCII art!';
        
        const selectedStyle = styles[style] || styles.block;
        const result = [];
        
        // Generate ASCII art based on style
        for (let row = 0; row < selectedStyle.height; row++) {
            let line = '';
            for (let char of text.toUpperCase()) {
                line += this.getCharPattern(char, row, selectedStyle) + ' ';
            }
            result.push(line);
        }
        
        return result.join('\n');
    }
    
    getCharPattern(char, row, style) {
        const patterns = {
            'A': [
                '  ▄▄▄  ',
                ' ▄▀ ▀▄ ',
                '▄▄▄▄▄▄▄',
                '▀     ▀',
                '       '
            ],
            'B': [
                '▄▄▄▄▄▄ ',
                '▀     ▄',
                '▄▄▄▄▄▄ ',
                '▀     ▄',
                '▀▀▀▀▀▀ '
            ],
            'C': [
                ' ▄▄▄▄▄▄',
                '▄▀     ',
                '▀      ',
                '▄▀     ',
                ' ▀▀▀▀▀▀'
            ],
            'D': [
                '▄▄▄▄▄▄ ',
                '▀     ▄',
                '▀     ▄',
                '▀     ▄',
                '▀▀▀▀▀▀ '
            ],
            'E': [
                '▄▄▄▄▄▄▄',
                '▀      ',
                '▄▄▄▄▄  ',
                '▀      ',
                '▀▀▀▀▀▀▀'
            ],
            'F': [
                '▄▄▄▄▄▄▄',
                '▀      ',
                '▄▄▄▄▄  ',
                '▀      ',
                '▀      '
            ],
            'G': [
                ' ▄▄▄▄▄▄',
                '▄▀     ',
                '▀   ▄▄▄',
                '▄▀    ▄',
                ' ▀▀▀▀▀▀'
            ],
            'H': [
                '▄     ▄',
                '▀     ▄',
                '▄▄▄▄▄▄▄',
                '▀     ▄',
                '▀     ▀'
            ],
            'I': [
                '▄▄▄▄▄▄▄',
                '   ▄   ',
                '   ▄   ',
                '   ▄   ',
                '▀▀▀▀▀▀▀'
            ],
            'J': [
                '▄▄▄▄▄▄▄',
                '     ▄ ',
                '     ▄ ',
                '▄    ▄ ',
                ' ▀▀▀▀  '
            ],
            'K': [
                '▄    ▄▄',
                '▀   ▄▀ ',
                '▄▄▄▀   ',
                '▀   ▀▄ ',
                '▀    ▀▀'
            ],
            'L': [
                '▄      ',
                '▀      ',
                '▄      ',
                '▀      ',
                '▀▀▀▀▀▀▀'
            ],
            'M': [
                '▄▄   ▄▄',
                '▀▀▄ ▄▀▀',
                '▄ ▀▄▀ ▄',
                '▀  ▀  ▀',
                '▀     ▀'
            ],
            'N': [
                '▄▄    ▄',
                '▀▀▄   ▄',
                '▄ ▀▄  ▄',
                '▀  ▀▄ ▄',
                '▀   ▀▀▀'
            ],
            'O': [
                ' ▄▄▄▄▄ ',
                '▄▀   ▀▄',
                '▀     ▀',
                '▄▀   ▀▄',
                ' ▀▀▀▀▀ '
            ],
            'P': [
                '▄▄▄▄▄▄ ',
                '▀     ▄',
                '▄▄▄▄▄▄ ',
                '▀      ',
                '▀      '
            ],
            'Q': [
                ' ▄▄▄▄▄ ',
                '▄▀   ▀▄',
                '▀  ▄  ▀',
                '▄▀  ▀▄▄',
                ' ▀▀▀▀▀▀'
            ],
            'R': [
                '▄▄▄▄▄▄ ',
                '▀     ▄',
                '▄▄▄▄▄▄ ',
                '▀  ▀▄  ',
                '▀   ▀▄ '
            ],
            'S': [
                ' ▄▄▄▄▄▄',
                '▄▀     ',
                ' ▀▀▀▀▄ ',
                '     ▀▄',
                '▄▄▄▄▄▀ '
            ],
            'T': [
                '▄▄▄▄▄▄▄',
                '   ▄   ',
                '   ▄   ',
                '   ▄   ',
                '   ▀   '
            ],
            'U': [
                '▄     ▄',
                '▀     ▄',
                '▄     ▄',
                '▀▄   ▄▀',
                ' ▀▀▀▀▀ '
            ],
            'V': [
                '▄     ▄',
                '▀     ▄',
                '▄     ▄',
                ' ▀▄ ▄▀ ',
                '  ▀▄▀  '
            ],
            'W': [
                '▄     ▄',
                '▀     ▄',
                '▄  ▄  ▄',
                '▀▄▀ ▀▄▀',
                ' ▀   ▀ '
            ],
            'X': [
                '▄▄   ▄▄',
                ' ▀▄ ▄▀ ',
                '  ▀▄▀  ',
                ' ▄▀ ▀▄ ',
                '▄▀   ▀▄'
            ],
            'Y': [
                '▄▄   ▄▄',
                ' ▀▄ ▄▀ ',
                '  ▀▄▀  ',
                '   ▄   ',
                '   ▀   '
            ],
            'Z': [
                '▄▄▄▄▄▄▄',
                '     ▄▀',
                '   ▄▀  ',
                ' ▄▀    ',
                '▀▀▀▀▀▀▀'
            ],
            ' ': [
                '       ',
                '       ',
                '       ',
                '       ',
                '       '
            ],
            '!': [
                '   ▄   ',
                '   ▄   ',
                '   ▄   ',
                '       ',
                '   ▀   '
            ],
            '?': [
                ' ▄▄▄▄▄ ',
                '     ▀▄',
                '   ▄▄▀ ',
                '       ',
                '   ▀   '
            ]
        };
        
        const pattern = patterns[char] || patterns[' '];
        return pattern[row] || '       ';
    }
    
    updateStats(text, style) {
        this.stats.artCount++;
        this.stats.score += text.length * 10;
        this.stats.colorsUsed.add(this.currentColor);
        this.stats.stylesUsed.add(style);
        this.stats.wordsCreated.add(text.toLowerCase());
        
        // Level up every 5 art pieces
        this.stats.level = Math.floor(this.stats.artCount / 5) + 1;
        
        this.checkAchievements();
        this.updateDisplay();
        this.saveProgress();
    }
    
    checkAchievements() {
        // First Artist
        if (this.stats.artCount >= 1 && !this.achievements['first-art']) {
            this.unlockAchievement('first-art');
        }
        
        // Speed Demon (generate art within 2 seconds of last generation)
        const now = Date.now();
        if (now - this.lastGenerationTime < 2000 && this.lastGenerationTime > 0 && !this.achievements['speed-demon']) {
            this.unlockAchievement('speed-demon');
        }
        this.lastGenerationTime = now;
        
        // Rainbow Master (use 4+ different colors)
        if (this.stats.colorsUsed.size >= 4 && !this.achievements['rainbow-master']) {
            this.unlockAchievement('rainbow-master');
        }
        
        // Word Wizard (create 10+ different words)
        if (this.stats.wordsCreated.size >= 10 && !this.achievements['word-wizard']) {
            this.unlockAchievement('word-wizard');
        }
        
        // Style Explorer (use all 5 styles)
        if (this.stats.stylesUsed.size >= 5 && !this.achievements['style-explorer']) {
            this.unlockAchievement('style-explorer');
        }
        
        // Art Collector (create 25+ art pieces)
        if (this.stats.artCount >= 25 && !this.achievements['art-collector']) {
            this.unlockAchievement('art-collector');
        }
    }
    
    unlockAchievement(achievementId) {
        this.achievements[achievementId] = true;
        const element = document.getElementById(achievementId);
        element.classList.add('unlocked');
        
        // Show celebration effect
        this.showAchievementNotification(achievementId);
        this.stats.score += 100; // Bonus points for achievements
    }
    
    showAchievementNotification(achievementId) {
        const notification = document.createElement('div');
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            background: linear-gradient(45deg, #ffd700, #ffed4e);
            color: #333;
            padding: 15px 20px;
            border-radius: 10px;
            font-weight: bold;
            box-shadow: 0 4px 20px rgba(255, 215, 0, 0.5);
            z-index: 1000;
            animation: slideIn 0.5s ease-out;
        `;
        
        const achievementNames = {
            'first-art': '🎨 First Artist Unlocked!',
            'speed-demon': '⚡ Speed Demon Unlocked!',
            'rainbow-master': '🌈 Rainbow Master Unlocked!',
            'word-wizard': '📝 Word Wizard Unlocked!',
            'style-explorer': '🎭 Style Explorer Unlocked!',
            'art-collector': '🏆 Art Collector Unlocked!'
        };
        
        notification.textContent = achievementNames[achievementId];
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.remove();
        }, 3000);
    }
    
    updateDisplay() {
        document.getElementById('artCount').textContent = this.stats.artCount;
        document.getElementById('score').textContent = this.stats.score;
        document.getElementById('level').textContent = this.stats.level;
    }
    
    saveProgress() {
        localStorage.setItem('asciiGameStats', JSON.stringify(this.stats));
        localStorage.setItem('asciiGameAchievements', JSON.stringify(this.achievements));
        localStorage.setItem('asciiGameSavedArt', JSON.stringify(this.savedArt));
    }
    
    loadProgress() {
        const savedStats = localStorage.getItem('asciiGameStats');
        const savedAchievements = localStorage.getItem('asciiGameAchievements');
        const savedArt = localStorage.getItem('asciiGameSavedArt');
        
        if (savedStats) {
            const parsed = JSON.parse(savedStats);
            this.stats = {
                ...this.stats,
                ...parsed,
                colorsUsed: new Set(parsed.colorsUsed || []),
                stylesUsed: new Set(parsed.stylesUsed || []),
                wordsCreated: new Set(parsed.wordsCreated || [])
            };
        }
        
        if (savedAchievements) {
            this.achievements = { ...this.achievements, ...JSON.parse(savedAchievements) };
            // Update UI for unlocked achievements
            Object.keys(this.achievements).forEach(id => {
                if (this.achievements[id]) {
                    document.getElementById(id)?.classList.add('unlocked');
                }
            });
        }
        
        if (savedArt) {
            this.savedArt = JSON.parse(savedArt);
        }
    }
}

// Initialize the game
const game = new ASCIIArtGame();

// Global functions for HTML onclick events
function generateArt() {
    const text = document.getElementById('textInput').value;
    const style = document.getElementById('styleSelect').value;
    const output = document.getElementById('asciiOutput');
    
    if (!text.trim()) {
        output.textContent = 'Please enter some text to generate ASCII art!';
        return;
    }
    
    const ascii = game.generateASCII(text, style);
    output.textContent = ascii;
    output.style.color = game.currentColor;
    
    game.updateStats(text, style);
}

function randomizeAll() {
    const randomTexts = ['COOL', 'AWESOME', 'EPIC', 'WOW', 'NICE', 'GREAT', 'SUPER', 'AMAZING', 'FANTASTIC', 'BRILLIANT'];
    const styles = ['block', 'shadow', 'double', 'bubble', 'digital'];
    const colors = ['#00ff00', '#ff0080', '#00ffff', '#ffff00', '#ff8000', '#8000ff'];
    
    // Random text
    const randomText = randomTexts[Math.floor(Math.random() * randomTexts.length)];
    document.getElementById('textInput').value = randomText;
    
    // Random style
    const randomStyle = styles[Math.floor(Math.random() * styles.length)];
    document.getElementById('styleSelect').value = randomStyle;
    
    // Random color
    const randomColor = colors[Math.floor(Math.random() * colors.length)];
    document.querySelectorAll('.color-option').forEach(opt => opt.classList.remove('selected'));
    document.querySelector(`[data-color="${randomColor}"]`).classList.add('selected');
    game.currentColor = randomColor;
    
    // Generate the art
    generateArt();
}

function saveArt() {
    const output = document.getElementById('asciiOutput');
    const text = document.getElementById('textInput').value;
    
    if (output.textContent && text) {
        const artData = {
            text: text,
            ascii: output.textContent,
            color: game.currentColor,
            style: document.getElementById('styleSelect').value,
            timestamp: new Date().toISOString()
        };
        
        game.savedArt.push(artData);
        game.saveProgress();
        
        // Show save confirmation
        const notification = document.createElement('div');
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(0, 255, 0, 0.9);
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            font-weight: bold;
            z-index: 1000;
        `;
        notification.textContent = '💾 Art saved successfully!';
        document.body.appendChild(notification);
        
        setTimeout(() => notification.remove(), 2000);
    }
}

// Add CSS animation for notifications
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(100%);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
`;
document.head.appendChild(style);

