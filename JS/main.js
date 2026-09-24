/* ============================================================================
   Library Management System - Custom JavaScript Utilities
   ============================================================================ */

document.addEventListener("DOMContentLoaded", function () {
    // Suppress DataTables modal popups for dynamic postback table rebindings
    if (window.jQuery && $.fn.DataTable) {
        $.fn.dataTable.ext.errMode = 'none';
    }

    // Sidebar toggle handler
    const sidebar = document.getElementById("sidebar");
    const toggleBtn = document.getElementById("sidebarToggle");

    if (toggleBtn && sidebar) {
        toggleBtn.addEventListener("click", function (e) {
            e.preventDefault();
            if (window.innerWidth <= 768) {
                sidebar.classList.toggle("active");
            } else {
                sidebar.classList.toggle("collapsed");
            }
        });
    }

    // Auto initialize DataTables on elements with .datatable class
    if (window.jQuery && $.fn.DataTable) {
        $('.datatable').DataTable({
            responsive: true,
            language: {
                search: "_INPUT_",
                searchPlaceholder: "Search records...",
                lengthMenu: "Show _MENU_ entries"
            },
            pageLength: 10,
            dom: '<"row mb-3"<"col-md-6"l><"col-md-6"f>>rt<"row mt-3"<"col-md-6"i><"col-md-6"p>>'
        });
    }
});

// Toast / Notification alerts using SweetAlert2 if available or fallback
function showNotification(title, message, iconType) {
    if (typeof Swal !== 'undefined') {
        Swal.fire({
            icon: iconType || 'info',
            title: title || 'Notification',
            text: message,
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 4000,
            timerProgressBar: true
        });
    } else {
        alert(title + ": " + message);
    }
}

// Confirmation dialog for delete actions
function confirmAction(message, callback) {
    if (typeof Swal !== 'undefined') {
        Swal.fire({
            title: 'Are you sure?',
            text: message || "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#ef4444',
            cancelButtonColor: '#64748b',
            confirmButtonText: 'Yes, proceed!'
        }).then((result) => {
            if (result.isConfirmed) {
                if (typeof callback === 'function') {
                    callback();
                }
            }
        });
    } else {
        if (confirm(message)) {
            if (typeof callback === 'function') {
                callback();
            }
        }
    }
}

// Image Preview Helper for File Uploads
function previewUploadedImage(input, previewElementId) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
            var imgElem = document.getElementById(previewElementId);
            if (imgElem) {
                imgElem.src = e.target.result;
                imgElem.style.display = 'block';
            }
        }
        reader.readAsDataURL(input.files[0]);
    }
}

// Show/Hide Spinner
function showLoading() {
    var spinner = document.getElementById('loadingSpinner');
    if (spinner) spinner.style.display = 'flex';
}

function hideLoading() {
    var spinner = document.getElementById('loadingSpinner');
    if (spinner) spinner.style.display = 'none';
}
