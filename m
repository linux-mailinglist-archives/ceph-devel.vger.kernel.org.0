Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572704AC44F
	for <lists+ceph-devel@lfdr.de>; Mon,  7 Feb 2022 16:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbiBGPsz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 7 Feb 2022 10:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358577AbiBGPkZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 7 Feb 2022 10:40:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EED34C0401C1
        for <ceph-devel@vger.kernel.org>; Mon,  7 Feb 2022 07:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644248423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=McUdsvu180CCnxfQCZBFsb4P3yu/T2WQTt0/nWwAVuQ=;
        b=L2VaEqE8Zl96vKkHAAfz7dRipuTgxz1SU7fRJy4MTa4VQ3bKK1wdZWKSEJDQ3CGm6vAMdo
        1JGZwvv5+vnreR+CmqoefXac9D0SxNiR/w3Hqm03bXXc9V4e58zHL7sSS+LD0rWfalDRni
        WRGI3la9mhDcwlaCv8w51k5Ddvktf/0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-m3IOxo9fMP-gIl9Vm92ogQ-1; Mon, 07 Feb 2022 10:40:21 -0500
X-MC-Unique: m3IOxo9fMP-gIl9Vm92ogQ-1
Received: by mail-qv1-f72.google.com with SMTP id c8-20020a0ce7c8000000b0042c12357076so1105747qvo.6
        for <ceph-devel@vger.kernel.org>; Mon, 07 Feb 2022 07:40:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=McUdsvu180CCnxfQCZBFsb4P3yu/T2WQTt0/nWwAVuQ=;
        b=IQ/cLWD44A3ajLyXoxgai15vkuG067jqNemCH7O88ygXmDLEm6XTJjya65ktUcuCbB
         7EeFyKkiUHiNj+f5ht+UAQDSHqxuunsa93BwMEQK2uXP7MEzUX393GVcUDn6hmUxpkaS
         /SSQpLxRSy0DxEo552nT5OnkF2RcqNSE/cmDvD5y9vPSetIM4JCxuHSFwMjaz+nEGw6N
         MwfmF6PranAx4UE2lfeDThG5jItER0mg8Mp+yl1TtKfteEni3mICRN1o/C1FfidjCyQ3
         NvaSdAiLdk+A/3M+WUWXyW2ubAo+T4eP3QOJuWI1PZGCV3JcVzOr5xJHK2EZCPANV8v6
         awUA==
X-Gm-Message-State: AOAM5325z22fONBbuLhBlPn3p2O6pS/nIqCFXKnDyN9BdW89oIxAZugd
        AQQiTWGrc2MzHGiYlvBh2KjBjik8Ufwwep6r59DxknT/0ZweM+WhHZ2CWm+XbwVxnxYENEamprE
        m+6Y6FBatlJV+qxcdxfvjlBz8WAaeGIqgwGw2Cg==
X-Received: by 2002:a05:6214:2389:: with SMTP id fw9mr165221qvb.105.1644248421245;
        Mon, 07 Feb 2022 07:40:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy1d1jwKMM39kqFmjtdSwVYUee0WvrXgct4RouIEmfMcYhtEpbKkMQesfA9kh55PgNh6OOuHR/2Q9sw9yLQPUU=
X-Received: by 2002:a05:6214:2389:: with SMTP id fw9mr165189qvb.105.1644248420753;
 Mon, 07 Feb 2022 07:40:20 -0800 (PST)
