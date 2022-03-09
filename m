Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115194D2C64
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Mar 2022 10:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbiCIJp2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Mar 2022 04:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbiCIJp1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Mar 2022 04:45:27 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0CDC1405FF
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 01:44:28 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id u124so1626009vsb.10
        for <ceph-devel@vger.kernel.org>; Wed, 09 Mar 2022 01:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B/eaqdxBnbb6HucScnd5BlJir7S3zhxtPTS5yrwxe4o=;
        b=i8P/Dlyc6RfYqpfzILBZ5p7RyAnsN9KoPTk9EjczMGX2WLWH2OHwt9PidRLyTe+VBg
         3HD2azoIVWQgWGH8RsJOcY+tmNgOVilhRqDjD4TqNm9gPQ7Cn5XzgPpOh7KMb8Qo9waO
         w0DJ5Ky/Wmvq/5wMIVHy5jYhB/dUMYILgeR+5P42uCn+4+0IDle+rkTcQ/l0iCM7q944
         6dum5NK78GyQ0Fd2E3HchtLlscCFMFHmONKVC8J1QtSCF7LPmljRJ1vEYpYF8f8Baupl
         jDXw5KiRFpeOWAsrTYRr+Qehu7NbBNDLlfYegdjCKOjZC+AJ87+KU3rsyFT2/Y+3sPRH
         1vEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B/eaqdxBnbb6HucScnd5BlJir7S3zhxtPTS5yrwxe4o=;
        b=KSloB6yIRFKkXHhyJssisW4vvJ7CDTVEGaDkvlCoWULtwK9VGBSCcSgnndGrHTGSjQ
         YN6EIPMpuMkNnn0tNAgkFvxNm7I/Ew/JYmsHcGREgBio/CSYJ07lUS1N4rfVI7kBYo2H
         XzPEvgfiCq9S2fLZ6tPv8vJsg6WBUXV+NU8ffZIYhrq5dMcQC10r4817HUmwgEw4phgo
         z4/Suldt6jiMl3zLtnv2RGewb6TR3Ee7UhgcDHsbxP9roDhojIeddd8fs9hlaGRAyIUp
         lRZIk3a8wzBRvmtJPCtXiB7ZEsADCQyhblGF8GY1EWtL4hQuN+DkS7/awm+FhJjQwOwM
         OUcQ==
X-Gm-Message-State: AOAM533MaDthLk47X7DL4XmpPNL3tevhX234Hd+Bc8Cj99pXkvmPKbin
        9Lahx2OZYzjwSyVyNLOmtDQxmZrQPj0wejG4UFY=
X-Google-Smtp-Source: ABdhPJzwAvhGpqHJksSBs9sQKfq9nvemtu9ogZfj2ASCCqPZ8qnhA9OUPrfMxNe0dVKzAA0qNe7dMZVco5uPQ5EP8Rg=
X-Received: by 2002:a67:efca:0:b0:320:9220:daff with SMTP id
 s10-20020a67efca000000b003209220daffmr9074786vsp.57.1646819067725; Wed, 09
 Mar 2022 01:44:27 -0800 (PST)
MIME-Version: 1.0
References: <20220308132322.1309992-1-xiubli@redhat.com> <d8836bda20bdf1c23a42045e002d99165481230e.camel@kernel.org>
 <e4f01a2b-5237-7aaf-75db-4f18a63c42e1@redhat.com> <CAOi1vP8njuV0HVmP+K+ehHdW07frc6wJ8GcJe3DhVK=Wv6Vi4w@mail.gmail.com>
 <6cd01bfa-3e50-29b4-d20d-4672abc5a2b0@redhat.com>
