Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08CF05E4EE
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Jul 2019 15:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfGCNMj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Jul 2019 09:12:39 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35605 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCNMj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Jul 2019 09:12:39 -0400
Received: by mail-io1-f67.google.com with SMTP id m24so4656870ioo.2
        for <ceph-devel@vger.kernel.org>; Wed, 03 Jul 2019 06:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uuS5Pytt+4DGhdezCjpMU4zuTr3NA/B4AiKnsX4VEyk=;
        b=qbqSE6TDH2Z1mlDrHlNrW59o7TL1muFJWuucQuzka57vgFUyDJzeN+C9Dsh5pmuFAP
         PXeIZ8pWPZsJpjjUMfhVESbux4l6ugOVsla2esQnMYxyDMC4JFd9U0jvZazgPwT8CNGq
         LqpJkjO1HIKRFTwa9ipRanrNJxq5M/XNWZGI1Nn6xX4GU7eKZ23xOj9wwkBD91RbLlDq
         LAsDyhJ4MuFYKxdMRt0bTKlKRxvGH9bpDybuRTj1wSvtplz9MptwSNG6gMwC5CqGSCf7
         R8xijjj4kKMXZo820WzEc6WYOS64ZcIUHwo+X5YcY2f/QiSloS4L4C06ERlpXT+9tptk
         bhwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uuS5Pytt+4DGhdezCjpMU4zuTr3NA/B4AiKnsX4VEyk=;
        b=gIPUIWzP8r1GCU2Q9oAAB8CTZNkB9AK4NplpKNqhlbtXxN6xf+eciy1Tvr68V4a5zP
         +wbzvIaax8FuiWwaldfAMMJJ7G2mvjcLthPdK0vvW1ajBYuzL9/5fpykYO3Igxdpxnsx
         aDxxY0r9KkTc9ZyXmZ+Z68Uic7o+HR2InHiA4pvt19JY122ByU8iaB12GhoNK5KFjEQF
         WsHcvoQMpPSCdQeQXowmF/t64zVZHE/LWf75rs5LvmJJWPUi1goGyKTT7QGdxLzUqph0
         +iwiL3UV8Jl6Xz1b0VuHBf0s+86TUBPKDTmDIHtyn9t3A9f2Qs3FHkiqxAYsZq9kvIOw
         en6A==
X-Gm-Message-State: APjAAAX4qZUbAWjXT4nX714kGh2O9ds/0iGgMYebq6WM1zivENk8dGHs
        88tkoWddHzZbq9c0yiVmL7WEIkrr74woBvRZj1M=
X-Google-Smtp-Source: APXvYqwrPFNujVY0ir4RInCn66s8DwqdA9CmDNQcNlqJ9DMjhIXQNKJ1ALtzYgFlBND2zaCKZnSSEOVrTJDith1A+IU=
X-Received: by 2002:a02:c778:: with SMTP id k24mr914844jao.144.1562159558640;
 Wed, 03 Jul 2019 06:12:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190625144111.11270-1-idryomov@gmail.com> <20190625144111.11270-20-idryomov@gmail.com>
 <CA+aFP1BYABF13KgHxqnHOptrXBBeNU-ZL5D9=bapc1YwtmNkUw@mail.gmail.com>
 <5D1AF635.7050705@easystack.cn> <CA+aFP1C3ms7tK31QDcEH2+emEPvX_JBOjUJKAahALv+UBRA3CQ@mail.gmail.com>
