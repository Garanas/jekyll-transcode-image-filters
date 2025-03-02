# frozen_string_literal: true

require "spec_helper"

describe(Jekyll::TranscodeImageFilters) do 
  let(:overrides) { {} }
  let(:config) do
    Jekyll.configuration(Jekyll::Utils.deep_merge_hashes({
      "full_rebuild" => true,
      "source"       => source_dir,
      "destination"  => dest_dir,
      "url"          => "https://jipwijnia.nl",
      "name"         => "My awesome test",
      "author"       => {
        "name" => "Dr. Jekyll",
      },
    }, overrides))
  end
  let(:site)     { Jekyll::Site.new(config) }
  let(:jekyll_env) { "development" }

  before(:each) do
    allow(Jekyll).to receive(:env).and_return(jekyll_env)
    site.process
  end

  describe "directory exists" do

    # covers the features:
    # - Feature to create a cache directory
    # - Feature to create a cache/avif directory
    # - Feature to create a cache/webp directory
    # - Feature to create a cache/jpg directory

    describe "in source:" do
      it "cache" do
        expect(File.directory?(source_dir('cache'))).to be true
      end

      it "cache/avif" do
        expect(File.directory?(source_dir('cache', 'avif'))).to be true
      end

      it "cache/webp" do
        expect(File.directory?(source_dir('cache', 'webp'))).to be true
      end

      it "cache/jpeg" do
        expect(File.directory?(source_dir('cache', 'jpg'))).to be true
      end
    end

    describe "in destination:" do
      it "cache" do
        expect(File.directory?(dest_dir('cache'))).to be true
      end

      it "cache/avif" do
        expect(File.directory?(dest_dir('cache', 'avif'))).to be true
      end

      it "cache/webp" do
        expect(File.directory?(dest_dir('cache', 'webp'))).to be true
      end

      it "cache/jpeg" do
        expect(File.directory?(dest_dir('cache', 'jpg'))).to be true
      end
    end
  end

  # covers the features:
  # - Feature to transcodes image to .avif
  # - Feature to transcodes image to .webp
  # - Feature to transcodes image to .jpeg
    
  describe "image in cache of source" do
    it "contains .avif" do
      expect(Dir.glob(source_dir('cache', 'avif', '**', '*240x135.avif')).any?).to be true
    end
  
    it "contains .webp" do
      expect(Dir.glob(source_dir('cache', 'webp', '**', '*240x135.webp')).any?).to be true
    end
  
    it "contains .jpg" do
      expect(Dir.glob(source_dir('cache', 'jpg', '**', '*240x135.jpg')).any?).to be true
    end
  end

  describe "image is in cache of destination " do
    it "contains .avif" do
      expect(Dir.glob(dest_dir('cache', 'avif', '**', '*240x135.avif')).any?).to be true
    end
  
    it "contains .webp" do
      expect(Dir.glob(dest_dir('cache', 'webp', '**', '*240x135.webp')).any?).to be true
    end
  
    it "contains .jpg" do
      expect(Dir.glob(dest_dir('cache', 'jpg', '**', '*240x135.jpg')).any?).to be true
    end
  end

  # covers the features:
  # - Feature to change resolution of transcoded images

  it "all files have resolution in file name" do
    cache_dir = source_dir('cache')
    Dir.glob("#{cache_dir}/**/*").each do |file|
      next if File.directory?(file)
      file_name = File.basename(file)
      match = file_name.match(/(\d+)x(\d+)\.(avif|webp|jpg)/)
      expect(match).not_to be_nil
    end
  end

  it "all file resolutions match the resolution in the file name" do
    cache_dir = source_dir('cache')
    Dir.glob("#{cache_dir}/**/*").each do |file|
      next if File.directory?(file)
      width, height = get_image_resolution(file)
      file_name = File.basename(file)
      match = file_name.match(/(\d+)x(\d+)\.(avif|webp|jpg)/)
      if match
        expected_width = match[1].to_i
        expected_height = match[2].to_i
        expect(width).to eq expected_width
        expect(height).to eq expected_height
      end
    end
  end
end