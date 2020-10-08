Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1612287AF6
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Oct 2020 19:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732045AbgJHR15 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Oct 2020 13:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731089AbgJHR15 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Oct 2020 13:27:57 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E0EC061755
        for <ceph-devel@vger.kernel.org>; Thu,  8 Oct 2020 10:27:57 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id l16so6443138ilt.13
        for <ceph-devel@vger.kernel.org>; Thu, 08 Oct 2020 10:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=beGd4uCU55CCDdD41AHUKF6EXUq6YeZlm9MflxHl06s=;
        b=lwdgULzvadkBtxcTyG+0aywqicD6Cny/hnBW42RxJSD9eqJLDcbWsycohTuPCLp2an
         12CtHB1WjSuxlEoscM5uFCNGzFAF+3L6TY9YzBeW0Wfo+iv2DjkvqpyDBhuhsO7OhdyJ
         gYmkz0GvNUVoCqgzljdfZai3F/eY3nmZtKy8+9MGjRhiQFHi1IPah6uk/NdXvYWBXNc2
         4mj6H5dePzuka9uajngxQgdUL5hc1DaU5KDNfMtcTkrFkXsS3aoCGChQXVCPh10fdI4v
         9c0lH5PqiY2QFdLHMWv8+dczBHxVlgEo2lA9mNOchaccBLpet4X6p6yI84fjWGdv+WfV
         VvuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=beGd4uCU55CCDdD41AHUKF6EXUq6YeZlm9MflxHl06s=;
        b=Gpp7Xyr+pMp9+RA6iTArgE/7Ue8FEyI/TrflPPOvcc99thmfS/PxmaWa9rc0VlASvr
         CTCrB/ij2YFFHzQ0o8AtbjgYXDdLA3Laenf+VzqPkkEzVab6RK8iXbOESLnbIW2VU2fg
         Dbt09utuCz/w2I9mhFWkMvf8oumxsrrYThELRpXScJLPqaFN2xioUK0Asl1NMhyC19d3
         FycUkM/DLPeJJAzaIUSFsn67uQTjNeBOZjR4nAmW8BMHRtDfztrr3NuPhe8WKfqQBpGt
         vAt3UGhVCAmPuk5GdNm5eZ9cTbl8xwzwqJ0qbggmGN7FbgO+ZrTJLHg0X2GwWN51Ar3Z
         eYpw==
X-Gm-Message-State: AOAM532OsQn56UqLYdvgq0KxJndIUD9KRBErIXbQ2ATqJ7FrfHk2epGx
        b1XZM2RbPZzurKXl8VM3CFiewG2pQmr3TMRKQNQ=
X-Google-Smtp-Source: ABdhPJxXxdvpGBaep9fNyIA+s2KOyr00fU6Yp1HnooJwhR/UwxuoT1wvJMEO6Qq0kTFoEU9DXzUw988Js5cAfLtXmJU=
X-Received: by 2002:a92:6711:: with SMTP id b17mr7960375ilc.100.1602178076455;
 Thu, 08 Oct 2020 10:27:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200928220349.584709-1-jlayton@kernel.org>
