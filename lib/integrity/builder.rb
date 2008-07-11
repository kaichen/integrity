module Integrity
  class Builder
    def initialize(uri, branch, command)
      @uri = uri
      @command = command
      @build = Build.new
      @scm = SCM.new(@uri.scheme, @uri, branch, @build)
    end

    def build
      result = @scm.checkout(export_directory)
      return false unless result
      Dir.chdir(export_directory) do
        Kernel.system(@command)
      end
    end

    private
      def export_directory
        Integrity.scm_export_directory /
          @uri.path[1..-1].sub('/', '-').chomp(@uri.extname)
      end
  end
end