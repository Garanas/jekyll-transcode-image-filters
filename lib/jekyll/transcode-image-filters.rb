require "digest"
require "mini_magick"

module Jekyll
  module TranscodeImageFilters
    CACHE_DIR_WEBP = "cache/webp/"
    CACHE_DIR_JPG = "cache/jpg/"
    HASH_LENGTH = 32

    # Computes the name of the file in the cache.
    # @param absolute_path_source [String] Full path to the source file
    # @param resolution [String] As an example: 900x900
    # @param format [String] As an example: webp or jpg
    # @return [String] 
    def _compute_cache_filename(absolute_path_source, resolution, format)
      hash = Digest::SHA256.file(absolute_path_source)
      short_hash = hash.hexdigest()[0, HASH_LENGTH]

      if resolution && resolution != "original"
        "#{short_hash}-#{resolution}.#{format}"
      else
        "#{short_hash}.#{format}"
      end
    end

    # Compute all necessary paths for the plugin.
    # @param absolute_path_site [String] As an example: "C:/jekyll/jekyll-transcode-image-filters"
    # @param relative_path_source [String] As an example: "/assets/image-a.png" or "/assets/style/main.css"
    # @param cache_dir [String] Directory of the cache folder, as an example: "cache/bmp/"
    # @param resolution [String] As an example: 900x900
    # @param format [String] As an example: webp or jpg
    # @return [Array(String, String, String, String, String)]
    # * [String] absolute_path_source - Full path to the source file
    # * [String] absolute_path_destination - Full path to the destination file
    # * [String] absolute_path_cache - Full path to the cache directory
    # * [String] file_name_destination - Name of the destination file
    # * [String] relative_path_destination - Relative path to the destination file
    def _compute_paths(absolute_path_site, relative_path_source, cache_dir, resolution, format)
      absolute_path_source = File.join(absolute_path_site, relative_path_source)
      raise "No file found at #{absolute_path_source}" unless File.readable?(absolute_path_source)

      file_name_destination = _compute_cache_filename(absolute_path_source, resolution, format)

      absolute_path_cache = File.join(absolute_path_site, cache_dir)
      absolute_path_destination = File.join(absolute_path_cache, file_name_destination)
      relative_path_destination = File.join(cache_dir, file_name_destination)

      [absolute_path_source, absolute_path_destination, absolute_path_cache, file_name_destination, relative_path_destination]
    end

    # Determine whether the file exists in the cache.
    # @param absolute_path_source [String] As an example: "C:/jekyll/jekyll-transcode-image-filters"
    # @param absolute_path_destination [String] As an example: "/assets/image-a.png" or "/assets/image-a.bmp"
    # @return [Boolean] If true, the file exists in the cache.
    def _in_cache? (absolute_path_source, absolute_path_destination)
      File.exist?(absolute_path_destination)
    end

    # Determine whether the file in the cache is still valid. It does so by comparing the modification times of the files.
    # @param absolute_path_source [String] As an example: "C:/jekyll/jekyll-transcode-image-filters"
    # @param absolute_path_destination [String] As an example: "/assets/image-a.png" or "/assets/image-a.bmp"
    # @return [Boolean] If true, the file should be skipped.
    def _valid_cache? (absolute_path_source, absolute_path_destination)
      File.mtime(absolute_path_destination) >= File.mtime(absolute_path_source)
    end

    # Read, process, and write the (new) image to disk.
    # @param absolute_path_source [String] As an example: "C:/jekyll/jekyll-transcode-image-filters/assets/image-a.png"
    # @param absolute_path_destination [String] As an example: "C:/jekyll/jekyll-transcode-image-filters/assets/image-a-processed.png" 
    def _process_img(absolute_path_source, absolute_path_destination, resolution, format)
      image = MiniMagick::Image.open(absolute_path_source)
      image.format format

      if resolution && resolution != "original"
        image.auto_orient
        image.resize resolution
        image.strip
      end

      image.write absolute_path_destination
    end

    # Transcodes an image to the given format and resolution. Processed files are cached to speed up builds.
    # @param relative_source_path [String] As an example: "/assets/image-a.png" or "/assets/image-b.bmp"
    # @param resolution [String] As an example: 900x900
    # @param format [String] As an example: webp or jpg
    # @return [String] As an example: "/cache/webp/f69a4d50f20bb781f908db2b2b2c7739.webp"
    def _transcode (relative_source_path, resolution, format)
      site = @context.registers[:site]

      absolute_path_source, absolute_path_destination, absolute_path_cache, file_name_destination, relative_path_destination = _compute_paths(site.source, relative_source_path, CACHE_DIR_WEBP, resolution, "webp")

      # Guarantee the existence of the cache directory
      FileUtils.mkdir_p(absolute_path_cache)

      if _in_cache?(absolute_path_source, absolute_path_destination) && _valid_cache?(absolute_path_source, absolute_path_destination)
        # if the file is cached and valid we can just return the relative path
        return relative_path_destination
      else
        # otherwise, we process the file and add it to the cache
        puts "Encoding '#{relative_source_path}' to '#{relative_path_destination}'"
        _process_img(absolute_path_source, absolute_path_destination , resolution,  "webp")
        site.static_files << Jekyll::StaticFile.new(site, site.source, CACHE_DIR_WEBP, file_name_destination)
      end

      relative_path_destination
    end

    # Transcodes an image to the webp format in the given resolution. Processed files are cached to speed up builds.
    # @param relative_source_path [String] As an example: "/assets/image-a.png" or "/assets/image-b.bmp"
    # @param resolution [String] As an example: 900x900, is optional
    # @return [String] As an example: "/cache/webp/f69a4d50f20bb781f908db2b2b2c7739.webp"
    def webp(relative_source_path, resolution = "original")
      _transcode(relative_source_path, resolution, "webp")
    end

    # Transcodes an image to the jpg format. Processed files are cached to speed up builds.
    # @param relative_source_path [String] As an example: "/assets/image-a.png" or "/assets/image-b.bmp"
    # @param resolution [String] As an example: 900x900, is optional
    # @return [String] As an example: "/cache/jpg/f69a4d50f20bb781f908db2b2b2c7739.jpg"
    def jpg(relative_source_path, resolution = "original")
      _transcode(relative_source_path, resolution, "jpg")
    end
  end
end

Liquid::Template.register_filter(Jekyll::TranscodeImageFilters)
