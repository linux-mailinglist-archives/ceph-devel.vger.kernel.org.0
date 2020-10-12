Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87DEC28BD12
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Oct 2020 18:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389679AbgJLQAj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Oct 2020 12:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389582AbgJLQAi (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 12 Oct 2020 12:00:38 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5637C0613D0
        for <ceph-devel@vger.kernel.org>; Mon, 12 Oct 2020 09:00:38 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id r10so11573094ilm.11
        for <ceph-devel@vger.kernel.org>; Mon, 12 Oct 2020 09:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rtkfya3mJhw5LbM1yOsm0bWtIyhtbVR/MYsIs7NbPqU=;
        b=sRkKsYLrhftvQQGQi+5s8R5JvirVtBDQcWYEuMeykk66SyTPCo5KAYPEzlCTXJbQDS
         RCdy/B5qSLCBm/sYWhYVHzCfApdHrIlZjZc5awVO49MwEzcKKRClkpBr/40SniCs0Quq
         F/wO65MHqrye/jmZhQNYtj9PbuaQjI1mVqxhNfJu0XB4u2W2mryf+VMixzYXTkJFlX4N
         9LejEeFHb3BJ1nnYqSim/f+rgQsskk9om5ytqd9b99jClXqzMFLlx9Sc5xRpWpvs0NwI
         yDGzv7PLmLs/nHy9DpcKiifpg/1H8rROhe3ju2UpTmSqnYHqGVNtEi8yyxCPNhmkWM53
         rkPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rtkfya3mJhw5LbM1yOsm0bWtIyhtbVR/MYsIs7NbPqU=;
        b=ry3CWJExINcXak/Z8fMcsI1q4VRnfHKODBwcye7rnvPKufIxqQTTEM1/NMiPDioBZn
         qfY0S5Zxw6ctW3Hi8K+07KM45uyRPvUwNsPFCeb1WZrTFKvvHpL1pvLEc0ls4VI6ZHnV
         sYFJsIy6inbfNjd6j1Eur9/5ye5yHhAyt8NCHuUOsqRA4HO4ZeBDM49s6jAgeQmncfPg
         n+GPxrIfXwe/3FYiVO3yAWs04GF6wnqVS6HJobsuK3z3Vckf623XDS5YR2AdPoU38Hbn
         q+KXztxSP5qIhjflNr1AAxEltQFLgMJo0FHqZUL/kEoWv1uXMj4lUlfq/v96oMzpU+tQ
         3Z0A==
X-Gm-Message-State: AOAM533gHxDcTeZFfIvl20hyu5pX54PFrQ8i5I8uju13tcanCEEBJq+4
        UveG7oDvuu6yOl7E1OTbhTamqN+kMZmS2xE3pIA=
X-Google-Smtp-Source: ABdhPJwOCT0G9xr4TspeRZqOUAJ4HG9dQVUIvi6KzaLtXw9E39Yt4SWpI1KKvZT+90QO/dhe6enKYOcatFnKDuAa4lk=
X-Received: by 2002:a92:6711:: with SMTP id b17mr20439462ilc.100.1602518438014;
 Mon, 12 Oct 2020 09:00:38 -0700 (PDT)
MIME-Version: 1.0
References: <20201012151326.310268-1-jlayton@kernel.org>
In-Reply-To: <20201012151326.310268-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 12 Oct 2020 18:00:32 +0200
Message-ID: <CAOi1vP_xnT8E1Ojex_OgCDDJFDL7YuanUmqiErxjE8JwzZMJ8w@mail.gmail.com>
Subject: Re: [PATCH] ceph: check session state after bumping session->s_seq
To:     Jeff Layton <jlayton@kernel.org>
Cc:     "Yan, Zheng" <ukernel@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Xiubo Li <xiubli@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Oct 12, 2020 at 5:13 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Some messages sent by the MDS entail a session sequence number
> increment, and the MDS will drop certain types of requests on the floor
> when the sequence numbers don't match.
>
> In particular, a REQUEST_CLOSE message can cross with one of sequence
> morphing messages from the MDS, which can cause the client to stall,
> waiting for a response that will never come.
>
> Originally, this meant an up to 5s delay before the recurring workqueue
> job kicked in and resent the request, but a recent change made it so
> that the client would never resend, causing a 60s stall unmounting and
> sometimes a blockisting event.
>
> Fix this by checking the connection state after bumping the session
> sequence, which should cause a retransmit of the REQUEST_CLOSE, when
> this occurs.
>
> URL: https://tracker.ceph.com/issues/47563
> Fixes: fa9967734227 ("ceph: fix potential mdsc use-after-free crash")
> Reported-by: Patrick Donnelly <pdonnell@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c       | 1 +
>  fs/ceph/mds_client.c | 1 +
>  fs/ceph/quota.c      | 1 +
>  fs/ceph/snap.c       | 1 +
>  4 files changed, 4 insertions(+)
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index c00abd7eefc1..ac822c74baea 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4072,6 +4072,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>
>         mutex_lock(&session->s_mutex);
>         session->s_seq++;
> +       check_session_state(session);
>         dout(" mds%d seq %lld cap seq %u\n", session->s_mds, session->s_seq,
>              (unsigned)seq);
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 0190555b1f9e..69f529d894e6 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4238,6 +4238,7 @@ static void handle_lease(struct ceph_mds_client *mdsc,
>
>         mutex_lock(&session->s_mutex);
>         session->s_seq++;
> +       check_session_state(session);
>
>         if (!inode) {
>                 dout("handle_lease no inode %llx\n", vino.ino);
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index 83cb4f26b689..a09667ee83c1 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -54,6 +54,7 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
>         /* increment msg sequence number */
>         mutex_lock(&session->s_mutex);
>         session->s_seq++;
> +       check_session_state(session);
>         mutex_unlock(&session->s_mutex);
>
>         /* lookup inode */
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 0da39c16dab4..f1e73a65f4a5 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -874,6 +874,7 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
>
>         mutex_lock(&session->s_mutex);
>         session->s_seq++;
> +       check_session_state(session);
>         mutex_unlock(&session->s_mutex);
>
>         down_write(&mdsc->snap_rwsem);
> --
> 2.26.2
>

A new helper just for

   if (s->s_state == CEPH_MDS_SESSION_CLOSING) {
           dout("resending session close request for mds%d\n",
                           s->s_mds);
           request_close_session(s);
   }

would be more precise IMO.  It could check request_close_session()
return value and log the error, too.

Thanks,

                Ilya