In-Reply-To: <CA+aFP1C3ms7tK31QDcEH2+emEPvX_JBOjUJKAahALv+UBRA3CQ@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 3 Jul 2019 15:15:18 +0200
Message-ID: <CAOi1vP-O9xB+qagucUdO7yFX7cXd8iQ-OhWN0GiVJnyGiwxWVQ@mail.gmail.com>
Subject: Re: [PATCH 19/20] rbd: support for object-map and fast-diff
To:     Jason Dillaman <dillaman@redhat.com>
Cc:     Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jul 2, 2019 at 1:55 PM Jason Dillaman <jdillama@redhat.com> wrote:
>
> On Tue, Jul 2, 2019 at 2:16 AM Dongsheng Yang
> <dongsheng.yang@easystack.cn> wrote:
> >
> > Hi Jason,
> >
> > On 07/02/2019 12:09 AM, Jason Dillaman wrote:
> > > On Tue, Jun 25, 2019 at 10:42 AM Ilya Dryomov <idryomov@gmail.com> wrote:
> > >> Speed up reads, discards and zeroouts through RBD_OBJ_FLAG_MAY_EXIST
> > >> and RBD_OBJ_FLAG_NOOP_FOR_NONEXISTENT based on object map.
> > >>
> > >> Invalid object maps are not trusted, but still updated.  Note that we
> > >> never iterate, resize or invalidate object maps.  If object-map feature
> > >> is enabled but object map fails to load, we just fail the requester
> > >> (either "rbd map" or I/O, by way of post-acquire action).
> > ... ...
> > >> +}
> > >> +
> > >> +static int rbd_object_map_open(struct rbd_device *rbd_dev)
> > >> +{
> > >> +       int ret;
> > >> +
> > >> +       ret = rbd_object_map_lock(rbd_dev);
> > > Only lock/unlock if rbd_dev->spec.snap_id == CEPH_NOSNAP?
> >
> > Hmm, IIUC, rbd_object_map_open() is called in post exclusive-lock
> > acquired, when
> > rbd_dev->spec.snap_id != CEPH_NOSNAP, we don't need to acquire
> > exclusive-lock I think.
>
> Userspace opens the object-map for snapshots (and therefore parent
> images) are well. It doesn't require the exclusive-lock since the
> images should be immutable at the snapshot.
>
> > But maybe we can add an assert in this function to make it clear.
> > >
> > >> +       if (ret)
> > >> +               return ret;
> > >> +
> > >> +       ret = rbd_object_map_load(rbd_dev);
> > >> +       if (ret) {
> > >> +               rbd_object_map_unlock(rbd_dev);
> > >> +               return ret;
> > >> +       }
> > >> +
> > >> +       return 0;
> > >> +}
> > >> +
> > >> +static void rbd_object_map_close(struct rbd_device *rbd_dev)
> > >> +{
> > >> +       rbd_object_map_free(rbd_dev);
> > >> +       rbd_object_map_unlock(rbd_dev);
> > >> +}
> > >> +
> > >> +/*
> > >> + * This function needs snap_id (or more precisely just something to
> > >> + * distinguish between HEAD and snapshot object maps), new_state and
> > >> + * current_state that were passed to rbd_object_map_update().
> > >> + *
> > >> + * To avoid allocating and stashing a context we piggyback on the OSD
> > >> + * request.  A HEAD update has two ops (assert_locked).  For new_state
> > >> + * and current_state we decode our own object_map_update op, encoded in
> > >> + * rbd_cls_object_map_update().
> > > Decoding the OSD request seems a little awkward. Since you would only
> > > update the in-memory state for the HEAD revision, could you just stash
> > > these fields in the "rbd_object_request" struct? Then in
> > > "rbd_object_map_update", set the callback to either a
> > > "rbd_object_map_snapshot_callback" callback or
> > > "rbd_object_map_head_callback".
> >
> > Good idea, even we don't need two callback, because the
> > rbd_object_map_update_finish() will not update snapshot:
>
> The deep-flatten feature requires updating object-map snapshots for
> the child image during copy-up. There just isn't an in-memory version
> of the object-map for that case, if that is what you are refering to.
>
> > +    /*
> > +     * Nothing to do for a snapshot object map.
> > +     */
> > +    if (osd_req->r_num_ops == 1)
> > +        return 0;
> > >> + */
> > >> +static int rbd_object_map_update_finish(struct rbd_obj_request *obj_req,
> > >> +                                       struct ceph_osd_request *osd_req)
> > >> +{
> > >> +       struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
> > >> +       struct ceph_osd_data *osd_data;
> > >> +       u64 objno;
> > >> +       u8 state, new_state, current_state;
> > >> +       bool has_current_state;
> > >> +       void *p;
> > ... ...
> > >>
> > >> +/*
> > >> + * Return:
> > >> + *   0 - object map update sent
> > >> + *   1 - object map update isn't needed
> > >> + *  <0 - error
> > >> + */
> > >> +static int rbd_obj_write_post_object_map(struct rbd_obj_request *obj_req)
> > >> +{
> > >> +       struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
> > >> +       u8 current_state = OBJECT_PENDING;
> > >> +
> > >> +       if (!(rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP))
> > >> +               return 1;
> > >> +
> > >> +       if (!(obj_req->flags & RBD_OBJ_FLAG_DELETION))
> > >> +               return 1;
> > >> +
> > >> +       return rbd_object_map_update(obj_req, CEPH_NOSNAP, OBJECT_NONEXISTENT,
> > >> +                                    &current_state);
> > >> +}
> > >> +
> > >>   static bool rbd_obj_advance_write(struct rbd_obj_request *obj_req, int *result)
> > >>   {
> > >>          struct rbd_device *rbd_dev = obj_req->img_request->rbd_dev;
> > >> @@ -2805,6 +3419,24 @@ static bool rbd_obj_advance_write(struct rbd_obj_request *obj_req, int *result)
> > >>          case RBD_OBJ_WRITE_START:
> > >>                  rbd_assert(!*result);
> > >>
> > >> +               if (rbd_obj_write_is_noop(obj_req))
> > >> +                       return true;
> > > Does this properly handle the case where it has a parent overlap? If
> > > the child object doesn't exist, we would still want to perform the
> > > copyup (if required), correct?
> >
> > Good point. I found the zeroout case is handled, but discard not.
> >
> > zeroout will check  (!obj_req->num_img_extents) before setting NOOP
> > flag. but discard check it after setting.

We never perform the copyup for discard because, unlike in librbd,
discard and zeroout are two different operations.

num_img_extents is checked just to pick between delete and truncate.
If there is overlap, delete is a bad choice because it would expose
parent data, effectively going back in time.  While technically a read
from a discarded region is allowed to return _anything_, zeros is what
many people expect, so we truncate instead of deleting in this case.

Thanks,

                Ilya
