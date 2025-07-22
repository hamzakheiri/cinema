<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Movie Halls Administration - Static Example</title>
    <!-- Bootstrap CSS CDN -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }

        .container {
            margin-top: 30px;
        }

        .header {
            margin-bottom: 20px;
        }

        .table-responsive {
            margin-top: 20px;
        }

        .form-container {
            margin-top: 40px;
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
<div class="container">
    <h1 class="header text-center">Films Administration</h1>

    <!-- Static Halls List -->
    <div class="table-responsive">
        <table class="table table-bordered table-striped">
            <thead class="thead-dark">
            <tr>
                <th>Title</th>
                <th>Year</th>
                <th>Age Restrictions</th>
                <th>Description</th>
            </tr>
            </thead>
            <tbody>
            <#if films?? && (films?size > 0)>
                <#list films as film>
                    <tr>
                        <td>${film.title}</td>
                        <td>${film.year}</td>
                        <td>${film.ageRestrictions}</td>
                        <td>${film.description}</td>
                    </tr>
                </#list>
            <#else>
                <tr>
                    <td colspan="4" class="text-center">No films available.</td>
                </tr>
            </#if>
            </tbody>
        </table>
    </div>

    <!-- Form to Create a New Hall -->
    <div class="form-container">
        <h3>Create New film</h3>
        <#assign ctx = request.contextPath>
        <form action="${ctx}/admin/panel/films/" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label for="title">Title</label>
                <input type="text" class="form-control" id="title" name="title"
                       placeholder="Enter film title" required>
            </div>
            <div class="form-group">
                <label for="year">Year</label>
                <input type="number" class="form-control" id="year" name="year" placeholder="Enter film year" required>
            </div>

            <div class="form-group">
                <label for="ageRestrictions">Age Restrictions</label>
                <input type="number" class="form-control" id="ageRestrictions" name="ageRestrictions" placeholder="Enter age restrictions" required>
            </div>

            <div class="form-group">
                <label for="description">Description</label>
                <input type="text" class="form-control" id="description" name="description" placeholder="Enter film description" required>
            </div>

            <div class="form-group">
                <label for="poster">Upload Poster</label>
                <input type="file" id="poster" name="poster" class="form-control-file" accept="image/*">
            </div>

            <button type="submit" class="btn btn-primary">Add film</button>
        </form>
    </div>
    <#if error??>
        <div class="alert alert-danger mt-3">${error}
        </div>
    </#if>
</div>
<!-- jQuery and Bootstrap JS Bundle (includes Popper) -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
