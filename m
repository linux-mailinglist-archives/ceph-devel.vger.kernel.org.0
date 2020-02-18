Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4D31627BA
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Feb 2020 15:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgBROKc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Feb 2020 09:10:32 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:43928 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgBROKc (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Feb 2020 09:10:32 -0500
Received: by mail-il1-f196.google.com with SMTP id o13so8522144ilg.10
        for <ceph-devel@vger.kernel.org>; Tue, 18 Feb 2020 06:10:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dlgfgnR9Ncs/EXfm9mOSr2QrnY5OjwFBfzKnzow1lVo=;
        b=BMwlNIi0/PyKbGzTVq4UkNX1TwvjB/cRZ2++R+VrYginHxl78UGVJVtp40jaA1R2EL
         Xkkrjg5CJtUMZp4LF8aaS//5oS5gV4hDG0WCi/JjdFw9/Hf2zV4ELcwmxIylJC7iM5my
         gL7kJrwbZIRRNfaGHglpCPHguwymM0weTFSgzAIA6xE4tqDCjfF+H1MPpgl934ZjkHEB
         TF8y1HWjT+krHmY5tJd2MEHrI2NyIynwabLGKjSmlwNjbO4QYpas3ZPcCdQI3RRM/guY
         HvVDbqkV6wPqIjtaw6LWpu0EeUpma4GiBxhNH9Ps3ZhYK8Gu8IYUEIvTqnV8f/CYKMT8
         vZNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dlgfgnR9Ncs/EXfm9mOSr2QrnY5OjwFBfzKnzow1lVo=;
        b=piOR3yzD0FeFOsnIE04xBFnWU//NNGPDAT9rXkM8NDiO4BGlGwx0oVPs7yGpRCeLu2
         Uev17fbQG0dxK6bG0zVg22TnAGp0M8IJ0fFDAXoJpM1a3tDA482F8gwc/ac1LGbIThqV
         dOY1MRewnsQIQ4p7bfjl2GWqkXK4M1Vr/TclHcdDuqLsHTPEGwr5orWuJyr44VCN0Pwp
         ZhxnByJ0HwX5WcvRoPbdEDiLZxlQkKdquDvJGEAf3X0ApHfYS+Ovx9RAsyEEp8+My8w0
         kTyzyOuXlTL53iP1ei/G60gwPVvCxcLxoF+aUZiKb0y7DhH/hwaPf5cf4bf3Zp1hbZoP
         HD8g==
X-Gm-Message-State: APjAAAWMSpdkYiaYUO6uTYdltBEoTbedZj/AtFzKSiuyD4ffhHdcc33D
        xQpjyn+FRJOQsfMFp9hCcjJ4dT82kh0vXe5EeQE=
X-Google-Smtp-Source: APXvYqwic4knt9UWZL6lbUWTaAlSNCDaJnXGWXWLrUV8hMay23vi0VSw5anp6EBZPQLvIxs6h7ZzvA0not7ZVmTp4Hg=
X-Received: by 2002:a92:ccd0:: with SMTP id u16mr18202164ilq.215.1582035030403;
 Tue, 18 Feb 2020 06:10:30 -0800 (PST)
MIME-Version: 1.0
References: <20200217112806.30738-1-xiubli@redhat.com> <CAOi1vP_bCGoni+tmvVri6Gcv7QRN4+qvHUrrweHLpnTyAzQw=A@mail.gmail.com>
 <cf786dd6-cb6e-1a3a-a57e-04d9525bb4a4@redhat.com> <CAOi1vP9sLLUhuBAP7UZ1Mbjjx4uh0Rt0PwgAuD_qBevQoSOeHA@mail.gmail.com>
 <0637b6ba-b411-6ddd-2703-d0f96a65a796@redhat.com> <53b7ad01ba884004209e86bb028dc628ae0d12db.camel@kernel.org>
In-Reply-To: <53b7ad01ba884004209e86bb028dc628ae0d12db.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 18 Feb 2020 15:10:56 +0100
Message-ID: <CAOi1vP_h=0y7_VFC_BMtNMTMWv1z5RGge0CH+sT0eYkUvND1OA@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix dout logs for null pointers
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 18, 2020 at 2:51 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Mon, 2020-02-17 at 23:42 +0800, Xiubo Li wrote:
> > On 2020/2/17 23:27, Ilya Dryomov wrote:
> > > On Mon, Feb 17, 2020 at 4:02 PM Xiubo Li <xiubli@redhat.com> wrote:
> > > > On 2020/2/17 22:52, Ilya Dryomov wrote:
> > > > > On Mon, Feb 17, 2020 at 12:28 PM <xiubli@redhat.com> wrote:
> > > > > > From: Xiubo Li <xiubli@redhat.com>
> > > > > >
> > > > > > For example, if dentry and inode is NULL, the log will be:
> > > > > > ceph:  lookup result=000000007a1ca695
> > > > > > ceph:  submit_request on 0000000041d5070e for inode 000000007a1ca695
> > > > > >
> > > > > > The will be confusing without checking the corresponding code carefully.
> > > > > >
> > > > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > > > ---
> > > > > >    fs/ceph/dir.c        | 2 +-
> > > > > >    fs/ceph/mds_client.c | 6 +++++-
> > > > > >    2 files changed, 6 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > > > > > index ffeaff5bf211..245a262ec198 100644
> > > > > > --- a/fs/ceph/dir.c
> > > > > > +++ b/fs/ceph/dir.c
> > > > > > @@ -798,7 +798,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
> > > > > >           err = ceph_handle_snapdir(req, dentry, err);
> > > > > >           dentry = ceph_finish_lookup(req, dentry, err);
> > > > > >           ceph_mdsc_put_request(req);  /* will dput(dentry) */
> > > > > > -       dout("lookup result=%p\n", dentry);
> > > > > > +       dout("lookup result=%d\n", err);
> > > > > >           return dentry;
> > > > > >    }
> > > > > >
> > > > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > > > index b6aa357f7c61..e34f159d262b 100644
> > > > > > --- a/fs/ceph/mds_client.c
> > > > > > +++ b/fs/ceph/mds_client.c
> > > > > > @@ -2772,7 +2772,11 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
> > > > > >                   ceph_get_cap_refs(ceph_inode(req->r_old_dentry_dir),
> > > > > >                                     CEPH_CAP_PIN);
> > > > > >
> > > > > > -       dout("submit_request on %p for inode %p\n", req, dir);
> > > > > > +       if (dir)
> > > > > > +               dout("submit_request on %p for inode %p\n", req, dir);
> > > > > > +       else
> > > > > > +               dout("submit_request on %p\n", req);
> > > > > Hi Xiubo,
> > > > >
> > > > > It's been this way for a couple of years now.  There are a lot more
> > > > > douts in libceph, ceph and rbd that are sometimes fed NULL pointers.
> > > > > I don't think replacing them with conditionals is the way forward.
> > > > >
> > > > > I honestly don't know what security concern is addressed by hashing
> > > > > NULL pointers, but that is what we have...  Ultimately, douts are just
> > > > > for developers, and when you find yourself having to chase individual
> > > > > pointers, you usually have a large enough piece of log to figure out
> > > > > what the NULL hash is.
> > > > Hi Ilya
> > > >
> > > > For the ceph_lookup(). The dentry will be NULL(when the directory exists
> > > > or -ENOENT) or ERR_PTR(-errno) in most cases here, it seems for the
> > > > rename case it will be the old dentry returned.
> > > >
> > > > So today I was trying to debug and get some logs from it, the
> > > > 000000007a1ca695 really confused me for a long time before I dig into
> > > > the source code.
> > > I was reacting to ceph_mdsc_submit_request() hunk.  Feel free to tweak
> > > ceph_lookup() or refactor it so that err is not threaded through three
> > > different functions as Jeff suggested.
> >
> > Hi Ilya
> >
> > Oh okay. You are right we can figure out what we need via many other
> > dout logs.
> >
> > I just saw some very confusing logs that the "dentry" in cpeh_lookup()
> > and the "inode" in _submit_ are all 000000007a1ca695, so I addressed
> > them both here.
> >
>
> Since Ilya objected to this patch, I'll drop it from testing for now.
> Please send a v2 that addresses his concerns if you still want this in.

I have submitted a patch to fix printk to not obfuscate NULL and
error pointers and haven't heard any objections yet, so hopefully
this issue will become moot soon.

Thanks,

                Ilya
