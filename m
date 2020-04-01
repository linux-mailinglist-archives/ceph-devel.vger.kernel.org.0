Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF4F19A9EE
	for <lists+ceph-devel@lfdr.de>; Wed,  1 Apr 2020 13:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732169AbgDALEZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 1 Apr 2020 07:04:25 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33707 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732006AbgDALEY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 1 Apr 2020 07:04:24 -0400
Received: by mail-qt1-f195.google.com with SMTP id c14so21235295qtp.0
        for <ceph-devel@vger.kernel.org>; Wed, 01 Apr 2020 04:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EwfvpDjvalOMOz4BGe7+Osf9gny8bWOjc+3TBNkoDCc=;
        b=EADw3moJ5I7Qzm+ilEIzMr/BT2hx3+0/S/B7zyQxA6fSXCVehwApx45CY1xebJqX2C
         oOB2q0TXfDgR0dEOgx1Z76iubVwKROIlHrnaHCKmn3i8c9XSsnA7v4/LOWeOgN771KAU
         36H7CWKsf/NUrlqk/u3wVrwoAtXVaiDYZN8WPfTNirmHw3lmE1dSPhuz47OFzAt+OkFA
         sQBZZrz3e27QFOyUfvHeDNWFzEWtJ8rM1j4KZTyTU0lLVbdWkEBr3SkdUGHMEs+vFStZ
         DYUwggqfi1aERTBcCZKUZTsXAN/l/wTh7au4X3+Sg2uzAf59zhGRv+oYR1DaV1HOwj2K
         OYKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EwfvpDjvalOMOz4BGe7+Osf9gny8bWOjc+3TBNkoDCc=;
        b=ts4A5Mtrb6YYwLYgpwaH9byB80YixA/yTWa72zcdoZVLzpFfifAGpOQ+YBCWFFSyk2
         ecOmrg8phhpmnNPfTQSx6qwfK6PYvZt360f0nxhbmzpHmJ/5Xt7Y6eF02WxZsBiU0KJq
         a2808oknkjkvgNXFVhzkaNitaXWjYIwHe9xcfepCAEFJNGp3qMY19lmwJv8TnG8QmtPL
         mKWFFNNgSjXXYq0+jH5QPUmJScx1BWhKqcUk2fglvgaZmUeLzkINgnHwM2ss28Ufrma5
         oHWuAqg5NeTPvgV6SyD2vGkfcBoK91Bl6YnkA2WWTmx8YP/0viKD7gR6UMQQWRZ+m0jm
         yJuQ==
X-Gm-Message-State: ANhLgQ3Dy0XR7zaBxMWBqr6pCVlHjMCbJ8zUmHbiZCtid5hVVdVtbdAp
        7HeklOJyHmx5Tux9jp2yTMo97vgMdyQN8GQMr6A=
X-Google-Smtp-Source: ADFU+vthzWGlzJlAyYpyqRYGTTRhQcM655KvLxTgx33EVjqxkX3D1diGDf3qJiwdrH6fYUDD0hg+zbPTfoaLtryfJmY=
X-Received: by 2002:ac8:3656:: with SMTP id n22mr9686859qtb.296.1585739064005;
 Wed, 01 Apr 2020 04:04:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200331105223.9610-1-jlayton@kernel.org> <CAAM7YAmzyYrREBtmX+JrEQMMuo9LhZ2J2c-PyahQaAiVVEn2fQ@mail.gmail.com>
 <CAJ4mKGbMgoQ6tgsiQchR2QirxOW_oPOuNo5X26YKpy66yHD+FA@mail.gmail.com> <924ac730ea35f3a10c3828f3b532a2b7642776dc.camel@kernel.org>
In-Reply-To: <924ac730ea35f3a10c3828f3b532a2b7642776dc.camel@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Wed, 1 Apr 2020 19:04:12 +0800
Message-ID: <CAAM7YAmwduzm6kWw7rv62TMgJoZCqstZWOiQTVoP8LhxutHUuw@mail.gmail.com>
Subject: Re: [PATCH] ceph: request expedited service when flushing caps
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Gregory Farnum <gfarnum@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Jan Fajerski <jfajerski@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Mar 31, 2020 at 10:56 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Tue, 2020-03-31 at 07:00 -0700, Gregory Farnum wrote:
> > On Tue, Mar 31, 2020 at 6:49 AM Yan, Zheng <ukernel@gmail.com> wrote:
> > > On Tue, Mar 31, 2020 at 6:52 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > Jan noticed some long stalls when flushing caps using sync() after
> > > > doing small file creates. For instance, running this:
> > > >
> > > >     $ time for i in $(seq -w 11 30); do echo "Hello World" > hello-$i.txt; sync -f ./hello-$i.txt; done
> > > >
> > > > Could take more than 90s in some cases. The sync() will flush out caps,
> > > > but doesn't tell the MDS that it's waiting synchronously on the
> > > > replies.
> > > >
> > > > When ceph_check_caps finds that CHECK_CAPS_FLUSH is set, then set the
> > > > CEPH_CLIENT_CAPS_SYNC bit in the cap update request. This clues the MDS
> > > > into that fact and it can then expedite the reply.
> > > >
> > > > URL: https://tracker.ceph.com/issues/44744
> > > > Reported-and-Tested-by: Jan Fajerski <jfajerski@suse.com>
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >  fs/ceph/caps.c | 7 +++++--
> > > >  1 file changed, 5 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > > index 61808793e0c0..6403178f2376 100644
> > > > --- a/fs/ceph/caps.c
> > > > +++ b/fs/ceph/caps.c
> > > > @@ -2111,8 +2111,11 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
> > > >
> > > >                 mds = cap->mds;  /* remember mds, so we don't repeat */
> > > >
> > > > -               __prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE, 0, cap_used, want,
> > > > -                          retain, flushing, flush_tid, oldest_flush_tid);
> > > > +               __prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE,
> > > > +                          (flags & CHECK_CAPS_FLUSH) ?
> > > > +                           CEPH_CLIENT_CAPS_SYNC : 0,
> > > > +                          cap_used, want, retain, flushing, flush_tid,
> > > > +                          oldest_flush_tid);
> > > >                 spin_unlock(&ci->i_ceph_lock);
> > > >
> > >
> > > this is too expensive for syncfs case. mds needs to flush journal for
> > > each dirty inode.  we'd better to track dirty inodes by session, and
> > > only set the flag when flushing the last inode in session dirty list.
>
> I think this will be more difficult than that...
>
> >
> > Yeah, see the userspace Client::_sync_fs() where we have an internal
> > flags argument which is set on the last cap in the dirty set and tells
> > the actual cap message flushing code to set FLAG_SYNC on the
> > MClientCaps message. I presume the kernel is operating on a similar
> > principle here?
>
> Not today, but we need it to.
>
> The caps are not tracked on a per-session basis (as Zheng points out),
> and the locking and ordering of these requests is not as straightforward
> as it is in the (trivial) libcephfs case. Fixing this will be a lot more
> invasive than I had originally hoped.
>
> It's also not 100% clear to me how we'll gauge which cap will be
> "last".  As we move the last cap on the session's list from dirty to
> flushing state, we can mark it so that it sets the SYNC flag when it
> goes out, but what happens if we have a process that is actively
> dirtying other inodes during this? You might never see the per-session
> list go empty.
>

It's not necessary to be strict 'last'.  just the one before exiting the loop

> It may also go empty for reasons that have nothing to do with issuing a
> sync(), (or fsync() or...) so we don't want to universally set this flag
> in that case.
>
> I'm not sure what the right solution is yet.
> --
> Jeff Layton <jlayton@kernel.org>
>
