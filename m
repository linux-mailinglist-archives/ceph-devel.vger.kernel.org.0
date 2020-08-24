Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0018B2505DC
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Aug 2020 19:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgHXRWo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Aug 2020 13:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728107AbgHXQft (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Aug 2020 12:35:49 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19366C061573
        for <ceph-devel@vger.kernel.org>; Mon, 24 Aug 2020 09:35:49 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id b16so9335168ioj.4
        for <ceph-devel@vger.kernel.org>; Mon, 24 Aug 2020 09:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mGPeWRtarQNTI7uJjNQ+mYtynoYjyPzIe6pjKZ0jylc=;
        b=MbBjY0wPaqENDun42bSplivBD0/e8Npee+9900CZpxsWRxKtHouRe058RQMqByhHAM
         6ksEpFuOWWIg+XWCeDvzSggS1MaHpOTrX7e166oJG+SJZeN0dU5WCpGROe7aaGty+wfy
         W3oVCvxd93vXmheHe2B7QTCtxvI3/gozEouGTkgVgQaPva5pqWFO/h5cLSjeLzLTxjl4
         itaHaoMUaiCkPMQqzLsg8iClfJf3nn35G4d8sfEEwX1WUQFJB3JBjiIEZUys3E4DG3Gm
         1YvajhFfKrrZ+a3SNckhTzef7OkKUQ1zkoCVYM/LCU0Fo76QEjZ0aurP6tDFsJEQSIjS
         i2HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mGPeWRtarQNTI7uJjNQ+mYtynoYjyPzIe6pjKZ0jylc=;
        b=Rf9BgCxTXXfvf02+I0UIDlfGbjTXkfH+tTyruJUrbyT+HBl0yDYPaoJe0xzcY1+1/k
         /3VK4gOUD5iS2BLIRV0QsHJ6ZAbxX0DFLU3xAW6KYPX75bYt/EK5RO2uLrNHpPGrFSh1
         81rAUdvGcL5n8E5EFFHT9jn0t1vUlAAfQCrUdJPXceWWtYpkpM/ivlwhZxZ96WYsiSJb
         oB4GB0fD1FYX4CzXkIJyp1WcsJd5vl3GBltYykApbLUcUovEzgY6NSWpQEpkv1uhbGcy
         8scabHVRnJ97hMpmrCOVPqVJJ9M/trxAkKSXdiFj89azBAbHLgRyaJ9k0rcqF1repqFu
         i3bg==
X-Gm-Message-State: AOAM532fQ9hvfAEUXCJtwIUq4ithhnu8/mDJerQ4nBcm7m/Z+/JBjGz9
        KToUlhGoMi7LtStn2XSl66Lbht+KnkjNgX3QHEDLLVbqMqJ1Lg==
X-Google-Smtp-Source: ABdhPJyO5wGDkSPM975fu9rCDSYZi1U4gdOIScZurDa8v5sTYgkCfrzETwqLM9KsA7xyA3ILItghjC6LIaCly43TQDI=
X-Received: by 2002:a5e:991a:: with SMTP id t26mr5384261ioj.7.1598286948421;
 Mon, 24 Aug 2020 09:35:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200820151349.60203-1-jlayton@kernel.org> <CAOi1vP_i67NVgb_sef1ZS0K_ZHP5J_H=Op+LGs3n5CJbhR_95w@mail.gmail.com>
 <17e14441da0f636e3b0b5244a27865645b168297.camel@kernel.org>
In-Reply-To: <17e14441da0f636e3b0b5244a27865645b168297.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 24 Aug 2020 18:35:37 +0200
Message-ID: <CAOi1vP-s7RwdndJ9T0=YLNJ+CQMQDgn9ODHKHjxo2foe_rNu=w@mail.gmail.com>
Subject: Re: [PATCH] ceph: don't allow setlease on cephfs
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Aug 24, 2020 at 6:03 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Mon, 2020-08-24 at 17:38 +0200, Ilya Dryomov wrote:
> > On Thu, Aug 20, 2020 at 5:13 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > Leases don't currently work correctly on kcephfs, as they are not broken
> > > when caps are revoked. They could eventually be implemented similarly to
> > > how we did them in libcephfs, but for now don't allow them.
> > >
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/dir.c  | 2 ++
> > >  fs/ceph/file.c | 1 +
> > >  2 files changed, 3 insertions(+)
> > >
> > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > > index 040eaad9d063..34f669220a8b 100644
> > > --- a/fs/ceph/dir.c
> > > +++ b/fs/ceph/dir.c
> > > @@ -1935,6 +1935,7 @@ const struct file_operations ceph_dir_fops = {
> > >         .compat_ioctl = compat_ptr_ioctl,
> > >         .fsync = ceph_fsync,
> > >         .lock = ceph_lock,
> > > +       .setlease = simple_nosetlease,
> > >         .flock = ceph_flock,
> > >  };
> > >
> > > @@ -1943,6 +1944,7 @@ const struct file_operations ceph_snapdir_fops = {
> > >         .llseek = ceph_dir_llseek,
> > >         .open = ceph_open,
> > >         .release = ceph_release,
> > > +       .setlease = simple_nosetlease,
> >
> > Hi Jeff,
> >
> > Isn't this redundant for directories?
> >
> > Thanks,
> >
> >                 Ilya
>
> generic_setlease does currently return -EINVAL if you try to set it on
> anything but a regular file. But, there is nothing that prevents that at
> a higher level. A filesystem can implement a ->setlease op that allows
> it.
>
> So yeah, that doesn't really have of an effect since you'd likely get
> back -EINVAL anyway, but adding this line in it makes that explicit.

It looks like gfs2 and nfs only set simple_nosetlease for file fops,
so it might be more consistent if we did this only for ceph_file_fops
as well.

Thanks,

                Ilya
