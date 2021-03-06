describe Hamlit::Engine do
  describe 'silent script' do
    it 'renders silent script' do
      assert_render(<<-HAML, <<-HTML)
        - foo = 3
        - bar = 2
        = foo + bar
      HAML
        5
      HTML
    end

    it 'renders nested block' do
      assert_render(<<-HAML, <<-HTML)
        - 2.times do |i|
          = i
        2
        - 3.upto(4).each do |i|
          = i
      HAML
        0
        1
        2
        3
        4
      HTML
    end

    it 'renders if' do
      assert_render(<<-HAML, <<-HTML)
        - if true
          ok
      HAML
        ok
      HTML
    end

    it 'renders if-else' do
      assert_render(<<-HAML, <<-HTML)
        - if true
          ok
        - else
          ng

        - if false
          ng

        - else
          ok
      HAML
        ok
        ok
      HTML
    end

    it 'renders nested if-else' do
      assert_render(<<-'HAML', <<-HTML)
        %span
          - if false
            ng
          - else
            ok
      HAML
        <span>
        ok
        </span>
      HTML
    end

    it 'accept if inside if-else' do
      assert_render(<<-'HAML', <<-HTML)
        - if false
          - if true
            ng
        - else
          ok
      HAML
        ok
      HTML
    end

    it 'renders if-elsif' do
      assert_render(<<-HAML, <<-HTML)
        - if false
        - elsif true
          ok

        - if false
        - elsif false
        - else
          ok
      HAML
        ok
        ok
      HTML
    end

    it 'renders case-when' do
      assert_render(<<-'HAML', <<-HTML)
        - case 'foo'
        - when /\Ao/
          ng
        - when /\Af/
          ok
        - else
          ng
      HAML
        ok
      HTML
    end

    it 'joins a next line if a current line ends with ","' do
      assert_render("- foo = [',  \n     ']\n= foo", <<-HTML)
        [", "]
      HTML
    end

    it 'accepts illegal indent in continuing code' do
      assert_render(<<-HAML, <<-HTML)
        %span
          %div
            - def foo(a, b); a + b; end
            - num = foo(1,
        2)
            = num
      HAML
        <span>
        <div>
        3
        </div>
        </span>
      HTML
    end
  end
end
