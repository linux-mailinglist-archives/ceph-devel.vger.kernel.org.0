Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76ED8161624
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Feb 2020 16:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgBQP1Y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Feb 2020 10:27:24 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:35743 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbgBQP1Y (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Feb 2020 10:27:24 -0500
Received: by mail-io1-f67.google.com with SMTP id h8so6405141iob.2
        for <ceph-devel@vger.kernel.org>; Mon, 17 Feb 2020 07:27:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RxdObJVneWyeT8lgxLMQhHFfVFDQ/1Tp/ORD1j9V+Zc=;
        b=ZBLHmHPF0Z57EwOIDSsEaoR1wZLXEjBevnjhJ+tdeGoxElC8OrVLyieBmghLN8EX6P
         OnftTqc73i1eNEJKbz1liPXy/fWekwXjlkhvR73Qwsdm0peQ6mU2j/drOzuMsb1AEnoW
         TlK0hUhqvaTdreLBjvH/k6bvkMt//IASeK+VYA6DiFo1W5k38HoMTShBeLWPtPGPyBTm
         wxlnL643H01WQY/Ihkc9a82AeZG79/zXuozpjbm+1V1md3iLTFUgXQLW6SsJ1oq/+RlX
         l9XNxP3bV+jJoaWMEg5g5SNOXAGbGW7N6bKmqjGBvYgUhqZBTx7lU0mngTiuta2aAc7f
         BMyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RxdObJVneWyeT8lgxLMQhHFfVFDQ/1Tp/ORD1j9V+Zc=;
        b=n6xh6HeKsAoJqIUOnElLarGFQB7Wjql5iW6BojLyZjZdd50vJPTtbB7a4QjShmjp2k
         tA0yr0f4AVo+83CTfJXfv4WqFETUCN4W6qvq0zHNRtVIAF7AOxqrOSsCC+OHmjPpLiFw
         SgYlI/yvdF+F3nrNNUUwGxMihfMLE52ToR2ueo+AHyQmKd8kbaAyWLWXh935KxtoQsv9
         fFu/uWbZIGPCiPHGcY8ku+1lHaYMDH6XXBe8tiV1rbcZ14FIxmM914HtPPVl3wbYZe0j
         LjNgLU1YqTLjP22o0YyIHrGjs8cEmqSNg+PsX5FcN3UGl0fti5b9OhoAMKLroKr6GIx5
         CiZQ==
X-Gm-Message-State: APjAAAUyR7DNKYgPZ2OEKb8CJECTvnbdpZWN4/u3WMywebs4bonecLsP
        cTImGbrvduFXh5t7KhLTwUP48z6bmp8/p0+jT5g=
X-Google-Smtp-Source: APXvYqysa5cQ6ucbbqIDvHnNpEunThgQv9sCKR4QoEX2bRe+6hQw2ZfZBsF0x25TcikM4DYrOPuOQNTKj7jyjM/n+Lo=
X-Received: by 2002:a02:cd12:: with SMTP id g18mr12913604jaq.76.1581953243287;
 Mon, 17 Feb 2020 07:27:23 -0800 (PST)
MIME-Version: 1.0
References: <20200217112806.30738-1-xiubli@redhat.com> <CAOi1vP_bCGoni+tmvVri6Gcv7QRN4+qvHUrrweHLpnTyAzQw=A@mail.gmail.com>
 <cf786dd6-cb6e-1a3a-a57e-04d9525bb4a4@redhat.com>
In-Reply-To: <cf786dd6-cb6e-1a3a-a57e-04d9525bb4a4@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 17 Feb 2020 16:27:48 +0100
Message-ID: <CAOi1vP9sLLUhuBAP7UZ1Mbjjx4uh0Rt0PwgAuD_qBevQoSOeHA@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix dout logs for null pointers
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Feb 17, 2020 at 4:02 PM Xiubo Li <xiubli@redhat.com> wrote:
>
> On 2020/2/17 22:52, Ilya Dryomov wrote:
> > On Mon, Feb 17, 2020 at 12:28 PM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> For example, if dentry and inode is NULL, the log will be:
> >> ceph:  lookup result=000000007a1ca695
> >> ceph:  submit_request on 0000000041d5070e for inode 000000007a1ca695
> >>
> >> The will be confusing without checking the corresponding code carefully.
> >>
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>   fs/ceph/dir.c        | 2 +-
> >>   fs/ceph/mds_client.c | 6 +++++-
> >>   2 files changed, 6 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> >> index ffeaff5bf211..245a262ec198 100644
> >> --- a/fs/ceph/dir.c
> >> +++ b/fs/ceph/dir.c
> >> @@ -798,7 +798,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
> >>          err = ceph_handle_snapdir(req, dentry, err);
> >>          dentry = ceph_finish_lookup(req, dentry, err);
> >>          ceph_mdsc_put_request(req);  /* will dput(dentry) */
> >> -       dout("lookup result=%p\n", dentry);
> >> +       dout("lookup result=%d\n", err);
> >>          return dentry;
> >>   }
> >>
> >> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> >> index b6aa357f7c61..e34f159d262b 100644
> >> --- a/fs/ceph/mds_client.c
> >> +++ b/fs/ceph/mds_client.c
> >> @@ -2772,7 +2772,11 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
> >>                  ceph_get_cap_refs(ceph_inode(req->r_old_dentry_dir),
> >>                                    CEPH_CAP_PIN);
> >>
> >> -       dout("submit_request on %p for inode %p\n", req, dir);
> >> +       if (dir)
> >> +               dout("submit_request on %p for inode %p\n", req, dir);
> >> +       else
> >> +               dout("submit_request on %p\n", req);
> > Hi Xiubo,
> >
> > It's been this way for a couple of years now.  There are a lot more
> > douts in libceph, ceph and rbd that are sometimes fed NULL pointers.
> > I don't think replacing them with conditionals is the way forward.
> >
> > I honestly don't know what security concern is addressed by hashing
> > NULL pointers, but that is what we have...  Ultimately, douts are just
> > for developers, and when you find yourself having to chase individual
> > pointers, you usually have a large enough piece of log to figure out
> > what the NULL hash is.
>
> Hi Ilya
>
> For the ceph_lookup(). The dentry will be NULL(when the directory exists
> or -ENOENT) or ERR_PTR(-errno) in most cases here, it seems for the
> rename case it will be the old dentry returned.
>
> So today I was trying to debug and get some logs from it, the
> 000000007a1ca695 really confused me for a long time before I dig into
> the source code.

I was reacting to ceph_mdsc_submit_request() hunk.  Feel free to tweak
ceph_lookup() or refactor it so that err is not threaded through three
different functions as Jeff suggested.

Thanks,

                Ilya
