Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F194186E78
	for <lists+ceph-devel@lfdr.de>; Mon, 16 Mar 2020 16:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731594AbgCPP0N (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 Mar 2020 11:26:13 -0400
Received: from mail-qv1-f67.google.com ([209.85.219.67]:36375 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731483AbgCPP0M (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 16 Mar 2020 11:26:12 -0400
Received: by mail-qv1-f67.google.com with SMTP id z13so2885769qvw.3
        for <ceph-devel@vger.kernel.org>; Mon, 16 Mar 2020 08:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Opch2Knk/P2+Z1rztpsF9wm4usulLww3uUyX4IzO9eY=;
        b=tdNgy34x71BAWzygLjhTd90APuS1dHkbrKs/KAfTdaZdNMyaYyIe4j/CqBUjsx4054
         Rx3ipeg0efxPebdBBO8IhGruBj2HUWKwcugFNBPBwLVWuCRyY5PP2+duQ2eWcbh9PK9o
         sIemFHWxUFOu8wfwWG74/7iBkIYmW4WsQZUNEn8eaMVbRqwszvVawLJzT0KrAvOdXNKo
         T6ykwIjI8aFsPclqocrOYLild8aqBZ0CTLhno8ULxiy32WivVgxNT2tSo4MY1dkcSjha
         NfeRt4hp+a7/EpDS039kdukqVaU5pA6AgIJSeG4dZcVOj1w3A3AY0rV9bo7/7lBoPF9u
         CgjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Opch2Knk/P2+Z1rztpsF9wm4usulLww3uUyX4IzO9eY=;
        b=lbr3SKKPVjSA0V4Euu/IqUBSv4U6pBSdKgyT9QBi7LBGvHALpNnUZeo2NOEtzOPa6M
         AwuFkKv/DX268TB+8EmvHVOx95Mhw9n1PEvXxp8ocfOoN8kPoJWn6Ofod9F8v2kuyooj
         pbKp7OitRZVWY/o8U2iTDMuA3z6uN0viI/MLw4GT0Ql1ytBnhHD6DKyFLVeosXe9peJ/
         9jRTyvdEHU/M3DAHt05q6cJn7ik7hQgEA8bnjxr8W/wyxVXHAUV8xCSfOAYmXJ7orbwV
         neqMXdyIf0QyQs5kh88ET405N8hHGf813dzynwCnpZOyrMr2Wx3339wTFjrspV/YR0xO
         EbzQ==
X-Gm-Message-State: ANhLgQ0ZcVa/myiwL2K21cO7IX4zvqdiJZQxdjyFeRMcUQid6S+Bjouh
        gH3y66mS2REQ9/PYfwFnwwOuhmLyHJcQ3SMubL8=
X-Google-Smtp-Source: ADFU+vuPZ+8uatuX9koyfKJIuRVarvK3CzjiN0Ktp/oBgXWJ9+8GqSxkJi+qMUmy7EFqtPhCUj1b+ggGpNWCW5EVqnk=
X-Received: by 2002:a05:6214:188d:: with SMTP id cx13mr368632qvb.50.1584372371418;
 Mon, 16 Mar 2020 08:26:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200310113421.174873-1-zyan@redhat.com> <20200310113421.174873-2-zyan@redhat.com>
 <25eaece7ad299eef0e7418f2b9acce900460baed.camel@kernel.org>
In-Reply-To: <25eaece7ad299eef0e7418f2b9acce900460baed.camel@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Mon, 16 Mar 2020 23:26:00 +0800
Message-ID: <CAAM7YAnmXf4QbfMd4Qv=AhSKisagj118G2zfNubAdcZEjZrTqQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] ceph: cleanup return error of try_get_cap_refs()
To:     Jeff Layton <jlayton@kernel.org>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Mar 16, 2020 at 8:50 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Tue, 2020-03-10 at 19:34 +0800, Yan, Zheng wrote:
> > Returns 0 if caps were not able to be acquired (yet), 1 if succeed,
> > or a negative error code. There are 3 speical error codes:
> >
> > -EAGAIN: need to sleep but non-blocking is specified
> > -EFBIG:  ask caller to call check_max_size() and try again.
> > -ESTALE: ask caller to call ceph_renew_caps() and try again.
> >
> > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> > ---
> >  fs/ceph/caps.c | 25 ++++++++++++++-----------
> >  1 file changed, 14 insertions(+), 11 deletions(-)
> >
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index 342a32c74c64..804f4c65251a 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -2530,10 +2530,11 @@ void ceph_take_cap_refs(struct ceph_inode_info *ci, int got,
> >   * Note that caller is responsible for ensuring max_size increases are
> >   * requested from the MDS.
> >   *
> > - * Returns 0 if caps were not able to be acquired (yet), a 1 if they were,
> > - * or a negative error code.
> > - *
> > - * FIXME: how does a 0 return differ from -EAGAIN?
> > + * Returns 0 if caps were not able to be acquired (yet), 1 if succeed,
> > + * or a negative error code. There are 3 speical error codes:
> > + *  -EAGAIN: need to sleep but non-blocking is specified
> > + *  -EFBIG:  ask caller to call check_max_size() and try again.
> > + *  -ESTALE: ask caller to call ceph_renew_caps() and try again.
> >   */
> >  enum {
> >       /* first 8 bits are reserved for CEPH_FILE_MODE_FOO */
> > @@ -2581,7 +2582,7 @@ static int try_get_cap_refs(struct inode *inode, int need, int want,
> >                       dout("get_cap_refs %p endoff %llu > maxsize %llu\n",
> >                            inode, endoff, ci->i_max_size);
> >                       if (endoff > ci->i_requested_max_size)
> > -                             ret = -EAGAIN;
> > +                             ret = -EFBIG;
> >                       goto out_unlock;
> >               }
> >               /*
> > @@ -2743,7 +2744,10 @@ int ceph_try_get_caps(struct inode *inode, int need, int want,
> >               flags |= NON_BLOCKING;
> >
> >       ret = try_get_cap_refs(inode, need, want, 0, flags, got);
> > -     return ret == -EAGAIN ? 0 : ret;
> > +     /* three special error codes */
> > +     if (ret == -EAGAIN || ret == -EFBIG || ret == -EAGAIN)
> > +             ret = 0;
> > +     return ret;
> >  }
> >
> >  /*
> > @@ -2771,17 +2775,12 @@ int ceph_get_caps(struct file *filp, int need, int want,
> >       flags = get_used_fmode(need | want);
> >
> >       while (true) {
> > -             if (endoff > 0)
> > -                     check_max_size(inode, endoff);
> > -
> >               flags &= CEPH_FILE_MODE_MASK;
> >               if (atomic_read(&fi->num_locks))
> >                       flags |= CHECK_FILELOCK;
> >               _got = 0;
> >               ret = try_get_cap_refs(inode, need, want, endoff,
> >                                      flags, &_got);
> > -             if (ret == -EAGAIN)
> > -                     continue;
>
> Ok, so I guess we don't expect to see this error here since we didn't
> set NON_BLOCKING. The error returns from try_get_cap_refs are pretty
> complex, and I worry a little about future changes subtly breaking some
> of these assumptions.
>
> Maybe a WARN_ON_ONCE(ret == -EAGAIN) here would be good?
>

make sense. Please edit the patch if you don't have other comments.

Regards
Yan, Zheng

> >               if (!ret) {
> >                       struct ceph_mds_client *mdsc = fsc->mdsc;
> >                       struct cap_wait cw;
> > @@ -2829,6 +2828,10 @@ int ceph_get_caps(struct file *filp, int need, int want,
> >               }
> >
> >               if (ret < 0) {
> > +                     if (ret == -EFBIG) {
> > +                             check_max_size(inode, endoff);
> > +                             continue;
> > +                     }
> >                       if (ret == -ESTALE) {
> >                               /* session was killed, try renew caps */
> >                               ret = ceph_renew_caps(inode, flags);
>
> --
> Jeff Layton <jlayton@kernel.org>
>
