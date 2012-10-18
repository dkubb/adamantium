shared_examples_for 'memoizes method' do

  it 'creates method with zero arity' do
    subject
    object.instance_method(method).arity.should be(0)
  end

  it 'memoizes the instance method' do
    subject
    instance = object.new
    instance.send(method).should equal(instance.send(method))
  end

  specification = proc do
    subject
    file, line = object.new.send(method).first.split(':')[0, 2]
    File.expand_path(file).should eql(File.expand_path('../../../lib/adamantium.rb', __FILE__))
    line.to_i.should be(247)
  end

  it 'sets the file and line number properly' do
    if RUBY_PLATFORM.include?('java')
      pending('Kernel#caller returns the incorrect line number in JRuby', &specification)
    else
      instance_eval(&specification)
    end
  end

  context 'when the initializer calls the memoized method' do
    before do
      method = self.method
      object.send(:define_method, :initialize) { send(method) }
    end

    it 'allows the memoized method to be called within the initializer' do
      subject
      expect { object.new }.to_not raise_error(NoMethodError)
    end

    it 'memoizes the methdod inside the initializer' do
      subject
      object.new.memoized(method).should_not be_nil
    end
  end
end


shared_examples_for 'idempotens method' do
  it_should_behave_like 'memoizes method'

  it 'creates a method that returns a frozen value' do
    subject
    object.new.send(method).should be_frozen
  end
end
