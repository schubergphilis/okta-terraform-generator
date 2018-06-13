require 'okta-terraform-generator/cli/github_membership'

RSpec.describe OktaTerraformGenerator::CLI::GithubMembership do
  before(:each) do
    # allow(subject).to receive(:github_client).and_return(github_client)
    allow(subject).to receive(:okta_client).and_return(okta_client)
  end

  let(:usage) do
    <<-STDOUT.gsub(/^ {6}/, '')
      Usage: okta-terraform-generator github_membership (options)

      Options:
          -h, --github-token GITHUB_TOKEN  Specifies the GitHub API token (required)
          -a OKTA_GITHUB_ADMIN_GROUP,      Specifies the Okta group containing GitHub admin users (required)
              --okta-github-admin-group
          -e OKTA_ENDPOINT,                Specifies the Okta API endpoint (e.g. https://myorg.okta.com/api/v1) (required)
              --okta-endpoint
          -g OKTA_GITHUB_USER_GROUP,       Specifies the Okta group containing GitHub users (can be a comma separated list) (required)
              --okta-github-user-group
          -t, --okta-token OKTA_TOKEN      Specifies the Okta API token (required)
    STDOUT
  end

  let(:stdout) { StringIO.new }

  subject { described_class.new }

  describe 'when no options given' do
    command 'okta-terraform-generator github_membership', allow_error: true
    its(:stdout) { is_expected.to eq(usage) }
    its(:exitstatus) { is_expected.to eq 1 }
  end

  describe 'when required options are given' do
    let(:argv) do
      ['github_membership',
       '-e', test_okta_endpoint,
       '-h', test_github_token,
       '-t', test_okta_token,
       '-g', test_okta_github_users,
       '-a', test_okta_github_admins]
    end

    let(:expected_resources) do
      {
        'resource' => {
          'github_membership' => {
            'bartsimpson' => {
              'username' => 'bart',
              'role' => 'member'
            },
            'chrisgriffin' => {
              'username' => 'chris',
              'role' =>  'admin'
            },
            'homersimpson' => {
              'username' => 'homer',
              'role' =>  'member'
            },
            'petergriffin' => {
              'username' => 'peter',
              'role' => 'admin'
            }
          }
        }
      }
    end

    it 'prints expected msgs to stdout' do
      VCR.use_cassette 'github_membership' do
        expect(STDOUT).to receive(:puts).with([
          'Looking for active users in Okta group "github_users" (with group id: 00gezhx0w8mt5gjke0h7)',
          'and the "githubHandle" profile attribute set ... '
        ].join(' '))
        expect(STDOUT).to receive(:puts).with("\nWrote generated JSON to github_membership.tf")
        subject.run(argv)
      end
    end

    it 'writes a github_membership.tf file with expected content' do
      VCR.use_cassette 'github_membership' do
        expect(STDOUT).to receive(:puts).with([
          'Looking for active users in Okta group "github_users" (with group id: 00gezhx0w8mt5gjke0h7)',
          'and the "githubHandle" profile attribute set ... '
        ].join(' '))
        expect(subject).to receive(:write_tf_file).with('github_membership.tf', expected_resources)
        subject.run(argv)
      end
    end
  end
  describe 'when valid options given' do
  end
end