In-Reply-To: <20200928220349.584709-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 8 Oct 2020 19:27:48 +0200
Message-ID: <CAOi1vP8zXLGscoa4QjiwW0BtbVnrkamWGzBeqARnVr8Maes3CQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: retransmit REQUEST_CLOSE every second if we don't
 get a response
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Sep 29, 2020 at 12:03 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> Patrick reported a case where the MDS and client client had racing
> session messages to one anothe. The MDS was sending caps to the client
> and the client was sending a CEPH_SESSION_REQUEST_CLOSE message in order
> to unmount.
>
> Because they were sending at the same time, the REQUEST_CLOSE had too
> old a sequence number, and the MDS dropped it on the floor. On the
> client, this would have probably manifested as a 60s hang during umount.
> The MDS ended up blocklisting the client.
>
> Once we've decided to issue a REQUEST_CLOSE, we're finished with the
> session, so just keep sending them until the MDS acknowledges that.
>
> Change the code to retransmit a REQUEST_CLOSE every second if the
> session hasn't changed state yet. Give up and throw a warning after
> mount_timeout elapses if we haven't gotten a response.
>
> URL: https://tracker.ceph.com/issues/47563
> Reported-by: Patrick Donnelly <pdonnell@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/mds_client.c | 53 ++++++++++++++++++++++++++------------------
>  1 file changed, 32 insertions(+), 21 deletions(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index b07e7adf146f..d9cb74e3d5e3 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -1878,7 +1878,7 @@ static int request_close_session(struct ceph_mds_session *session)
>  static int __close_session(struct ceph_mds_client *mdsc,
>                          struct ceph_mds_session *session)
>  {
> -       if (session->s_state >= CEPH_MDS_SESSION_CLOSING)
> +       if (session->s_state > CEPH_MDS_SESSION_CLOSING)
>                 return 0;
>         session->s_state = CEPH_MDS_SESSION_CLOSING;
>         return request_close_session(session);
> @@ -4692,38 +4692,49 @@ static bool done_closing_sessions(struct ceph_mds_client *mdsc, int skipped)
>         return atomic_read(&mdsc->num_sessions) <= skipped;
>  }
>
> +static bool umount_timed_out(unsigned long timeo)
> +{
> +       if (time_before(jiffies, timeo))
> +               return false;
> +       pr_warn("ceph: unable to close all sessions\n");
> +       return true;
> +}
> +
>  /*
>   * called after sb is ro.
>   */
>  void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
>  {
> -       struct ceph_options *opts = mdsc->fsc->client->options;
>         struct ceph_mds_session *session;
> -       int i;
> -       int skipped = 0;
> +       int i, ret;
> +       int skipped;
> +       unsigned long timeo = jiffies +
> +                             ceph_timeout_jiffies(mdsc->fsc->client->options->mount_timeout);
>
>         dout("close_sessions\n");
>
>         /* close sessions */
> -       mutex_lock(&mdsc->mutex);
> -       for (i = 0; i < mdsc->max_sessions; i++) {
> -               session = __ceph_lookup_mds_session(mdsc, i);
> -               if (!session)
> -                       continue;
> -               mutex_unlock(&mdsc->mutex);
> -               mutex_lock(&session->s_mutex);
> -               if (__close_session(mdsc, session) <= 0)
> -                       skipped++;
> -               mutex_unlock(&session->s_mutex);
> -               ceph_put_mds_session(session);
> +       do {
> +               skipped = 0;
>                 mutex_lock(&mdsc->mutex);
> -       }
> -       mutex_unlock(&mdsc->mutex);
> +               for (i = 0; i < mdsc->max_sessions; i++) {
> +                       session = __ceph_lookup_mds_session(mdsc, i);
> +                       if (!session)
> +                               continue;
> +                       mutex_unlock(&mdsc->mutex);
> +                       mutex_lock(&session->s_mutex);
> +                       if (__close_session(mdsc, session) <= 0)
> +                               skipped++;
> +                       mutex_unlock(&session->s_mutex);
> +                       ceph_put_mds_session(session);
> +                       mutex_lock(&mdsc->mutex);
> +               }
> +               mutex_unlock(&mdsc->mutex);
>
> -       dout("waiting for sessions to close\n");
> -       wait_event_timeout(mdsc->session_close_wq,
> -                          done_closing_sessions(mdsc, skipped),
> -                          ceph_timeout_jiffies(opts->mount_timeout));
> +               dout("waiting for sessions to close\n");
> +               ret = wait_event_timeout(mdsc->session_close_wq,
> +                                        done_closing_sessions(mdsc, skipped), HZ);
> +       } while (!ret && !umount_timed_out(timeo));
>
>         /* tear down remaining sessions */
>         mutex_lock(&mdsc->mutex);
> --
> 2.26.2
>

Hi Jeff,

This seems wrong to me, at least conceptually.  Is the same patch
getting applied to ceph-fuse?

Pretending to not know anything about the client <-> MDS protocol,
two questions immediately come to mind.  Why is MDS allowed to drop
REQUEST_CLOSE?  If the client is really done with the session, why
does it block on the acknowledgement from the MDS?

Thanks,

                Ilya
