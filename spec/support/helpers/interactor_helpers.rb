shared_examples_for 'interactor result error' do |code, message|
  it { is_expected.to be_failure }
  it { expect(subject.error.http_code).to eq(code) }
  it { expect(subject.error.message).to eq(message) }
end
