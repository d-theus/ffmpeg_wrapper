module FfmpegWrapper
  class Format < ::OpenStruct
    CMDLINE_NAMES = {
      format_name: 'f'
    }
    def to_cmdline
      cmd = ''
      each_pair do |field, value|
        field_for_cmd = CMDLINE_NAMES[field]
        cmd << " #{field_for_cmd} #{value}" if field_for_cmd
      end
      cmd
    end
  end
end