In-Reply-To: <6cd01bfa-3e50-29b4-d20d-4672abc5a2b0@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 9 Mar 2022 10:44:56 +0100
Message-ID: <CAOi1vP_eQKMqRpbfUgpaorm+NxFTOsiFSBcmaa6Tj4iRnYQL=Q@mail.gmail.com>
Subject: Re: [PATCH v2] libceph: wait for con->work to finish when cancelling con
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Venky Shankar <vshankar@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Mar 9, 2022 at 2:47 AM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 3/8/22 11:36 PM, Ilya Dryomov wrote:
> > On Tue, Mar 8, 2022 at 3:24 PM Xiubo Li <xiubli@redhat.com> wrote:
> >>
> >> On 3/8/22 9:37 PM, Jeff Layton wrote:
> >>> On Tue, 2022-03-08 at 21:23 +0800, xiubli@redhat.com wrote:
> >>>> From: Xiubo Li <xiubli@redhat.com>
> >>>>
> >>>> When reconnecting MDS it will reopen the con with new ip address,
> >>>> but the when opening the con with new address it couldn't be sure
> >>>> that the stale work has finished. So it's possible that the stale
> >>>> work queued will use the new data.
> >>>>
> >>>> This will use cancel_delayed_work_sync() instead.
> >>>>
> >>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >>>> ---
> >>>>
> >>>> V2:
> >>>> - Call cancel_con() after dropping the mutex
> >>>>
> >>>>
> >>>>    net/ceph/messenger.c | 4 ++--
> >>>>    1 file changed, 2 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> >>>> index d3bb656308b4..62e39f63f94c 100644
> >>>> --- a/net/ceph/messenger.c
> >>>> +++ b/net/ceph/messenger.c
> >>>> @@ -581,8 +581,8 @@ void ceph_con_close(struct ceph_connection *con)
> >>>>
> >>>>       ceph_con_reset_protocol(con);
> >>>>       ceph_con_reset_session(con);
> >>>> -    cancel_con(con);
> >>>>       mutex_unlock(&con->mutex);
> >>>> +    cancel_con(con);
> >>> Now the question is: Is it safe to cancel this work outside the mutex or
> >>> will this open up any races. Unfortunately with coarse-grained locks
> >>> like this, it's hard to tell what the lock actually protects.
> >>>
> >>> If we need to keep the cancel inside the lock for some reason, you could
> >>> instead just add a "flush_workqueue()" after dropping the mutex in the
> >>> above function.
> >>>
> >>> So, this looks reasonable to me at first glance, but I'd like Ilya to
> >>> ack this before we merge it.
> >> IMO it should be okay, since the 'queue_con(con)', which doing the
> >> similar things, also outside the mutex.
> > Hi Xiubo,
> >
> > I read the patch description and skimmed through the linked trackers
> > but I don't understand the issue.  ceph_con_workfn() holds con->mutex
> > for most of the time it's running and cancel_delayed_work() is called
> > under the same con->mutex.  It's true that ceph_con_workfn() work may
> > not be finished by the time ceph_con_close() returns but I don't see
> > how that can result in anything bad happening.
> >
> > Can you explain the issue in more detail, with pointers to specific
> > code snippets in the MDS client and the messenger?  Where exactly is
> > the "new data" (what data, please be specific) gets misused by the
> > "stale work"?
>
> The tracker I attached in V1 is not exact, please ignore that.
>
>  From the current code, there has one case that for ceph fs in
> send_mds_reconnect():
>
> 4256         ceph_con_close(&session->s_con);
> 4257         ceph_con_open(&session->s_con,
> 4258                       CEPH_ENTITY_TYPE_MDS, mds,
> 4259                       ceph_mdsmap_get_addr(mdsc->mdsmap, mds));
>
> If in ceph_con_close() just before cancelling the con->work, it was
> already fired but then the queue thread was just scheduled out when the
> con->work was trying to take the con->mutex.
>
> And then in ceph_con_open() it will update the con->state to
> 'CEPH_CON_S_PREOPEN' and other members then queue the con->work again.

But ceph_con_close() releases con->mutex before returning, so the
work that was trying to grab con->mutex would immediately grab it,
encounter CEPH_CON_S_CLOSED and bail.

>
> That means the con->work will be run twice with the state
> 'CEPH_CON_S_PREOPEN'.

... so this is very unlikely.  But even it happens somehow, again
I don't see how that can result in anything bad happening: whoever
sees CEPH_CON_S_PREOPEN first would transition con to the initial
"opening" state (e.g. CEPH_CON_S_V1_BANNER for msgr1).

>
> I am not sure whether will this cause strange issues like the URL I
> attached in V1.

Until you can pin point the messenger as the root cause of those
issues, I'd recommend dropping this patch.

Thanks,

                Ilya
