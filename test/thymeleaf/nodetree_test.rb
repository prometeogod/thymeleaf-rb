require_relative '../test_helper'
require 'thymeleaf/nodetree'
# Test for NodeTree class
describe NodeTree do
  before(:each) do
    @node = NodeTree.new('name')
    @child = NodeTree.new('child')
  end

  it 'should create a NodeTree object' do
    assert_equal @node.name, 'name'
    assert_equal @node.attributes, {}
    assert_equal @node.children, []
    assert_nil @node.parent
  end

  it 'should add a child' do
    assert_equal @node.children.count, 0
    @node.add_child(@child)
    assert_equal @node.children.count, 1
    assert_equal @child.parent, @node
  end

  it 'should add new child after child' do
    @node.add_child(@child)
    assert_equal @node.children.last, @child
    child2 = NodeTree.new('child2')
    @child.add_next_sibling(child2)
    assert_equal @node.children.last, child2
    assert_equal child2.parent, @node
    assert_equal @node.children.first, @child
  end

  it 'should add new child before child' do
    @node.add_child(@child)
    assert_equal @node.children.first, @child
    child2 = NodeTree.new('child2')
    @child.add_previous_sibling(child2)
    assert_equal @node.children.first, child2
    assert_equal @node.children.last, @child
  end

  it 'should replace the child with a new one' do
    @node.add_child(@child)
    assert_equal @node.children.first, @child
    assert_equal @node.children.count, 1
    child2 = NodeTree.new('child2')
    @child.replace(child2)
    assert_equal @node.children.first, child2
    assert_equal @node.children.count, 1
  end

  it 'should do a deep clone of the NodeTree object' do
    node_clone = @node.deep_clone
    assert_equal @node.name, node_clone.name
    @node.name = 'new_name'
    assert_equal @node.name, 'new_name'
    refute_equal @node.name, node_clone.name
    refute_equal @node, node_clone
  end

  it 'should return a string in html syntax' do
    @node.add_child(@child)
    html_string = @node.to_html
    assert_equal html_string, '<name><child></child></name>'
  end

  it 'should delete a node from parent' do
    @node.add_child(@child)
    assert_equal @node.children.include?(@child), true
    @child.delete
    assert_equal @node.children.include?(@child), false 
  end


end
