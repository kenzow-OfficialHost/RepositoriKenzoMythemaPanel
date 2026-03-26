// Glow effect for links
document.addEventListener('DOMContentLoaded', () => {
    const links = document.querySelectorAll('a');
    links.forEach(link => {
        link.addEventListener('mouseover', () => link.style.color = '#ff4500');
        link.addEventListener('mouseout', () => link.style.color = '#ff2a00');
    });

    // Optional: animate headers
    const headers = document.querySelectorAll('h1, h2, h3');
    headers.forEach(h => {
        h.style.transition = "text-shadow 0.3s";
    });
});
