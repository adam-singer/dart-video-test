chrome.app.runtime.onLaunched.addListener(function() {
  chrome.app.window.create('video_test.html', {
    width: 800,
    height: 600
  });
});
