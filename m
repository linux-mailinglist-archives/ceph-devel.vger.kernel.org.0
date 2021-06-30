Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B32D3B8249
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jun 2021 14:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234576AbhF3Mmj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Jun 2021 08:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbhF3Mmi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Jun 2021 08:42:38 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E95DC061756
        for <ceph-devel@vger.kernel.org>; Wed, 30 Jun 2021 05:40:10 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id g3so979748iok.12
        for <ceph-devel@vger.kernel.org>; Wed, 30 Jun 2021 05:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eFmN3KPPi61wNtsxTcgr9m9VT0JP/Ttm0BK2BzfbskE=;
        b=Pzo0+yq14AfdIHtPm3wuM1Orb0rV69rmbrYya8duAH83d79K25XVOYRdxr0TCs65+V
         m+KqJi/l4WBP2DJb0qvRyVFTiuvwGNMTJhoR2R4QIL5JvlUf+fuqx3f3gojvOulqO9a6
         ww/bflvL4Kxds/zjbqIzVphm6gCp/jAVe7Lw4amMcZdcMFJjK18fDPr6pXkeQL7mBIWY
         9tT8IlvH/C+dkpVG63sRYocLgqzikb0EGMCXizJULaWzOWfILJbMMmzEwIownpJkH66+
         liSmGXFp1VJDFTfwtvQ78YpLuQrhjVhzpZBWnLLbP6XIsGWVSkDZyK617QKXyAfbVa09
         TUgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eFmN3KPPi61wNtsxTcgr9m9VT0JP/Ttm0BK2BzfbskE=;
        b=BHQAuL0wazE7MRqsW9ovTMWGh1PTu9N4brTey6xESgiiFqhnh4JEhBLWOnF32pgOM7
         OJ5yeEllPIM2Cd79dQPyfPi0HqtkMidlroacRhd2+ySBghX2ykLMvOr6gmG+SeZzHxs/
         t1a69s63xwoNJtD+TstWHS1PL29Qe9EViy7nqQBneZuPWsvXK/O2nTWgoS99/JdrdVKD
         POn4Hz2obMeoCiErSgmlm0+G894YU+sGj20n5fuRAx8Q5xU1zPSIaFHjeTjpxJZDCt6I
         Ol2wDweohaJsv10QgA/Rctb4eYVvedWuUG0nR1sL8Z2MEUulY7BVG2qYHgFEoXNr8qGT
         an5g==
X-Gm-Message-State: AOAM531BA1L3cp7HSUMSt8Rvt9ai5aeW4eCc7jb3IxaLYgkLr8LRTI+I
        4cLwDnNFE25/bfucij4Uh7DoBamqiVkh5XyRj4k=
X-Google-Smtp-Source: ABdhPJzowbZ2F/LIgD106Ak13sRq3MxULftIOlnTjfUUsAcqOYh9G5gZfn1GKw8J8MoF7YlPjQ5MqZWTzZeJDS0zLTM=
X-Received: by 2002:a5e:8d13:: with SMTP id m19mr7820484ioj.167.1625056809691;
 Wed, 30 Jun 2021 05:40:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210629044241.30359-1-xiubli@redhat.com> <20210629044241.30359-4-xiubli@redhat.com>
In-Reply-To: <20210629044241.30359-4-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 30 Jun 2021 14:39:50 +0200
Message-ID: <CAOi1vP-g4rChLzvpqr2cPrbe0sRLQwbUxOKPcdaSRcHUpcboUA@mail.gmail.com>
Subject: Re: [PATCH 3/5] ceph: flush mdlog before umounting
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 29, 2021 at 6:42 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c         | 29 +++++++++++++++++++++++++++++
>  fs/ceph/mds_client.h         |  1 +
>  include/linux/ceph/ceph_fs.h |  1 +
>  3 files changed, 31 insertions(+)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 96bef289f58f..2db87a5c68d4 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4689,6 +4689,34 @@ static void wait_requests(struct ceph_mds_client *mdsc)
>         dout("wait_requests done\n");
>  }
>
> +static void send_flush_mdlog(struct ceph_mds_session *s)
> +{
> +       u64 seq = s->s_seq;
> +       struct ceph_msg *msg;
> +
> +       /*
> +        * For the MDS daemons lower than Luminous will crash when it
> +        * saw this unknown session request.

"Pre-luminous MDS crashes when it sees an unknown session request"

> +        */
> +       if (!CEPH_HAVE_FEATURE(s->s_con.peer_features, SERVER_LUMINOUS))
> +               return;
> +
> +       dout("send_flush_mdlog to mds%d (%s)s seq %lld\n",

Should (%s)s be just (%s)?

> +            s->s_mds, ceph_session_state_name(s->s_state), seq);
> +       msg = ceph_create_session_msg(CEPH_SESSION_REQUEST_FLUSH_MDLOG, seq);
> +       if (!msg) {
> +               pr_err("failed to send_flush_mdlog to mds%d (%s)s seq %lld\n",

Same here and let's avoid function names in error messages.  Something
like "failed to request mdlog flush ...".

> +                      s->s_mds, ceph_session_state_name(s->s_state), seq);
> +       } else {
> +               ceph_con_send(&s->s_con, msg);
> +       }
> +}
> +
> +void flush_mdlog(struct ceph_mds_client *mdsc)
> +{
> +       ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
> +}

Is this wrapper really needed?

> +
>  /*
>   * called before mount is ro, and before dentries are torn down.
>   * (hmm, does this still race with new lookups?)
> @@ -4698,6 +4726,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
>         dout("pre_umount\n");
>         mdsc->stopping = 1;
>
> +       flush_mdlog(mdsc);
>         ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
>         ceph_flush_dirty_caps(mdsc);
>         wait_requests(mdsc);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index fca2cf427eaf..79d5b8ed62bf 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -537,6 +537,7 @@ extern int ceph_iterate_session_caps(struct ceph_mds_session *session,
>                                      int (*cb)(struct inode *,
>                                                struct ceph_cap *, void *),
>                                      void *arg);
> +extern void flush_mdlog(struct ceph_mds_client *mdsc);
>  extern void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc);
>
>  static inline void ceph_mdsc_free_path(char *path, int len)
> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
> index 57e5bd63fb7a..ae60696fe40b 100644
> --- a/include/linux/ceph/ceph_fs.h
> +++ b/include/linux/ceph/ceph_fs.h
> @@ -300,6 +300,7 @@ enum {
>         CEPH_SESSION_FLUSHMSG_ACK,
>         CEPH_SESSION_FORCE_RO,
>         CEPH_SESSION_REJECT,
> +       CEPH_SESSION_REQUEST_FLUSH_MDLOG,

Need to update ceph_session_op_name().

Thanks,

                Ilya
