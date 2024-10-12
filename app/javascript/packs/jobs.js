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

function updateMap(jobCoordinates) {
  // ... existing code ...

  jobCoordinates.forEach((job, index) => {
    // ... existing code ...

    const popupContent = `
      <div class="custom-popup">
        <h3>${job.title || `Job ${index + 1}`}</h3>
        ${job.company ? `
          <div class="job-detail">
            <img src="https://cdn-icons-png.flaticon.com/512/2910/2910791.png" alt="Company" class="job-detail-icon">
            <p>${job.company}</p>
          </div>
        ` : ''}
        ${job.location ? `
          <div class="job-detail">
            <img src="https://cdn-icons-png.flaticon.com/512/484/484167.png" alt="Location" class="job-detail-icon">
            <p>${job.location}</p>
          </div>
        ` : ''}
        ${job.salary_min && job.salary_max ? `
          <div class="job-detail">
            <img src="https://cdn-icons-png.flaticon.com/512/2830/2830284.png" alt="Salary" class="job-detail-icon">
            <p>${formatSalary(job.salary_min, job.salary_max)}</p>
          </div>
        ` : ''}
        ${job.job_type ? `
          <div class="job-detail">
            <img src="https://cdn-icons-png.flaticon.com/512/3281/3281289.png" alt="Job Type" class="job-detail-icon">
            <p>${job.job_type}</p>
          </div>
        ` : ''}
        ${job.industry ? `
          <div class="job-detail">
            <img src="https://cdn-icons-png.flaticon.com/512/2910/2910791.png" alt="Industry" class="job-detail-icon">
            <p>${job.industry}</p>
          </div>
        ` : ''}
        <a href="/jobs/${job.id}/job_applications/new" class="apply-now-btn">Apply Now</a>
      </div>
    `;
    marker.bindPopup(popupContent);
    
    // ... existing code ...
  });

  // ... existing code ...
}

function formatSalary(min, max) {
  const formatK = (num) => Math.round(num / 1000) + 'k';
  return `${formatK(min)}-${formatK(max)}`;
}

// ... existing code ...
