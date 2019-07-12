Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCB1366AD5
	for <lists+ceph-devel@lfdr.de>; Fri, 12 Jul 2019 12:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfGLKTq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 12 Jul 2019 06:19:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbfGLKTq (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 12 Jul 2019 06:19:46 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9344E2084B;
        Fri, 12 Jul 2019 10:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562926785;
        bh=F0cz4fD3abdAx2/7z+eGbjfJseymBAyfc3xUnoUceGI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Aq9+ckwligObkja5LPlEvmphSFxW6srqC2/TgVu3cXmgdPktUYUMItmQ7hd3YRkjs
         7YRwzMNQaIcPPpPREWLkj4Yef3YQVh0fEUTJ1CAVYaF1C+T4qb0yIg1hgHvWT7Nah0
         DNKEq2du4C/H4XGgfB6USBcGk/d8eIlGYxRTRmy4=
Message-ID: <fc7ae57664266acdaf66b3d438bb312da38f11bc.camel@kernel.org>
Subject: Re: [PATCH v2 5/5] ceph: handle inlined files in copy_file_range
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Zheng Yan <zyan@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Sage Weil <sage@redhat.com>,
        Luis Henriques <lhenriques@suse.com>
Date:   Fri, 12 Jul 2019 06:19:43 -0400
In-Reply-To: <CAAM7YAk=CWNCFrk7cudTHY4Gt0u_izjsRV8M=uZEOqTd-e2PTA@mail.gmail.com>
References: <20190711184136.19779-1-jlayton@kernel.org>
         <20190711184136.19779-6-jlayton@kernel.org>
         <CAAM7YAk=CWNCFrk7cudTHY4Gt0u_izjsRV8M=uZEOqTd-e2PTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2019-07-12 at 10:46 +0800, Yan, Zheng wrote:
> On Fri, Jul 12, 2019 at 3:17 AM Jeff Layton <jlayton@kernel.org> wrote:
> > If the src is inlined, then just bail out. Have it attempt to uninline
> > the dst file however.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/file.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 252aac44b8ce..774f51b0b63d 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -1934,6 +1934,10 @@ static ssize_t ceph_copy_file_range(struct file *src_file, loff_t src_off,
> >         if (len < src_ci->i_layout.object_size)
> >                 return -EOPNOTSUPP; /* no remote copy will be done */
> > 
> > +       /* Fall back if src file is inlined */
> > +       if (READ_ONCE(src_ci->i_inline_version) != CEPH_INLINE_NONE)
> > +               return -EOPNOTSUPP;
> > +
> >         prealloc_cf = ceph_alloc_cap_flush();
> >         if (!prealloc_cf)
> >                 return -ENOMEM;
> > @@ -1967,6 +1971,13 @@ static ssize_t ceph_copy_file_range(struct file *src_file, loff_t src_off,
> >         if (ret < 0)
> >                 goto out_caps;
> > 
> > +       /* uninline the dst inode */
> > +       dirty = ceph_uninline_data(dst_inode, NULL);
> > +       if (dirty < 0) {
> > +               ret = dirty;
> > +               goto out_caps;
> > +       }
> > +
> >         size = i_size_read(dst_inode);
> >         endoff = dst_off + len;
> > 
> > @@ -2080,7 +2091,7 @@ static ssize_t ceph_copy_file_range(struct file *src_file, loff_t src_off,
> >         /* Mark Fw dirty */
> >         spin_lock(&dst_ci->i_ceph_lock);
> >         dst_ci->i_inline_version = CEPH_INLINE_NONE;
> remove this line
> 

Good catch. Looks like I left another one too in ceph_aio_complete. I'll
remove that one as well.

> > -       dirty = __ceph_mark_dirty_caps(dst_ci, CEPH_CAP_FILE_WR, &prealloc_cf);
> > +       dirty |= __ceph_mark_dirty_caps(dst_ci, CEPH_CAP_FILE_WR, &prealloc_cf);
> >         spin_unlock(&dst_ci->i_ceph_lock);
> >         if (dirty)
> >                 __mark_inode_dirty(dst_inode, dirty);
> > --
> > 2.21.0
> > 

-- 
Jeff Layton <jlayton@kernel.org>

