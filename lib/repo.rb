class Repo
  class << self
    def all
      Jenkins.jobs(:depth => 1, :tree => 'jobs[downstreamProjects,name]').jobs.select do |job|
        job.downstreamProjects.any?
      end
    end

    def builds(name, opts='')
      Jenkins.job(name, :depth => 1, :tree => "builds[*,changeSet[items[*,author[*]]]#{opts}]").builds
    end

    def build(name, id)
      builds(name, ',subBuilds[*]').detect { |b| b.number.to_s == id.to_s }
    end

    def job(name, id)
      Hashie::Mash.new(:name => name, :id => id, :console => Jenkins.console(name, id).to_s.gsub(/"\/job\//, '"/'))
    end
  end
end
