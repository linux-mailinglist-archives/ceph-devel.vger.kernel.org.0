Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAD52DE3F4
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Dec 2020 15:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgLROXq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 18 Dec 2020 09:23:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgLROXp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 18 Dec 2020 09:23:45 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBFDC0617A7
        for <ceph-devel@vger.kernel.org>; Fri, 18 Dec 2020 06:23:05 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id 2so2262680ilg.9
        for <ceph-devel@vger.kernel.org>; Fri, 18 Dec 2020 06:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SBGlH2APrq+Z8sek+Lxo3w0f8RMj+KBPrOVbvhoRTU8=;
        b=pMk/B7BtVIuqhEJtze84IUhHJu+/jRJTwsryTKY+1I+0F0919BAAgxx+7HR85kxwr9
         KATOM6/yZTEfFma1haNQhowMo0MdXWbQ+N2TIXfojc9FV64roSNifLIVcjVMRE5vS06q
         6dJuVOwnbEQ0HGJiVNr2wyPlq9/HWelSn6BjmwE7HJsXYZmlZ3xi+Vreo2EwDDIHLVFU
         fbyLuMf2nF9rNvwq/vySqhJVkULCF3beIkduhKNEOBljbn/M69U2CzZf9ycOQE9fw6Ay
         vlp2KfK7Wr20k54YlO6R7ch336rOJ3/7asZYXI606jZRVIR3jk9hVWA8NpSX9QHLOxSZ
         IpDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SBGlH2APrq+Z8sek+Lxo3w0f8RMj+KBPrOVbvhoRTU8=;
        b=QgFmDqDehbCkIFPJe3TR40PBfOUVm5VqhFjxPya32mhWWip0yRWRTXFw8F2+d2ZVjQ
         1SUMGCXB3UU7jIOCmErgNXyVifDuFMehMow+SUAfecs4abOWnCtdRRuS8o4rGog+XudO
         OxQNE0Gp/dnT4ekqeys/E9hIAuGmt8xB+2P6iiZK5dKlTh9LzLzR0pDfpjx52geMcFe4
         k9+0dERCvx2xi1uR493o4gVopPKwxS0ve3GKqBWgxJgwNyrKh5FKPtzStRd59AVIQbDh
         ZSJpPLpElwCABfXKhQQ9n0vUwUx8LaedO8UN/w2m/mx94JsCKMG1Y/aQ4ezdwqvDnGmV
         prHA==
X-Gm-Message-State: AOAM530Dm9A4NDyMAkFju0a/QD+xNjBebERXh0FEBx8+HZevG3OhJCoU
        PSeePh5dLnE0cwacbrzOO5l0Uz/i6SN1jVVlaaM=
X-Google-Smtp-Source: ABdhPJyc+/HKl8bBrI6dr6zijdvsm+37hHUVle1ge0FmT70kutkMmpdWGReeiY/s5s+U9FWiCmuZ6C/x6LZqAr0XoSI=
X-Received: by 2002:a92:4c3:: with SMTP id 186mr4065084ile.177.1608301384912;
 Fri, 18 Dec 2020 06:23:04 -0800 (PST)
MIME-Version: 1.0
References: <20201211123858.7522-1-jlayton@kernel.org> <20201211123858.7522-4-jlayton@kernel.org>
In-Reply-To: <20201211123858.7522-4-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 18 Dec 2020 15:22:51 +0100
Message-ID: <CAOi1vP-qh2YWn_c=zUVB3czepSYau+n2paMZHA2nJDVhwyk-EQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] ceph: allow queueing cap/snap handling after putting
 cap references
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Xiubo Li <xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Dec 11, 2020 at 1:39 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Testing with the fscache overhaul has triggered some lockdep warnings
> about circular lock dependencies involving page_mkwrite and the
> mmap_lock. It'd be better to do the "real work" without the mmap lock
> being held.
>
> Change the skip_checking_caps parameter in __ceph_put_cap_refs to an
> enum, and use that to determine whether to queue check_caps, do it
> synchronously or not at all. Change ceph_page_mkwrite to do a
> ceph_put_cap_refs_async().
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/addr.c  |  2 +-
>  fs/ceph/caps.c  | 28 ++++++++++++++++++++++++----
>  fs/ceph/inode.c |  6 ++++++
>  fs/ceph/super.h | 19 ++++++++++++++++---
>  4 files changed, 47 insertions(+), 8 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 950552944436..26e66436f005 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1662,7 +1662,7 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
>
>         dout("page_mkwrite %p %llu~%zd dropping cap refs on %s ret %x\n",
>              inode, off, len, ceph_cap_string(got), ret);
> -       ceph_put_cap_refs(ci, got);
> +       ceph_put_cap_refs_async(ci, got);
>  out_free:
>         ceph_restore_sigs(&oldset);
>         sb_end_pagefault(inode->i_sb);
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 336348e733b9..a95ab4c02056 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3026,6 +3026,12 @@ static int ceph_try_drop_cap_snap(struct ceph_inode_info *ci,
>         return 0;
>  }
>
> +enum PutCapRefsMode {
> +       PutCapRefsModeSync = 0,
> +       PutCapRefsModeSkip,
> +       PutCapRefsModeAsync,
> +};

Hi Jeff,

A couple style nits, since mixed case stood out ;)

Let's avoid CamelCase.  Page flags and existing protocol definitions
like SMB should be the only exception.  I'd suggest PUT_CAP_REFS_SYNC,
etc.

> +
>  /*
>   * Release cap refs.
>   *
> @@ -3036,7 +3042,7 @@ static int ceph_try_drop_cap_snap(struct ceph_inode_info *ci,
>   * cap_snap, and wake up any waiters.
>   */
>  static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
> -                               bool skip_checking_caps)
> +                               enum PutCapRefsMode mode)
>  {
>         struct inode *inode = &ci->vfs_inode;
>         int last = 0, put = 0, flushsnaps = 0, wake = 0;
> @@ -3092,11 +3098,20 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>         dout("put_cap_refs %p had %s%s%s\n", inode, ceph_cap_string(had),
>              last ? " last" : "", put ? " put" : "");
>
> -       if (!skip_checking_caps) {
> +       switch(mode) {
> +       default:
> +               break;
> +       case PutCapRefsModeSync:
>                 if (last)
>                         ceph_check_caps(ci, 0, NULL);
>                 else if (flushsnaps)
>                         ceph_flush_snaps(ci, NULL);
> +               break;
> +       case PutCapRefsModeAsync:
> +               if (last)
> +                       ceph_queue_check_caps(inode);
> +               else if (flushsnaps)
> +                       ceph_queue_flush_snaps(inode);

Add a break here.  I'd also move the default clause to the end.

>         }
>         if (wake)
>                 wake_up_all(&ci->i_cap_wq);
> @@ -3106,12 +3121,17 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>
>  void ceph_put_cap_refs(struct ceph_inode_info *ci, int had)
>  {
> -       __ceph_put_cap_refs(ci, had, false);
> +       __ceph_put_cap_refs(ci, had, PutCapRefsModeSync);
> +}
> +
> +void ceph_put_cap_refs_async(struct ceph_inode_info *ci, int had)
> +{
> +       __ceph_put_cap_refs(ci, had, PutCapRefsModeAsync);
>  }
>
>  void ceph_put_cap_refs_no_check_caps(struct ceph_inode_info *ci, int had)
>  {
> -       __ceph_put_cap_refs(ci, had, true);
> +       __ceph_put_cap_refs(ci, had, PutCapRefsModeSkip);

Perhaps name the enum member PUT_CAP_REFS_NO_CHECK to match the
exported function?

Thanks,

                Ilya
