# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#https://www.youtube.com/watch?v=A3vDRdfEyKs&feature=youtu.be&t=75
$ ->
  sendFile = (that, file) ->
    data = new FormData
    data.append 'image[image]', file
    $.ajax
      data: data
      type: 'POST'
      url: '/user_images'
      cache: false
      contentType: false
      processData: false
      success: (data) ->
        img = document.createElement('IMG')
        img.src = data.url
        img.setAttribute('imgid', data.image_id)
        $(that).summernote 'insertNode', img
  
  deleteFile = (file_id) ->
    $.ajax
      type: 'DELETE'
      url: '/user_images/' + file_id
      cache: false
      contentType: false
      processData: false
  
  ready = ->
    $('.note-editor.note-frame').remove()
    $('[data-provider="summernote"]').each ->
      $(this).summernote
        height: 300
        callbacks:
          onImageUpload: (files) ->
            img = sendFile(this, files[0])
          onMediaDelete: (target, editor, editable) ->
            image_id = target[0].imgid
            if !!image_id
              deleteFile image_id
            target.remove()

  get_comment = (obj) ->
    return $(obj).closest(".comment")[0]
  get_comment_id = (obj) ->
    return $(obj).closest(".comment")[0].getAttribute('data-id')

  move_comment_reply_box = ->
    console.log("in move_comment_reply_box")
    $("button.reply_to_comment_button").click (e) ->
      #get the comment id through data-id on the button
      comment = get_comment(e.target)
      comment_data_id = comment.getAttribute('data-id')
      #comment_data_id = e.target.getAttribute('data-id')
      #dat = 'div.comment[data-id="' + comment_data_id + '"]'
      #get the comment object using that
      #comment = $(dat)[0]
      #get the moving comment form
      comment_reply = $('div.moving_new_comment')[0]
      #move the comment form to the comment
      comment.after(comment_reply)
      #visibility changes
      if $(comment_reply).hasClass("d-none")
        $(comment_reply).removeClass('d-none')
      #change the form information so that it replys to that comment
      comment_class = $('div.moving_new_comment input#comment_target_class')[0]
      comment_id = $('div.moving_new_comment input#comment_target_id')[0]
      comment_class.value = "Comment"
      comment_id.value = comment_data_id

  update_vote_info = (data, comment) ->
    console.log("in update vt inf")
    console.log(data)
    cu = $(comment).find('.caret-up')[0]
    cuf = $(comment).find('.caret-up-fill')[0]
    cd = $(comment).find('.caret-down')[0]
    cdf = $(comment).find('.caret-down-fill')[0]
    console.log(data['liked'])
    if data['liked'] == true
      console.log("AA")
      $(cu).addClass('d-none')
      $(cuf).removeClass('d-none')
    else
      $(cuf).addClass('d-none')
      $(cu).removeClass('d-none')
    
    if data['liked'] == false
      $(cd).addClass('d-none')
      $(cdf).removeClass('d-none')
    else
      $(cd).removeClass('d-none')
      $(cdf).addClass('d-none')
    
    if data['liked'] == undefined
      $(cdf).addClass('d-none')
      $(cuf).addClass('d-none')
      $(cd).removeClass('d-none')
      $(cu).removeClass('d-none')

    vote_count = $(comment).find('.total_votes')
    console.log("vote count: " + data['vote_count'])
    console.log(vote_count)
    vote_count.html(data['vote_count'])

  set_like_actions = ->
    $(".caret-up, .caret-up-fill").click (e) ->
      comment = get_comment(e.target)
      console.log("Comment")
      console.log(comment)
      comment_id = comment.getAttribute('data-id')
      $.ajax
        type: "PUT"
        url: "/comments/" + comment_id + "/up_vote"
        success: (data) ->
          console.log("upvote suc")
          update_vote_info(data, comment)

    $(".caret-down, .caret-down-fill").click (e) ->
      comment = get_comment(e.target)
      comment_id = comment.getAttribute('data-id')
      $.ajax
        type: "PUT"
        url: "/comments/" + comment_id + "/down_vote"
        success: (data) ->
          console.log("downvote suc")
          update_vote_info(data, comment)

  $(document).on("turbolinks:load", set_like_actions )
  $(document).on("turbolinks:load", ready )
  $(document).on("turbolinks:load", move_comment_reply_box )
