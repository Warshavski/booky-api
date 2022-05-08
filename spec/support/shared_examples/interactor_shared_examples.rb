shared_examples_for 'interactor result error' do |message|
  it 'is expected to fail with error' do
    is_expected.to be_failure
    expect(subject.errors).to eq(code)
    expect(subject.errors).to eq(message)
  end
end
