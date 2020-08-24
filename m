Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41511250445
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Aug 2020 19:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgHXRAA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Aug 2020 13:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgHXQ7D (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Aug 2020 12:59:03 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B34C061573
        for <ceph-devel@vger.kernel.org>; Mon, 24 Aug 2020 09:59:03 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id q14so7890703ilm.2
        for <ceph-devel@vger.kernel.org>; Mon, 24 Aug 2020 09:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Z6h1Pu7PVgt+PsqXoMhGbeK0pf2RDFJz/Q2ucKj2VE=;
        b=cpL2mPwJCxeA8PF3+K55XdeXYhzkWXb+xHRCsoA/vxKbRvoru8XnQ7bQzUcIkrs6qp
         019Djttlw1LHwWgoraIWnet9G3nI8VXrja8PkcSsCQ0wj6gub15fN0fI7Niz4Vv4r9ra
         30joFhRXyrJOebQqck2J5k6sFXNqUTMo3+3KT4zSvA5Gq7hIORQ3qkmzg+ratgGrcUue
         ZOGDWE7XeZIk6h5+myOoRmPoHwoaKTLOdSOYL+xT3ZxuT0RQ0v4KQ82wUwJ0TCQGh0H7
         E6E39zGQ0tEYzQHJ2pXTfFE8v5yUBsOZly+xn7v89LrjpoBLtaPiLMvJAvXgVPr3zIRT
         Td+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Z6h1Pu7PVgt+PsqXoMhGbeK0pf2RDFJz/Q2ucKj2VE=;
        b=PAfuA2q0l5b3X3Cll+xfUfLleAVoieIFnMl4/FuzV3Ski1FSdf1HvmxyYLUc0lbFgH
         6AV5aKfjRgOLwmlI5Jk4EriEUWf8FcfYonROASBjj+8PJNxYb6Tap1SA9EyXteakplbM
         8Y9kUg5h0OSSS7oOZk/hF1aEZsusUA5ZlF4nZKii6bUph25VQZ7SUC8YMCagv/DYQ7HX
         t/o4ruc0PH0HfYkpaX4MwYcJNrAzRGPm2DkgsK7K22LO4QhGl5PZglMtoy+lXM1IxJlP
         A2qvyVv0opfVzICue0Z4wgXtt9qb9Bip5sO40p+KDiK7DAZDpiY7N5KgNDx18qqt562p
         rE+w==
X-Gm-Message-State: AOAM53140gLR6Y5/jhYwU0OsbpBE4P7IEZMJD5NZo7mkkFBIlL9ZBOdI
        FDjNjYcPo2eOq1RdLHaGAX6t3Ne/hNLU50ZpAJXaTcn/uASyNA==
X-Google-Smtp-Source: ABdhPJzBQ+xOHzZ2M3fXg+crJEVMaIyvzwEz62xs0cKBCv/oj0AKhhWaD4yFAsArfHbZo5D4FombYo7BCGu+NVnS37k=
X-Received: by 2002:a92:b712:: with SMTP id k18mr5578401ili.220.1598288342554;
 Mon, 24 Aug 2020 09:59:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200820151349.60203-1-jlayton@kernel.org> <CAOi1vP_i67NVgb_sef1ZS0K_ZHP5J_H=Op+LGs3n5CJbhR_95w@mail.gmail.com>
 <17e14441da0f636e3b0b5244a27865645b168297.camel@kernel.org>
 <CAOi1vP-s7RwdndJ9T0=YLNJ+CQMQDgn9ODHKHjxo2foe_rNu=w@mail.gmail.com> <1d1f9e52634ca43ac018935fcfa0ac8c5fe57bfe.camel@kernel.org>
In-Reply-To: <1d1f9e52634ca43ac018935fcfa0ac8c5fe57bfe.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 24 Aug 2020 18:58:51 +0200
Message-ID: <CAOi1vP9_KP=3quGL9NJ=1DB=68AtGudB5B6451a-D48jU21FhA@mail.gmail.com>
Subject: Re: [PATCH] ceph: don't allow setlease on cephfs
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Aug 24, 2020 at 6:37 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Mon, 2020-08-24 at 18:35 +0200, Ilya Dryomov wrote:
> > On Mon, Aug 24, 2020 at 6:03 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > On Mon, 2020-08-24 at 17:38 +0200, Ilya Dryomov wrote:
> > > > On Thu, Aug 20, 2020 at 5:13 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > > Leases don't currently work correctly on kcephfs, as they are not broken
> > > > > when caps are revoked. They could eventually be implemented similarly to
> > > > > how we did them in libcephfs, but for now don't allow them.
> > > > >
> > > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > > ---
> > > > >  fs/ceph/dir.c  | 2 ++
> > > > >  fs/ceph/file.c | 1 +
> > > > >  2 files changed, 3 insertions(+)
> > > > >
> > > > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > > > > index 040eaad9d063..34f669220a8b 100644
> > > > > --- a/fs/ceph/dir.c
> > > > > +++ b/fs/ceph/dir.c
> > > > > @@ -1935,6 +1935,7 @@ const struct file_operations ceph_dir_fops = {
> > > > >         .compat_ioctl = compat_ptr_ioctl,
> > > > >         .fsync = ceph_fsync,
> > > > >         .lock = ceph_lock,
> > > > > +       .setlease = simple_nosetlease,
> > > > >         .flock = ceph_flock,
> > > > >  };
> > > > >
> > > > > @@ -1943,6 +1944,7 @@ const struct file_operations ceph_snapdir_fops = {
> > > > >         .llseek = ceph_dir_llseek,
> > > > >         .open = ceph_open,
> > > > >         .release = ceph_release,
> > > > > +       .setlease = simple_nosetlease,
> > > >
> > > > Hi Jeff,
> > > >
> > > > Isn't this redundant for directories?
> > > >
> > > > Thanks,
> > > >
> > > >                 Ilya
> > >
> > > generic_setlease does currently return -EINVAL if you try to set it on
> > > anything but a regular file. But, there is nothing that prevents that at
> > > a higher level. A filesystem can implement a ->setlease op that allows
> > > it.
> > >
> > > So yeah, that doesn't really have of an effect since you'd likely get
> > > back -EINVAL anyway, but adding this line in it makes that explicit.
> >
> > It looks like gfs2 and nfs only set simple_nosetlease for file fops,
> > so it might be more consistent if we did this only for ceph_file_fops
> > as well.
> >
>
> Fair enough. Do you want to just fix it up, or would you rather I send a v2?

I'll fix it up.

Thanks,

                Ilya
