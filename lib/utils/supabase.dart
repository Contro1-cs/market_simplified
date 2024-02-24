class SupabaseCred {
  String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndjbHJqcGNxdWlweG1vdWlodWtkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDg3NzgxMTQsImV4cCI6MjAyNDM1NDExNH0.BPpMnIjWD2ybOWmJI89iZAGi5tOD83nHsupg6MAOTN0';
  String url = 'https://wclrjpcquipxmouihukd.supabase.co';
  String getAeon() {
    return anonKey;
  }

  String getUrl() {
    return url;
  }
}
