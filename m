Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9011739D3
	for <lists+ceph-devel@lfdr.de>; Fri, 28 Feb 2020 15:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgB1O1j (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 28 Feb 2020 09:27:39 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:35762 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbgB1O1i (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 28 Feb 2020 09:27:38 -0500
Received: by mail-il1-f193.google.com with SMTP id g126so2873336ilh.2
        for <ceph-devel@vger.kernel.org>; Fri, 28 Feb 2020 06:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P4VOb1WnIZcylzfa+bzayBhCgXIByZNojZW1oBKG2Bc=;
        b=PobMNtH1hxpwfVYGvjsD/7ECgkT+y4znfjNh3GRGuZA1J8XxfGaONwxCqvuBiUC55g
         IZLfGFKDdIWz7uiYjKN2L5rYRSjO4nx7QJsiMDm7ddCmsN4PmWtpvmWnArLVRrApyh3S
         W3hC5KNBDxRwueTDgvgkZ9UI/gNgTBErUNxcjnIvkDCF7BnbPGFQSYetHzvPF5P+MA48
         1KpVamyQc9ervO3xL7tfES4GhzecVgfwg1lw7Nw3gAKqtD8A8b/Q0ZOSEQz1MtAHfx/D
         Aq/8P629I0KAMsKzavKFE9IMKElnNsonUtF7AK8KP8SQRrsY4VfrgGjMAx8HncNFb2VA
         T4hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P4VOb1WnIZcylzfa+bzayBhCgXIByZNojZW1oBKG2Bc=;
        b=hBFtyJgiX6ZmLUFkXkb8jCxOoJVv2wMVFfb+pJP3lmhEMt0F75yO/OFKhg5Y6SFp6d
         1zkPWKyl7BZufuo2bXtheVqvaV5T0gkxtq2ZIr+wmub7Jk3rvWLfiFbuy19aLkisSG0X
         t+KLmGNk2wAZakOKOlmw4tY5Ar3EyF7T4jvppaLqu/3FelxxFH+fubvKRyoUNzmtReFg
         UtotI1QSdNztQuv9iEX+p76vQDFfTRhTpoEE6IdlewnFFSYMvPLW8hVkbMRqVY4tdW5f
         csuSi+gT+hcZeklHHQjwaLc4uNzqQjfTO1JgdZq9k9SJvKqlJA6fXAjs8T3Odgts2IBE
         wkzg==
X-Gm-Message-State: APjAAAXLquXguIdFIbUsA7GQaPkszMELa+caooVY1Onp4T+uesG0CLSo
        lsJGrY+NsKLod/NN5j0vvXaBP/J6CnUTtBBwn3w=
X-Google-Smtp-Source: APXvYqz3oYsghy6Xf0sb+RD4fWHhqN+54+dWVEIqhOt+vExmPDxIeaPs8i9IjtlEngZwDrREUwFMxGXUOGmW7yHXuv0=
X-Received: by 2002:a92:ccd0:: with SMTP id u16mr4260328ilq.215.1582900057342;
 Fri, 28 Feb 2020 06:27:37 -0800 (PST)
MIME-Version: 1.0
References: <20200228141519.23406-1-jlayton@kernel.org>
In-Reply-To: <20200228141519.23406-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 28 Feb 2020 15:27:30 +0100
Message-ID: <CAOi1vP9tOKPFag9yYi65Lg-cni-QO=kixSBBFzQQ-DA64+zG=w@mail.gmail.com>
Subject: Re: [PATCH] ceph: clean up kick_flushing_inode_caps
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Feb 28, 2020 at 3:15 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> The last thing that this function does is release i_ceph_lock, so
> have the caller do that instead. Add a lockdep assertion to
> ensure that the function is always called with i_ceph_lock held.
> Change the prototype to take a ceph_inode_info pointer and drop
> the separate mdsc argument as we can get that from the session.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c | 23 +++++++++--------------
>  1 file changed, 9 insertions(+), 14 deletions(-)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 9b3d5816c109..c02b63070e0a 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -2424,16 +2424,15 @@ void ceph_kick_flushing_caps(struct ceph_mds_client *mdsc,
>         }
>  }
>
> -static void kick_flushing_inode_caps(struct ceph_mds_client *mdsc,
> -                                    struct ceph_mds_session *session,
> -                                    struct inode *inode)
> -       __releases(ci->i_ceph_lock)
> +static void kick_flushing_inode_caps(struct ceph_mds_session *session,
> +                                    struct ceph_inode_info *ci)
>  {
> -       struct ceph_inode_info *ci = ceph_inode(inode);
> -       struct ceph_cap *cap;
> +       struct ceph_mds_client *mdsc = session->s_mdsc;
> +       struct ceph_cap *cap = ci->i_auth_cap;
> +
> +       lockdep_assert_held(&ci->i_ceph_lock);
>
> -       cap = ci->i_auth_cap;
> -       dout("kick_flushing_inode_caps %p flushing %s\n", inode,
> +       dout("%s %p flushing %s\n", __func__, &ci->vfs_inode,
>              ceph_cap_string(ci->i_flushing_caps));
>
>         if (!list_empty(&ci->i_cap_flush_list)) {
> @@ -2445,9 +2444,6 @@ static void kick_flushing_inode_caps(struct ceph_mds_client *mdsc,
>                 spin_unlock(&mdsc->cap_dirty_lock);
>
>                 __kick_flushing_caps(mdsc, session, ci, oldest_flush_tid);
> -               spin_unlock(&ci->i_ceph_lock);
> -       } else {
> -               spin_unlock(&ci->i_ceph_lock);
>         }
>  }
>
> @@ -3326,11 +3322,10 @@ static void handle_cap_grant(struct inode *inode,
>         if (le32_to_cpu(grant->op) == CEPH_CAP_OP_IMPORT) {
>                 if (newcaps & ~extra_info->issued)
>                         wake = true;
> -               kick_flushing_inode_caps(session->s_mdsc, session, inode);
> +               kick_flushing_inode_caps(session, ci);
>                 up_read(&session->s_mdsc->snap_rwsem);
> -       } else {
> -               spin_unlock(&ci->i_ceph_lock);
>         }
> +       spin_unlock(&ci->i_ceph_lock);

Hi Jeff,

I would keep the else clause here and release i_ceph_lock before
snap_rwsem for proper nesting.  Otherwise kudos on getting rid of
another locking quirk!

Thanks,

                Ilya
