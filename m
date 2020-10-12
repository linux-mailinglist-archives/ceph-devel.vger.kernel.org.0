Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B93328C014
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Oct 2020 20:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbgJLSyS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Oct 2020 14:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbgJLSyS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 12 Oct 2020 14:54:18 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E6EC0613D0
        for <ceph-devel@vger.kernel.org>; Mon, 12 Oct 2020 11:54:18 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id j13so13057140ilc.4
        for <ceph-devel@vger.kernel.org>; Mon, 12 Oct 2020 11:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rVhSq0164fU0w+L8L88Ev6pFtAYnBm/1zvsxqyOb/9I=;
        b=qUosbGW5tIBhxb9cDtchMYP6CP2wznMTAFVzJXw+arbXpaHgznMgLANFoCtARUInjR
         JE731HgYB98mxpybu8N5mE394HRcjl1q9re9wdKOAemj0jupRuon5eTBZf2bTPk9foRr
         UWc/L0EfHYsrOej4+RQpx+et1PlbnM1HElYIJM6af4lb3vbUzr5kLWhT4cKBUzkeVG04
         s/fHm8cC5JigfezibVZNLy2Q/BAAnGXbv3W6rtuN4BB5/VMvIDXxFYh2hG8jycxzdit8
         80XfFcXpe+Muq7gRLMJxyZ8hCfBk5N95hbXZO8A1s+5mTYL7TkJzVMLjat0eMJV6gnmA
         YZwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rVhSq0164fU0w+L8L88Ev6pFtAYnBm/1zvsxqyOb/9I=;
        b=YuXZwERpzXFtO4qCsnr7OB9/PSSMr0q1+ZS35GSmXJjhdhMiuUN2vcR105HZc+T0YO
         +MBD9zJDHnIcBYGPztK1kQidqYfT/ealFsc5C3K95zeKZkVtXFR0tK0X/kl+nHm1RwO5
         usssvhQHqT2vxttP7TsH6foesnFXHhpN2S9FILEiuWgz04qZsJky+FO9gOguGXxIWM1P
         X9sHBonjfEjI3DrsMKcuEeba1PHU7GgZ1KuPVMzaYoYvqL6WKudLu8DVr413eKGze2QS
         8gjB3QKB0WiAvNLZ13AWKnAZ5MzLkq2doqTUSpRqBgZzushvSIizqSqZ1DPxydjJfI1I
         JxWQ==
X-Gm-Message-State: AOAM533zSPUPH1FEinhuZn9HOZx6DJhjLMY5k7dT3ZX8dNCyUP7YdigB
        /48F89eA8e5ufpB9nj+5rGsDoqAgNSKd0TKmU+TaKBlXZAE=
X-Google-Smtp-Source: ABdhPJwR8mO58Ig1uR8gdBJdxhtW700sE4s4OLK09Rr/j/HKmHnX8ySPwVQTa+Vihc+qii8vms9Glid0cY9rs9M2utM=
X-Received: by 2002:a92:d850:: with SMTP id h16mr191387ilq.281.1602528857432;
 Mon, 12 Oct 2020 11:54:17 -0700 (PDT)
MIME-Version: 1.0
References: <20201012172140.602684-1-jlayton@kernel.org>
In-Reply-To: <20201012172140.602684-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 12 Oct 2020 20:54:12 +0200
Message-ID: <CAOi1vP8m2m4xbuLFM+0WKPQxzE9bur0ywbJLbBeVvL=s2f9u3A@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: check session state after bumping session->s_seq
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <ukernel@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Xiubo Li <xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Oct 12, 2020 at 7:21 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Some messages sent by the MDS entail a session sequence number
> increment, and the MDS will drop certain types of requests on the floor
> when the sequence numbers don't match.
>
> In particular, a REQUEST_CLOSE message can cross with one of the
> sequence morphing messages from the MDS which can cause the client to
> stall, waiting for a response that will never come.
>
> Originally, this meant an up to 5s delay before the recurring workqueue
> job kicked in and resent the request, but a recent change made it so
> that the client would never resend, causing a 60s stall unmounting and
> sometimes a blockisting event.
>
> Add a new helper for incrementing the session sequence and then testing
> to see whether a REQUEST_CLOSE needs to be resent. Change all of the
> bare sequence counter increments to use the new helper.
>
> URL: https://tracker.ceph.com/issues/47563
> Fixes: fa9967734227 ("ceph: fix potential mdsc use-after-free crash")
> Reported-by: Patrick Donnelly <pdonnell@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c       |  2 +-
>  fs/ceph/mds_client.c | 35 +++++++++++++++++++++++++++++------
>  fs/ceph/mds_client.h |  1 +
>  fs/ceph/quota.c      |  2 +-
>  fs/ceph/snap.c       |  2 +-
>  5 files changed, 33 insertions(+), 9 deletions(-)
>
> v2: move seq increment and check for closed session into new helper
>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index c00abd7eefc1..ba0e4f44862c 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -4071,7 +4071,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>              vino.snap, inode);
>
>         mutex_lock(&session->s_mutex);
> -       session->s_seq++;
> +       inc_session_sequence(session);
>         dout(" mds%d seq %lld cap seq %u\n", session->s_mds, session->s_seq,
>              (unsigned)seq);
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 0190555b1f9e..17b94f06826a 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4237,7 +4237,7 @@ static void handle_lease(struct ceph_mds_client *mdsc,
>              dname.len, dname.name);
>
>         mutex_lock(&session->s_mutex);
> -       session->s_seq++;
> +       inc_session_sequence(session);
>
>         if (!inode) {
>                 dout("handle_lease no inode %llx\n", vino.ino);
> @@ -4384,14 +4384,25 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
>         ceph_force_reconnect(fsc->sb);
>  }
>
> +static bool check_session_closing(struct ceph_mds_session *s)
> +{
> +       int ret;
> +
> +       if (s->s_state != CEPH_MDS_SESSION_CLOSING)
> +               return true;
> +
> +       dout("resending session close request for mds%d\n", s->s_mds);
> +       ret = request_close_session(s);
> +       if (ret < 0)
> +               pr_err("ceph: Unable to close session to mds %d: %d\n", s->s_mds, ret);
> +       return false;
> +}
> +
>  bool check_session_state(struct ceph_mds_session *s)
>  {
> -       if (s->s_state == CEPH_MDS_SESSION_CLOSING) {
> -               dout("resending session close request for mds%d\n",
> -                               s->s_mds);
> -               request_close_session(s);
> +       if (!check_session_closing(s))

Do we actually need it in check_session_state() now?  Given that it is
conditioned on CEPH_MDS_SESSION_CLOSING and we know check_session_state()
doesn't get called in that case, it seems like dead code to me.

Thanks,

                Ilya
