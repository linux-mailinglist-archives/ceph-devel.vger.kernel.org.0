Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFE72501A9
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Aug 2020 18:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgHXQEe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Aug 2020 12:04:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbgHXQDU (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 24 Aug 2020 12:03:20 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D64D222B40;
        Mon, 24 Aug 2020 16:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598285000;
        bh=EgWL8l3383Bd9u83DXOPIdycSZABPcE0URscOEQ0q74=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XAfrjz2rXdRu49k9UuByfidDlh3tY+Ye/tB9YH8zjoUdL6I1mcOZfS+YfUD4xRv0G
         CwXai4NEsJh5Pk0v0dr1J48COIX7+F89pTdB36Rse3yw4+jKqSXFyCBpKRYFAZhgoZ
         i7DRIEtCLIzZHolLJDCUgLWEmJoUwWUnAGZYEm5g=
Message-ID: <17e14441da0f636e3b0b5244a27865645b168297.camel@kernel.org>
Subject: Re: [PATCH] ceph: don't allow setlease on cephfs
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Mon, 24 Aug 2020 12:03:18 -0400
In-Reply-To: <CAOi1vP_i67NVgb_sef1ZS0K_ZHP5J_H=Op+LGs3n5CJbhR_95w@mail.gmail.com>
References: <20200820151349.60203-1-jlayton@kernel.org>
         <CAOi1vP_i67NVgb_sef1ZS0K_ZHP5J_H=Op+LGs3n5CJbhR_95w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-08-24 at 17:38 +0200, Ilya Dryomov wrote:
> On Thu, Aug 20, 2020 at 5:13 PM Jeff Layton <jlayton@kernel.org> wrote:
> > Leases don't currently work correctly on kcephfs, as they are not broken
> > when caps are revoked. They could eventually be implemented similarly to
> > how we did them in libcephfs, but for now don't allow them.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/dir.c  | 2 ++
> >  fs/ceph/file.c | 1 +
> >  2 files changed, 3 insertions(+)
> > 
> > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > index 040eaad9d063..34f669220a8b 100644
> > --- a/fs/ceph/dir.c
> > +++ b/fs/ceph/dir.c
> > @@ -1935,6 +1935,7 @@ const struct file_operations ceph_dir_fops = {
> >         .compat_ioctl = compat_ptr_ioctl,
> >         .fsync = ceph_fsync,
> >         .lock = ceph_lock,
> > +       .setlease = simple_nosetlease,
> >         .flock = ceph_flock,
> >  };
> > 
> > @@ -1943,6 +1944,7 @@ const struct file_operations ceph_snapdir_fops = {
> >         .llseek = ceph_dir_llseek,
> >         .open = ceph_open,
> >         .release = ceph_release,
> > +       .setlease = simple_nosetlease,
> 
> Hi Jeff,
> 
> Isn't this redundant for directories?
> 
> Thanks,
> 
>                 Ilya

generic_setlease does currently return -EINVAL if you try to set it on
anything but a regular file. But, there is nothing that prevents that at
a higher level. A filesystem can implement a ->setlease op that allows
it.

So yeah, that doesn't really have of an effect since you'd likely get
back -EINVAL anyway, but adding this line in it makes that explicit.
-- 
Jeff Layton <jlayton@kernel.org>

