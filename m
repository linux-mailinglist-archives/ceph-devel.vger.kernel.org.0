Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 426E871597
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Jul 2019 12:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfGWKAL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Jul 2019 06:00:11 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44981 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfGWKAL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 23 Jul 2019 06:00:11 -0400
Received: by mail-io1-f66.google.com with SMTP id s7so80419213iob.11;
        Tue, 23 Jul 2019 03:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yRd2vWX6PjNWErbTd9Y15sIa044i0uHH/q4p9H5/fi4=;
        b=vVi/DRqBsj29Ez902sLsvEs2zFpgpQvo802HHGufSwSOhqoxLyq1sy2+99AYGHj5To
         ZwxTxrlbjFnQl5q95LxS3wuFF87TS7tWgj4328oi60PGyWH7l6CEwnO+xjnEQGvZCSzi
         AS/p+P39qQOjA11t0zEBTK0KV7Tppgk0KcEXqD7lth+pcxdJfN9iaeLPPfQlsE5Cxkzg
         J1VikUYHWX0CpMcq0ICV6oEsZX+i4HPs73bWuouf8zBUfYcMknfT0vseEeY49cUEUKLG
         MqOF3tp/CHFR9ynhqHW1sUIXgrtVSk3UtBGIlvqko1xMTEv9RKX+b5higQFio4m3g8pN
         viSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yRd2vWX6PjNWErbTd9Y15sIa044i0uHH/q4p9H5/fi4=;
        b=uQSv9uLNgQT3ZkZ1V63bAAhqfil6awlsDTKUlAp1hyByfcBxnz0hlRNEOQBmFuSTGn
         PykFs6KOdx8ldRJa+cyiVxOO+eHQ0Ggim9JzffppgwDvO2t2YKO9igRjUO+VdUWim5pY
         rEqIZXabJlGHqIpJ3CTON+Fvmb1AcpfotJJu98mCFwBSPL50WM+QG5BkGYtZZ204VSc8
         VCp4O4hYJx4vn5WQV/l+Q8b/wa1rXbXijpuSD51Jp3yE9YTibASEqAFQ2FkAYx9xyq+m
         YD+j45DxT+ywb691jZ21zWUHY+kQTu+tC9CPkuhhNr8TYoyUCH4iPp3HmAw3iJCS4ePr
         L1Rw==
X-Gm-Message-State: APjAAAXDJeNA25fyAX9s/QFdczF2dbKSJSAHj+/7zPG7UOVFCU/MmJNh
        Q+eJu91P8srcZL0VzSTfnqsKU2Lce/erVUgKMvUOn2y/
X-Google-Smtp-Source: APXvYqxo+LtxYWcgl7DtLOVxiPXWXG5erEpaefSWnG39Fn6WBuhde+K7k6eQZmIqngE1X15d8GmTFvvGD1F7iT5Kf1g=
X-Received: by 2002:a5e:d817:: with SMTP id l23mr58776iok.282.1563876010293;
 Tue, 23 Jul 2019 03:00:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190719143222.16058-1-lhenriques@suse.com> <ab5ccaa05994e2eef05bdb54510e6b017db2d807.camel@kernel.org>
In-Reply-To: <ab5ccaa05994e2eef05bdb54510e6b017db2d807.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 23 Jul 2019 12:02:57 +0200
Message-ID: <CAOi1vP86qVeMV9hJPCP7sHfimMv08j-znSGyhcYdd1TC_Gn19A@mail.gmail.com>
Subject: Re: [PATCH 0/4] Sleeping functions in invalid context bug fixes
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Luis Henriques <lhenriques@suse.com>, Sage Weil <sage@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 19, 2019 at 5:20 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Fri, 2019-07-19 at 15:32 +0100, Luis Henriques wrote:
> > Hi,
> >
> > I'm sending three "sleeping function called from invalid context" bug
> > fixes that I had on my TODO for a while.  All of them are ceph_buffer_put
> > related, and all the fixes follow the same pattern: delay the operation
> > until the ci->i_ceph_lock is released.
> >
> > The first patch simply allows ceph_buffer_put to receive a NULL buffer so
> > that the NULL check doesn't need to be performed in all the other patches.
> > IOW, it's not really required, just convenient.
> >
> > (Note: maybe these patches should all be tagged for stable.)
> >
> > Luis Henriques (4):
> >   libceph: allow ceph_buffer_put() to receive a NULL ceph_buffer
> >   ceph: fix buffer free while holding i_ceph_lock in __ceph_setxattr()
> >   ceph: fix buffer free while holding i_ceph_lock in
> >     __ceph_build_xattrs_blob()
> >   ceph: fix buffer free while holding i_ceph_lock in fill_inode()
> >
> >  fs/ceph/caps.c              |  5 ++++-
> >  fs/ceph/inode.c             |  7 ++++---
> >  fs/ceph/snap.c              |  4 +++-
> >  fs/ceph/super.h             |  2 +-
> >  fs/ceph/xattr.c             | 19 ++++++++++++++-----
> >  include/linux/ceph/buffer.h |  3 ++-
> >  6 files changed, 28 insertions(+), 12 deletions(-)
>
> This all looks good to me. I'll plan to merge these into the testing
> branch soon, and tag them for stable.
>
> PS: On a related note (and more of a question for Ilya)...
>
> I'm wondering if we get any benefit from having our own ceph_kvmalloc
> routine. Why are we not better off using the stock kvmalloc routine
> instead? Forcing a vmalloc just because we've gone above 32k allocation
> doesn't seem like the right thing to do.

I don't remember off the top of my head and can't check right now.
Could be that kvmalloc() didn't exist back then.  I'll add that to my
TODO list.

Thanks,

                Ilya
