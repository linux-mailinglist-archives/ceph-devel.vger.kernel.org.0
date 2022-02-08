Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575684ADC38
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Feb 2022 16:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351408AbiBHPRF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Feb 2022 10:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239424AbiBHPRD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Feb 2022 10:17:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 28439C061576
        for <ceph-devel@vger.kernel.org>; Tue,  8 Feb 2022 07:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644333418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JF6HuXD2RhSvps1jldBKNzQcMLUW5cYMc6Bff76LVKg=;
        b=ODFn7sDeP2GtPP8unqsRj8qnFvgfRfjINZeJWKuz2h+gs/IRP/PDIeqzUiwjyevtI5Hq3G
        R7M74zW3b/pD27/NxKpX40exSwxMJMDUKI7DnT30t/rdA8Ny43iSRCPqEYz6Rc3JEwrGlE
        AcVlqLHnSIZ/HGvvzbcS0H+oyDgsfa4=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-Xlype7wUPNi5b_jruM7ssA-1; Tue, 08 Feb 2022 10:16:56 -0500
X-MC-Unique: Xlype7wUPNi5b_jruM7ssA-1
Received: by mail-qt1-f199.google.com with SMTP id x10-20020ac8700a000000b002c3ef8fc44cso13728067qtm.8
        for <ceph-devel@vger.kernel.org>; Tue, 08 Feb 2022 07:16:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JF6HuXD2RhSvps1jldBKNzQcMLUW5cYMc6Bff76LVKg=;
        b=hvepw6edX9+n5fYJC73ki0Z89iOa+RLGXp4rhaXMN4oF6XoMOW4Xkj4npD0jwAuO/M
         P35+bUsRT/j/G8Vi2Pb2AwlH4qvwmu4sIu+KqNvFPRh6c+06MZ7p2IzlfmqhM2edzGQJ
         bkuWA1m4uhbnOXbVseJvd3t9alAoB5w3L/WpywV1w56BT6C0Wxyq1hHxS/JjJb7j1IfT
         gifpRZisnax03aEI59TpGvxszwlBZMQdgx3f1JFPfdnWzhozHO7v47ZdLFx5QqgbI0vR
         KwK1+qaIv9YH5UiC++6zuAem+U4xsaHBje3JMVO3MZoH/rZbNTG+gPXEM2QlW8V3SKZ3
         XKiQ==
X-Gm-Message-State: AOAM531HnO/YsPSruEg8yR/7IvntSP1F/lLVsaharCrzldIxy8JRlDN5
        gp0hrz1PSyXtszeGrMKOtE5eepKn1h9xUPAHB68l3CyG9KhTJuesAr62zk0AiUym30m7oqLOCo2
        Pu9xDZQLqNaIIbv0tW4rnn6Xf2oCFVNAwBP8lqA==
X-Received: by 2002:ac8:1194:: with SMTP id d20mr3252995qtj.408.1644333411158;
        Tue, 08 Feb 2022 07:16:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwOlpZbtNsE6Wf7y8MaSKj7JUqrYpGIExjIbVVKPcK38XYI5DCmT0jqjtpan2oeCAhUNkixY4XQjquXmPX/VT8=
X-Received: by 2002:ac8:1194:: with SMTP id d20mr3252952qtj.408.1644333410582;
 Tue, 08 Feb 2022 07:16:50 -0800 (PST)
MIME-Version: 1.0
References: <20220207050340.872893-1-xiubli@redhat.com> <77bd8ec8fb97107deb57c641b5e471b8eeb828c8.camel@kernel.org>
 <056ab110-9e3f-5d47-0a4b-9ec03afda651@redhat.com>
In-Reply-To: <056ab110-9e3f-5d47-0a4b-9ec03afda651@redhat.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Tue, 8 Feb 2022 07:16:38 -0800
Message-ID: <CAJ4mKGY=Yq6fLHRamgC3WkPWCsrQPQNseF1iTc5iVm12LQDwqQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: fail the request directly if handle_reply gets an ESTALE
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
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

