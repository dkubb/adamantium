# encoding: utf-8

begin
  require 'spec/rake/spectask'

  desc 'Run all specs'
  task :spec => %w[ spec:unit spec:integration ]

  namespace :spec do
    Spec::Rake::SpecTask.new(:integration) do |t|
      t.ruby_opts = %w[ -r./spec/support/config_alias ]
      t.pattern   = 'spec/integration/**/*_spec.rb'
    end

    Spec::Rake::SpecTask.new(:unit) do |t|
      t.ruby_opts = %w[ -r./spec/support/config_alias ]
      t.pattern   = 'spec/unit/**/*_spec.rb'
    end
  end
rescue LoadError
  task :spec do
    abort 'rspec is not available. In order to run spec, you must: gem install rspec'
  end
end

begin
  if RUBY_VERSION < '1.9'
    desc 'Generate code coverage'
    Spec::Rake::SpecTask.new(:coverage) do |t|
      t.rcov      = true
      t.pattern   = 'spec/unit/**/*_spec.rb'
      t.rcov_opts = File.read('spec/rcov.opts').split(/\s+/)
    end
  else
    desc 'Generate code coverage'
    task :coverage do
      ENV['COVERAGE'] = 'true'
      Rake::Task['spec:unit'].execute
    end
  end
rescue LoadError
  task :coverage do
    lib = RUBY_VERSION < '1.9' ? 'rcov' : 'simplecov'
    abort "coverage is not available. In order to run #{lib}, you must: gem install #{lib}"
  end
end

task :test => 'spec'
