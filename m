Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740FA1A6919
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Apr 2020 17:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730776AbgDMPsW (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Apr 2020 11:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728194AbgDMPsV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Apr 2020 11:48:21 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A64C0A3BDC
        for <ceph-devel@vger.kernel.org>; Mon, 13 Apr 2020 08:48:21 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id t11so8903466ils.1
        for <ceph-devel@vger.kernel.org>; Mon, 13 Apr 2020 08:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3vBn6G8c95Trad7eRgJnnUxaffJq+xULAJX8GodKw0U=;
        b=rDoOuPXq3YEll5Be5/biTr6xGBnlG69I0p5TqJD8LH0aH21EgLNpNM2REQN3JurqTj
         s5fF43PQQC/wxrH8FuOdb/op7PYhQnSpzi+2QlucZXNKGYDssohJ4zZDrzLNsHuAGERf
         ayjjkK68MUxKTw3CUmLAHC0fvh70IMhr76Aeog8P2Mbr4tSAQ+iBV1v7+0gv3/G7cqDR
         6PyYqSbVXdbDg2ITiV6w+KmMLGv19q61NynKP1aQnsNrVr86K+3EUK/gRWNd2m7KIz4a
         nEQLD1DgUPMBnqmoZSZEe3xeoXyLrTBziBswOqdDR27ejC2h8rnUWbLrRwVsOW6ZD17v
         aBLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3vBn6G8c95Trad7eRgJnnUxaffJq+xULAJX8GodKw0U=;
        b=S99WEN6kFzKPCWYAm/WjD5sevmx1GayGmB2MHQv2CH0l/Kcf7V1FccpB8Fpfl/ZAwV
         /oJqeg0VcVTfwlL29yLGdkhSF7jTeAow06YySfOY1QY4Sm/50OTrJ+8QZDT70GJsbYys
         /0Em5LEm64LlOOfapREfzJxEcEXLHJc574cRiw084fWmn0VLYuPsajW3+KWM9U9Ko6v0
         M1J7e5obIUp08LJyViqcbGWZ4/ejS7BUz7tHXns9zXMCMoxnl9mGE5/ndndCAvo3NFFS
         ZFKDFBPRvSLQzQOMg8wAItd8M6MIoYhdo71yWvoA1XW3HpxUOx5MAfaFgNxv6vhhYxEd
         FlaQ==
X-Gm-Message-State: AGi0PuYq28qKT5WL1Ry8as0DbQ2rb40V9v+CrXuZS4GeCXSJyZN9CEeL
        ebK5mwEnzJCj+i6zP0PSLpQGGVVR2ivzKqGNzq0=
X-Google-Smtp-Source: APiQypJ+YO9v6jhsVwhnp0Hk25XpdRfa84jh2SHFLt6x4JNlhGOFuXfUAWcrU1XH5axtrx2eySmnoxCercgZrvFTPpA=
X-Received: by 2002:a92:520a:: with SMTP id g10mr13497055ilb.282.1586792900427;
 Mon, 13 Apr 2020 08:48:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200408142125.52908-1-jlayton@kernel.org> <20200408142125.52908-2-jlayton@kernel.org>
 <CAOi1vP99BbHFrrg+0HAbZrZV7DQ7EG7euTY6cbtdWajsdyN3jQ@mail.gmail.com>
 <ded1b71dcda70e3a249df21c294607dac6545694.camel@kernel.org>
 <CAOi1vP9mZTShECrVVohuj4p=Yr+rWvWnXNY03c85CuO4fGNSyQ@mail.gmail.com> <55c47d66b579fcf5749376c73d681d0273095f6d.camel@kernel.org>
In-Reply-To: <55c47d66b579fcf5749376c73d681d0273095f6d.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 13 Apr 2020 17:48:13 +0200
Message-ID: <CAOi1vP_xUUUPQd=x9rg9KgEz85SHy-9Yurcmvt2iehfhi5ztNQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ceph: have ceph_mdsc_free_path ignore ERR_PTR values
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sage Weil <sage@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Apr 13, 2020 at 3:23 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Mon, 2020-04-13 at 14:35 +0200, Ilya Dryomov wrote:
> > On Mon, Apr 13, 2020 at 1:15 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > On Mon, 2020-04-13 at 10:09 +0200, Ilya Dryomov wrote:
> > > > On Wed, Apr 8, 2020 at 4:21 PM Jeff Layton <jlayton@kernel.org> wrote:
> > > > > This makes the error handling simpler in some callers, and fixes a
> > > > > couple of bugs in the new async dirops callback code.
> > > > >
> > > > > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > > ---
> > > > >  fs/ceph/debugfs.c    | 4 ----
> > > > >  fs/ceph/mds_client.c | 6 ++----
> > > > >  fs/ceph/mds_client.h | 2 +-
> > > > >  3 files changed, 3 insertions(+), 9 deletions(-)
> > > > >
> > > > > diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> > > > > index eebbce7c3b0c..3a198e40f100 100644
> > > > > --- a/fs/ceph/debugfs.c
> > > > > +++ b/fs/ceph/debugfs.c
> > > > > @@ -83,8 +83,6 @@ static int mdsc_show(struct seq_file *s, void *p)
> > > > >                 } else if (req->r_dentry) {
> > > > >                         path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
> > > > >                                                     &pathbase, 0);
> > > > > -                       if (IS_ERR(path))
> > > > > -                               path = NULL;
> > > > >                         spin_lock(&req->r_dentry->d_lock);
> > > > >                         seq_printf(s, " #%llx/%pd (%s)",
> > > >
> > > > Hi Jeff,
> > > >
> > > > This ends up attempting to print an IS_ERR pointer as %s.
> > > >
> > > > >                                    ceph_ino(d_inode(req->r_dentry->d_parent)),
> > > > > @@ -102,8 +100,6 @@ static int mdsc_show(struct seq_file *s, void *p)
> > > > >                 if (req->r_old_dentry) {
> > > > >                         path = ceph_mdsc_build_path(req->r_old_dentry, &pathlen,
> > > > >                                                     &pathbase, 0);
> > > > > -                       if (IS_ERR(path))
> > > > > -                               path = NULL;
> > > > >                         spin_lock(&req->r_old_dentry->d_lock);
> > > > >                         seq_printf(s, " #%llx/%pd (%s)",
> > > >
> > > > Ditto.
> > > >
> > > > It looks like in newer kernels printf copes with this and outputs
> > > > "(efault)".  But anything older than 5.2 will crash.
> > > >
> > > > Further, the code looks weird because ceph_mdsc_build_path() doesn't
> > > > return NULL, but path is tested for NULL in the call to seq_printf().
> > > >
> > > > Why not just follow the same approach as existing mdsc_show()?  It
> > > > makes it clear that the error is handled and where the NULL pointer
> > > > comes from.  This kind of "don't handle errors and rely on everything
> > > > else being able to bail" approach is very fragile and hard to audit.
> > > >
> > >
> > > I don't see a problem with having a "free" routine ignore IS_ERR values
> > > just like it does NULL values. How about I just trim off the other
> > > deltas in this patch? Something like this?
> >
> > I think it encourages fragile code.  Less so than functions that
> > return pointer, NULL or IS_ERR pointer, but still.  You yourself
> > almost fell into one of these traps while editing debugfs.c ;)
> >
>
> We'll have to agree to disagree here. Having a free routine ignore
> ERR_PTR values seems perfectly reasonable to me.
>
> > That said, I won't stand in the way here.  If you trim off everything
> > else, merge it together with the other patch so that it is introduced
> > along with the two users.
> >
>
> Do you mean that I should merge it with this?
>
>     ceph: initialize base and pathlen variables in async dirops cb's
>
> I'm not sure I see the point in that.

Yes, because ultimately this is all about those two pr_warn messages.
path is built just to be printed, base and pathlen are a part of that.
ceph_mdsc_free_path() didn't need to handle IS_ERR pointers before so
it should be a single patch.

Thanks,

                Ilya
