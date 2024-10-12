// app/javascript/packs/application.js

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/storage";
import { debounce } from "lodash"; // You can install lodash for debouncing
Rails.start();
Turbolinks.start();
ActiveStorage.start();

document.addEventListener('DOMContentLoaded', () => {
  const jobsSection = document.querySelector('.jobs-section');
  const loading = document.querySelector('.loading-indicator');
  let currentPage = 1; // Track the current page for lazy loading
  let isLoading = false; // To prevent multiple requests

  const loadJobs = async () => {
    if (isLoading) return;

    isLoading = true;
    loading.classList.remove('hidden'); // Show loading indicator

    const location = document.getElementById('location').value;
    const response = await fetch(`/jobs?page=${currentPage}&location=${location}`);

    if (response.ok) {
      const jobsHtml = await response.text();
      jobsSection.insertAdjacentHTML('beforeend', jobsHtml);
      currentPage++;
    } else {
      console.error('Failed to load jobs:', response.status);
    }

    loading.classList.add('hidden'); // Hide loading indicator
    isLoading = false;
  };

  const onScroll = () => {
    const { scrollTop, scrollHeight, clientHeight } = document.documentElement;

    if (scrollTop + clientHeight >= scrollHeight - 10) {
      loadJobs();
    }
  };

  window.addEventListener('scroll', debounce(onScroll, 200));

  // Filter functionality
  document.getElementById('location').addEventListener('change', () => {
    currentPage = 1; // Reset current page for new filter
    jobsSection.innerHTML = ''; // Clear existing jobs
    loadJobs(); // Load jobs based on the selected filter
  });

  // Initial job load
  loadJobs();
});
