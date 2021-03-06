describe Hamlit::Engine do
  describe 'old attributes' do
    it 'renders attributes' do
      assert_render(<<-HAML, <<-HTML)
        %span{class: 'foo'} bar
      HAML
        <span class='foo'>bar</span>
      HTML
    end

    it 'renders attributes' do
      assert_render(<<-HAML, <<-HTML)
        %span{ data: 2 } bar
      HAML
        <span data='2'>bar</span>
      HTML
    end

    it 'renders attributes' do
      assert_render(<<-'HAML', <<-HTML)
        %span{ :class => 'foo' } bar
      HAML
        <span class='foo'>bar</span>
      HTML
    end

    it 'renders attributes' do
      assert_render(<<-'HAML', <<-HTML)
        %span{ :class => 'foo', id: 'bar' } bar
      HAML
        <span class='foo' id='bar'>bar</span>
      HTML
    end

    it 'renders attributes' do
      assert_render(<<-'HAML', <<-HTML)
        %span{ :'data-disable' => true } bar
      HAML
        <span data-disable>bar</span>
      HTML
    end

    it 'renders false or nil attributes' do
      assert_render(<<-'HAML', <<-HTML)
        - hash = { checked: false }
        %input{ hash }
        %input{ checked: false }
        %input{ checked: nil }
      HAML
        <input>
        <input>
        <input>
      HTML
    end

    it 'accepts even illegal input for haml' do
      assert_render(<<-'HAML', <<-HTML)
        %span{ class: '}}}', id: '{}}' } }{
      HAML
        <span class='}}}' id='{}}'>}{</span>
      HTML
    end

    it 'accepts method call including comma' do
      assert_render(<<-'HAML', <<-HTML)
        %body{ class: "#{"ab".gsub(/a/, 'b')}", data: { confirm: 'really?', disable: true }, id: 'c'.gsub(/c/, 'a') }
      HAML
        <body class='bb' data-confirm='really?' data-disable id='a'></body>
      HTML
    end

    it 'renders runtime hash attribute' do
      assert_render(<<-'HAML', <<-HTML)
        - hash = { foo: 'bar' }
        %span{ hash }
      HAML
        <span foo='bar'></span>
      HTML
    end

    it 'renders runtime hash attribute escaping only value' do
      assert_render(<<-'HAML', <<-HTML)
        - hash = { "'<foo>'" => '<bar>' }
        %span{ hash }
      HAML
        <span '<foo>'='&lt;bar&gt;'></span>
      HTML
    end

    describe 'nested attributes' do
      it 'renders true attributes' do
        assert_render(<<-'HAML', <<-HTML)
          %span{ data: { disable: true } } bar
        HAML
          <span data-disable>bar</span>
        HTML
      end

      it 'renders nested hash whose value is variable' do
        assert_render(<<-'HAML', <<-HTML)
          - hash = { disable: true }
          %span{ data: hash } bar
        HAML
          <span data-disable>bar</span>
        HTML
      end

      it 'changes an underscore in a nested key to a hyphen' do
        assert_render(<<-'HAML', <<-HTML)
          %div{ data: { raw_src: 'foo' } }
        HAML
          <div data-raw-src='foo'></div>
        HTML
      end

      it 'changes an underscore in a nested dynamic attribute' do
        assert_render(<<-'HAML', <<-HTML)
          - hash = { raw_src: 'foo' }
          %div{ data: hash }
        HAML
          <div data-raw-src='foo'></div>
        HTML
      end
    end

    describe 'element class with attributes class' do
      it 'does not generate double classes' do
        assert_render(<<-HAML, <<-HTML)
          .item{ class: 'first' }
        HAML
          <div class='first item'></div>
        HTML
      end

      it 'does not generate double classes for a variable' do
        assert_render(<<-HAML, <<-HTML)
          - val = 'val'
          .element{ class: val }
        HAML
          <div class='element val'></div>
        HTML
      end
    end
  end
end
