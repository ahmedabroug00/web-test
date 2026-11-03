(() => {
  'use strict';

  const root = document.documentElement;
  const themeToggle = document.querySelector('#theme-toggle');
  const preferredTheme = window.matchMedia('(prefers-color-scheme: light)');

  function getSavedTheme() {
    try {
      return localStorage.getItem('dev-notes-theme');
    } catch {
      return null;
    }
  }

  function applyTheme(theme) {
    root.dataset.theme = theme;
    themeToggle.setAttribute('aria-label', `Switch to ${theme === 'dark' ? 'light' : 'dark'} theme`);
    document.querySelector('meta[name="theme-color"]').content = theme === 'dark' ? '#101410' : '#f6f7f0';
  }

  const savedTheme = getSavedTheme();
  applyTheme(savedTheme === 'light' || savedTheme === 'dark' ? savedTheme : preferredTheme.matches ? 'light' : 'dark');
  themeToggle.hidden = false;
  themeToggle.addEventListener('click', () => {
    const theme = root.dataset.theme === 'dark' ? 'light' : 'dark';
    applyTheme(theme);
    try {
      localStorage.setItem('dev-notes-theme', theme);
    } catch {
      // Theme switching still works when browser storage is unavailable.
    }
  });
  preferredTheme.addEventListener('change', (event) => {
    if (!getSavedTheme()) applyTheme(event.matches ? 'light' : 'dark');
  });

  const cards = [...document.querySelectorAll('.note-card')];
  const filters = [...document.querySelectorAll('[data-filter]')];
  const search = document.querySelector('#search');
  const resultCount = document.querySelector('#result-count');
  const emptyState = document.querySelector('#empty-state');
  let activeFilter = 'all';

  function updateNotes() {
    const query = search.value.trim().toLocaleLowerCase();
    let visibleCount = 0;
    cards.forEach((card) => {
      const matchesTopic = activeFilter === 'all' || card.dataset.category === activeFilter;
      const matchesSearch = card.textContent.toLocaleLowerCase().includes(query);
      card.hidden = !(matchesTopic && matchesSearch);
      if (!card.hidden) visibleCount += 1;
    });
    filters.forEach((button) => {
      const active = button.dataset.filter === activeFilter;
      button.classList.toggle('active', active);
      button.setAttribute('aria-pressed', String(active));
    });
    emptyState.hidden = visibleCount > 0;
    resultCount.textContent = `${visibleCount} ${visibleCount === 1 ? 'note' : 'notes'} found`;
  }

  filters.forEach((button) => {
    button.addEventListener('click', () => {
      activeFilter = button.dataset.filter;
      updateNotes();
    });
  });
  search.addEventListener('input', updateNotes);
  document.querySelector('#reset-filters').addEventListener('click', () => {
    activeFilter = 'all';
    search.value = '';
    updateNotes();
    search.focus();
  });

  function revealLinkedGuide() {
    // Match known IDs rather than passing an arbitrary URL fragment to a selector.
    const card = cards.find((item) => `#${item.id}` === window.location.hash);
    if (!card) return;
    activeFilter = 'all';
    search.value = '';
    updateNotes();
    card.querySelector('details').open = true;
    card.scrollIntoView({ block: 'start' });
  }

  document.querySelector('#explore-controls').hidden = false;
  updateNotes();
  window.addEventListener('hashchange', revealLinkedGuide);
  // Also handle a link to the current fragment after filters have changed.
  document.querySelectorAll('a[href^="#guide-"]').forEach((link) => {
    link.addEventListener('click', () => {
      if (link.hash === window.location.hash) revealLinkedGuide();
    });
  });
  revealLinkedGuide();
})();