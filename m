Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631F74A2B62
	for <lists+ceph-devel@lfdr.de>; Sat, 29 Jan 2022 04:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352272AbiA2DPH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 28 Jan 2022 22:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240864AbiA2DPG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 28 Jan 2022 22:15:06 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC5BC061714
        for <ceph-devel@vger.kernel.org>; Fri, 28 Jan 2022 19:15:06 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id c24so13920895edy.4
        for <ceph-devel@vger.kernel.org>; Fri, 28 Jan 2022 19:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NnX0x/h+nmNoPZpjQbz5FGe+ohHqiu7sK9y9yHHBTAs=;
        b=Wf1nWrmwh524AHZtwOXbdSIueTVamvXu9+acFuoWT1g1sZ6cGx2AJA3dvdErDfcuSZ
         DRmDentl0baWDXOOIn98HO+BbZiROS+ASrn4kh3Sjey6KlhUejI4ldud7p4xoYrLh+JM
         b/rihZEFglRtwURKz8eipoF9v/0jy3Xm3ypGYfakFRlfw6QJqV7c/aCgfDPWoEUOOipP
         hw2qwWGqelJFFGhknmZ+7ID2KX4jnDSjEVJrfTGY5+s1bhaz8B5dbnPhPBKQBk81Bd+A
         tVyHhMZPT6ybsgRqcwSBrEL0m+0nwiGIADUExQpevCKOj2+G5lrL8BNAr2AntJVwjIOg
         jsyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NnX0x/h+nmNoPZpjQbz5FGe+ohHqiu7sK9y9yHHBTAs=;
        b=JDpscXMJU6/F6WHnbpqNIlT16mo3jMXcIi+McQ9OIRn1jzvwyK+zxIv1s4QFSWInao
         EovTgGk9BGKtC8SXT0BGm/TcWY0rl5Dn96iPKRDTScMnYSrQ6zqIKU9XPaygyzyEOVyw
         6I2vMc1JqfrTtJzqcCqDkrRadoMeGvPIM0+tRANtGnARJNT7WA3bxXY8BivnmMLoH4Vn
         Iky5VpX+u3ZbqwdsYlXLqsw6Zrvl8ornzPV9XPRE/IgkBEHPbbx5DU+2RQeps8w7NEyO
         byJx4xmVEzair+N/5Sxx5iAoVQe6DNUk1Q3cLV03+DCpN7cQj6tKieutJWPMH3h/1/1S
         PWAg==
X-Gm-Message-State: AOAM533Ni8riiEL/8EoTWAO+dRviAAb3mGOXWNsk75ZJOZaI0ZiUYp5d
        EEvrFk2DTR3xFB9c51q+GSJMEQ9oZzEXVtr9l4A=
X-Google-Smtp-Source: ABdhPJw0d9kBj/5PVlXUj2lLKV4BDx6OVTeaTkK6dHjfFdZqCWtDbEhs5iBuDSTJLAk3zyYAoVg6JmoYwxe+L0tQEMA=
X-Received: by 2002:aa7:cd0b:: with SMTP id b11mr10845972edw.412.1643426104606;
 Fri, 28 Jan 2022 19:15:04 -0800 (PST)
MIME-Version: 1.0
References: <20220127200849.96580-1-jlayton@kernel.org>
In-Reply-To: <20220127200849.96580-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Sat, 29 Jan 2022 11:14:53 +0800
Message-ID: <CAAM7YAmcj4JQ64EHWRTAVnEGnhfSN1OSUCSuOoi2PhOT8s_cHg@mail.gmail.com>
Subject: Re: [PATCH] ceph: wake waiters on any IMPORT that grants new caps
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, Jan 29, 2022 at 2:32 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> I've noticed an intermittent hang waiting for caps in some testing. What
> I see is that the client will try to get caps for an operation (e.g. a
> read), and ends up waiting on the waitqueue forever. The caps debugfs
> file however shows that the caps it's waiting on have already been
> granted.
>
> The current grant handling code will wake the waitqueue when it sees
> that there are newly-granted caps in the issued set. On an import
> however, we'll end up adding a new cap first, which fools the logic into
> thinking that nothing has changed. A later hack in the code works around
> this, but only for auth caps.

not right. handle_cap_import() saves old issued to extra_info->issued.

>
> Ensure we wake the waiters whenever we get an IMPORT that grants new
> caps for the inode.
>
> URL: https://tracker.ceph.com/issues/54044
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
>
> I'm still testing this patch, but I think this may be the cause of some
> mysterious hangs I've hit in testing.
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index e668cdb9c99e..06b65a68e920 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3541,21 +3541,22 @@ static void handle_cap_grant(struct inode *inode,
>                         fill_inline = true;
>         }
>
> -       if (ci->i_auth_cap == cap &&
> -           le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
> +       if (le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
>                 if (newcaps & ~extra_info->issued)
>                         wake = true;
>
> -               if (ci->i_requested_max_size > max_size ||
> -                   !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
> -                       /* re-request max_size if necessary */
> -                       ci->i_requested_max_size = 0;
> -                       wake = true;
> -               }
> +               if (ci->i_auth_cap == cap) {
> +                       if (ci->i_requested_max_size > max_size ||
> +                           !(le32_to_cpu(grant->wanted) & CEPH_CAP_ANY_FILE_WR)) {
> +                               /* re-request max_size if necessary */
> +                               ci->i_requested_max_size = 0;
> +                               wake = true;
> +                       }
>
> -               ceph_kick_flushing_inode_caps(session, ci);
> -               spin_unlock(&ci->i_ceph_lock);
> -               up_read(&session->s_mdsc->snap_rwsem);
> +                       ceph_kick_flushing_inode_caps(session, ci);
> +                       spin_unlock(&ci->i_ceph_lock);
> +                       up_read(&session->s_mdsc->snap_rwsem);
> +               }
>         } else {
>                 spin_unlock(&ci->i_ceph_lock);
>         }
> --
> 2.34.1
>
