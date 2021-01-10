@namespace "request"

function parse_pathparam(template_url, received_url, params,    url_pattern,
        num_params, param_names, param_values, i, param_name) {
    # create regex pattern to extract path parameters
    url_pattern = template_url
    num_params = gsub(/:[^/]+/, "([^/]+)", url_pattern)

    # correct all path parameter names
    match(template_url, url_pattern, param_names)

    # correct all path parameter values
    matched = match(received_url, url_pattern, param_values)
    if (!matched) {
        return 0
    }

    # make path parameter array
    for (i = 1; i <= num_params; i++) {
        # trim `:` prefix of path_param (like `:name`)
        param_name = substr(param_names[i], 2);
        params[param_name] = param_values[i];
    }

    return 1
}

function contains_pathparam(template_url,    _, contains) {
    # copy template_url to protect from destructive operation
    _ = template_url
    contains = sub(/:[^/]+/, "([^/]+)", _)
    return contains
}