MIME-Version: 1.0
References: <20220207050340.872893-1-xiubli@redhat.com> <77bd8ec8fb97107deb57c641b5e471b8eeb828c8.camel@kernel.org>
In-Reply-To: <77bd8ec8fb97107deb57c641b5e471b8eeb828c8.camel@kernel.org>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Mon, 7 Feb 2022 07:40:08 -0800
Message-ID: <CAJ4mKGbHyn-oQwL8D3Ove0d2tD++VEXOTMSj5EDbcBk3SFX=2w@mail.gmail.com>
Subject: Re: [PATCH] ceph: fail the request directly if handle_reply gets an ESTALE
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Venky Shankar <vshankar@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@newdream.net>, ukernel <ukernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Feb 7, 2022 at 7:12 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Mon, 2022-02-07 at 13:03 +0800, xiubli@redhat.com wrote:
> > From: Xiubo Li <xiubli@redhat.com>
> >
> > If MDS return ESTALE, that means the MDS has already iterated all
> > the possible active MDSes including the auth MDS or the inode is
> > under purging. No need to retry in auth MDS and will just return
> > ESTALE directly.
> >
>
> When you say "purging" here, do you mean that it's effectively being
> cleaned up after being unlinked? Or is it just being purged from the
> MDS's cache?
>
> > Or it will cause definite loop for retrying it.
> >
> > URL: https://tracker.ceph.com/issues/53504
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >  fs/ceph/mds_client.c | 29 -----------------------------
> >  1 file changed, 29 deletions(-)
> >
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 93e5e3c4ba64..c918d2ac8272 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -3368,35 +3368,6 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
> >
> >       result = le32_to_cpu(head->result);
> >
> > -     /*
> > -      * Handle an ESTALE
> > -      * if we're not talking to the authority, send to them
> > -      * if the authority has changed while we weren't looking,
> > -      * send to new authority
> > -      * Otherwise we just have to return an ESTALE
> > -      */
> > -     if (result == -ESTALE) {
> > -             dout("got ESTALE on request %llu\n", req->r_tid);
> > -             req->r_resend_mds = -1;
> > -             if (req->r_direct_mode != USE_AUTH_MDS) {
> > -                     dout("not using auth, setting for that now\n");
> > -                     req->r_direct_mode = USE_AUTH_MDS;
> > -                     __do_request(mdsc, req);
> > -                     mutex_unlock(&mdsc->mutex);
> > -                     goto out;
> > -             } else  {
> > -                     int mds = __choose_mds(mdsc, req, NULL);
> > -                     if (mds >= 0 && mds != req->r_session->s_mds) {
> > -                             dout("but auth changed, so resending\n");
> > -                             __do_request(mdsc, req);
> > -                             mutex_unlock(&mdsc->mutex);
> > -                             goto out;
> > -                     }
> > -             }
> > -             dout("have to return ESTALE on request %llu\n", req->r_tid);
> > -     }
> > -
> > -
> >       if (head->safe) {
> >               set_bit(CEPH_MDS_R_GOT_SAFE, &req->r_req_flags);
> >               __unregister_request(mdsc, req);
>
>
> (cc'ing Greg, Sage and Zheng)
>
> This patch sort of contradicts the original design, AFAICT, and I'm not
> sure what the correct behavior should be. I could use some
> clarification.
>
> The original code (from the 2009 merge) would tolerate 2 ESTALEs before
> giving up and returning that to userland. Then in 2010, Greg added this
> commit:
>
>     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e55b71f802fd448a79275ba7b263fe1a8639be5f
>
> ...which would presumably make it retry indefinitely as long as the auth
> MDS kept changing. Then, Zheng made this change in 2013:
>
>     https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ca18bede048e95a749d13410ce1da4ad0ffa7938
>
> ...which seems to try to do the same thing, but detected the auth mds
> change in a different way.
>
> Is that where livelock detection was broken? Or was there some
> corresponding change to __choose_mds that should prevent infinitely
> looping on the same request?
>
> In NFS, ESTALE errors mean that the filehandle (inode) no longer exists
> and that the server has forgotten about it. Does it mean the same thing
> to the ceph MDS?

This used to get returned if the MDS couldn't find the inode number in
question, because . This was not possible in most cases because if the
client has caps on the inode, it's pinned in MDS cache, but was
possible when NFS was layered on top (and possibly some other edge
case APIs where clients can operate on inode numbers they've saved
from a previous lookup?).

>
> Has the behavior of the MDS changed such that these retries are no
> longer necessary on an ESTALE? If so, when did this change, and does the
> client need to do anything to detect what behavior it should be using?

Well, I see that CEPHFS_ESTALE is still returned sometimes from the
MDS, so somebody will need to audit those, but the MDS has definitely
changed. These days, we can look up an unknown inode using the
(directory) backtrace we store on its first RADOS object, and it does
(at least some of the time? But I think everywhere relevant). But that
happened when we first added scrub circa 2014ish? Previously if the
inode wasn't in cache, we just had no way of finding it.
-Greg

