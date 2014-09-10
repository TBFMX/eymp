json.array!(@videos) do |video|
  json.extract! video, :id, :gallery_id, :video_url, :title
  json.url video_url(video, format: :json)
end