On Mon, Feb 7, 2022 at 11:56 PM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 2/7/22 11:12 PM, Jeff Layton wrote:
> > On Mon, 2022-02-07 at 13:03 +0800, xiubli@redhat.com wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> If MDS return ESTALE, that means the MDS has already iterated all
> >> the possible active MDSes including the auth MDS or the inode is
> >> under purging. No need to retry in auth MDS and will just return
> >> ESTALE directly.
> >>
> > When you say "purging" here, do you mean that it's effectively being
> > cleaned up after being unlinked? Or is it just being purged from the
> > MDS's cache?
>
> There is one case when the client just removes the file or the file is
> force overrode via renaming, the related dentry in MDS will be put to
> stray dir and the Inode will be marked as under purging.

I'm confused by this statement. Renaming inode B over inode A should
still just be a normal unlink for A, and not trigger an immediate
purge. Is there something in the MDS that force-starts that and breaks
clients who still have the inode held open?
-Greg

> So in case when
> the client try to call getattr, for example, after that, or retries the
> pending getattr request, which can cause the MDS returns ESTALE errno in
> theory.
>
> Locally I still haven't reproduced it yet.
>
> >> Or it will cause definite loop for retrying it.
> >>
> >> URL: https://tracker.ceph.com/issues/53504
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>   fs/ceph/mds_client.c | 29 -----------------------------
> >>   1 file changed, 29 deletions(-)
> >>
> >> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> >> index 93e5e3c4ba64..c918d2ac8272 100644
> >> --- a/fs/ceph/mds_client.c
> >> +++ b/fs/ceph/mds_client.c
> >> @@ -3368,35 +3368,6 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
> >>
> >>      result = le32_to_cpu(head->result);
> >>
> >> -    /*
> >> -     * Handle an ESTALE
> >> -     * if we're not talking to the authority, send to them
> >> -     * if the authority has changed while we weren't looking,
> >> -     * send to new authority
> >> -     * Otherwise we just have to return an ESTALE
> >> -     */
> >> -    if (result == -ESTALE) {
> >> -            dout("got ESTALE on request %llu\n", req->r_tid);
> >> -            req->r_resend_mds = -1;
> >> -            if (req->r_direct_mode != USE_AUTH_MDS) {
> >> -                    dout("not using auth, setting for that now\n");
> >> -                    req->r_direct_mode = USE_AUTH_MDS;
> >> -                    __do_request(mdsc, req);
> >> -                    mutex_unlock(&mdsc->mutex);
> >> -                    goto out;
> >> -            } else  {
> >> -                    int mds = __choose_mds(mdsc, req, NULL);
> >> -                    if (mds >= 0 && mds != req->r_session->s_mds) {
> >> -                            dout("but auth changed, so resending\n");
> >> -                            __do_request(mdsc, req);
> >> -                            mutex_unlock(&mdsc->mutex);
> >> -                            goto out;
> >> -                    }
> >> -            }
> >> -            dout("have to return ESTALE on request %llu\n", req->r_tid);
> >> -    }
> >> -
> >> -
> >>      if (head->safe) {
> >>              set_bit(CEPH_MDS_R_GOT_SAFE, &req->r_req_flags);
> >>              __unregister_request(mdsc, req);
> >
> > (cc'ing Greg, Sage and Zheng)
> >
> > This patch sort of contradicts the original design, AFAICT, and I'm not
> > sure what the correct behavior should be. I could use some
> > clarification.
> >
> > The original code (from the 2009 merge) would tolerate 2 ESTALEs before
> > giving up and returning that to userland. Then in 2010, Greg added this
> > commit:
> >
> >      https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e55b71f802fd448a79275ba7b263fe1a8639be5f
> >
> > ...which would presumably make it retry indefinitely as long as the auth
> > MDS kept changing. Then, Zheng made this change in 2013:
> >
> >      https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ca18bede048e95a749d13410ce1da4ad0ffa7938
> >
> > ...which seems to try to do the same thing, but detected the auth mds
> > change in a different way.
> >
> > Is that where livelock detection was broken? Or was there some
> > corresponding change to __choose_mds that should prevent infinitely
> > looping on the same request?
> >
> > In NFS, ESTALE errors mean that the filehandle (inode) no longer exists
> > and that the server has forgotten about it. Does it mean the same thing
> > to the ceph MDS?
> >
> > Has the behavior of the MDS changed such that these retries are no
> > longer necessary on an ESTALE? If so, when did this change, and does the
> > client need to do anything to detect what behavior it should be using?
>

