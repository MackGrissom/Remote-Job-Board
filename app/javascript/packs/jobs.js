document.addEventListener('turbolinks:load', function() {
    const form = document.getElementById('job-filter-form');
    const jobListings = document.getElementById('job-listings');
  
    if (form) {
      form.addEventListener('submit', function(e) {
        e.preventDefault();
        const formData = new FormData(form);
        const searchParams = new URLSearchParams(formData);
  
        fetch(`${form.action}?${searchParams.toString()}`, {
          headers: {
            'Accept': 'application/json'
          }
        })
        .then(response => response.json())
        .then(data => {
          jobListings.innerHTML = data.html;
        })
        .catch(error => console.error('Error:', error));
      });
    }
  
    // Handle pagination links
    document.addEventListener('click', function(e) {
      if (e.target.matches('.pagination a')) {
        e.preventDefault();
        fetch(e.target.href, {
          headers: {
            'Accept': 'application/json'
          }
        })
        .then(response => response.json())
        .then(data => {
          jobListings.innerHTML = data.html;
        })
        .catch(error => console.error('Error:', error));
      }
    });
  });