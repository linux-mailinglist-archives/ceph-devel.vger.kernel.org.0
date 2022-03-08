Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A644D1BCA
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Mar 2022 16:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347816AbiCHPgr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Mar 2022 10:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347752AbiCHPgq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Mar 2022 10:36:46 -0500
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1342237A9E
        for <ceph-devel@vger.kernel.org>; Tue,  8 Mar 2022 07:35:50 -0800 (PST)
Received: by mail-vs1-xe34.google.com with SMTP id u124so13983607vsb.10
        for <ceph-devel@vger.kernel.org>; Tue, 08 Mar 2022 07:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DzQxaP35N/TTzuZVroWwcewKDn02tacEdQ2KmVQhxHs=;
        b=LNoRNNdHCu0mJLUg4oBFzftZc7hoJ7DPTQAIOSRDNwg0956T4VblUWKel87ppl5GDb
         PO78vrcrNs1VrZ4lmc8UYafZXLMXgvzA0owdNDpsubPl4AnY/5YEVxL7bIBzvsMXHHhS
         neLFrI6KE+HPI1WBITvZUZUCqlHwDBt9jK+a9Nr/Tf9O1/SI+eFTU9SFeU3//gJwK67X
         IieW/nxEr2gb42gE83Jm82BWJrsQspCT3Gckb2yDna4rWZtNxPGQzEBlrDUrNpyNAAKl
         bxux/FFlL8vAZcO87ioo7Uik6s62i5j4g7DUmzNLjnuKhSmjgY7i1ZMS7nKJNOEhH1Af
         DmLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DzQxaP35N/TTzuZVroWwcewKDn02tacEdQ2KmVQhxHs=;
        b=YFUzGbeqjL2IvciSpJbCYsfBdJ3j5l78TYzpD5d/DVSDr0/TbWtPOG85f7kYK7T0pc
         vQLD5yRuTcXDE7lLZDQBaPTPWkqUdRXQkcNbBKbuTW3yLS15eo9VdTVe4+fa30DFnKHu
         ElA9fz8Omo8KVpXZYQhy0072cxt5s7+J6JBZt2oklMXmgWw8E5gLHCvPUjfvB3rv12sP
         TKGJBiQexl9oCDMFhKo4M4yakSPOG1gmPzjI/UXP5mueZGylUp7b/uRZKN40RYd3l/Kr
         /ceHTT25OdmeGLbEXIkCyj74SmamDR/Fw+aYbTFeQNs3phfp/FYhRKQ0PknzI3rXx7wQ
         ws2g==
X-Gm-Message-State: AOAM533xjGZEEa5PXo57s1/BbrYJGAbKkxVxRmzYN7qxuDMoum36BlOT
        67dnhjJJIsPBKJm557k3+FOlbmOK58V9MALt1bQ=
X-Google-Smtp-Source: ABdhPJxx9smz0E9VZLqQlxl89RpfOmOyQdpVCbQ/1nv6bCLayMrymYR9n8joLyPaDhiU8gjoVJ/IHuVwbJ+/h2+4aTE=
X-Received: by 2002:a67:2201:0:b0:320:9a4b:c868 with SMTP id
 i1-20020a672201000000b003209a4bc868mr6315388vsi.65.1646753749150; Tue, 08 Mar
 2022 07:35:49 -0800 (PST)
MIME-Version: 1.0
References: <20220308132322.1309992-1-xiubli@redhat.com> <d8836bda20bdf1c23a42045e002d99165481230e.camel@kernel.org>
 <e4f01a2b-5237-7aaf-75db-4f18a63c42e1@redhat.com>
In-Reply-To: <e4f01a2b-5237-7aaf-75db-4f18a63c42e1@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 8 Mar 2022 16:36:18 +0100
Message-ID: <CAOi1vP8njuV0HVmP+K+ehHdW07frc6wJ8GcJe3DhVK=Wv6Vi4w@mail.gmail.com>
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

On Tue, Mar 8, 2022 at 3:24 PM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 3/8/22 9:37 PM, Jeff Layton wrote:
> > On Tue, 2022-03-08 at 21:23 +0800, xiubli@redhat.com wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> When reconnecting MDS it will reopen the con with new ip address,
> >> but the when opening the con with new address it couldn't be sure
> >> that the stale work has finished. So it's possible that the stale
> >> work queued will use the new data.
> >>
> >> This will use cancel_delayed_work_sync() instead.
> >>
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>
> >> V2:
> >> - Call cancel_con() after dropping the mutex
> >>
> >>
> >>   net/ceph/messenger.c | 4 ++--
> >>   1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> >> index d3bb656308b4..62e39f63f94c 100644
> >> --- a/net/ceph/messenger.c
> >> +++ b/net/ceph/messenger.c
> >> @@ -581,8 +581,8 @@ void ceph_con_close(struct ceph_connection *con)
> >>
> >>      ceph_con_reset_protocol(con);
> >>      ceph_con_reset_session(con);
> >> -    cancel_con(con);
> >>      mutex_unlock(&con->mutex);
> >> +    cancel_con(con);
> >
> > Now the question is: Is it safe to cancel this work outside the mutex or
> > will this open up any races. Unfortunately with coarse-grained locks
> > like this, it's hard to tell what the lock actually protects.
> >
> > If we need to keep the cancel inside the lock for some reason, you could
> > instead just add a "flush_workqueue()" after dropping the mutex in the
> > above function.
> >
> > So, this looks reasonable to me at first glance, but I'd like Ilya to
> > ack this before we merge it.
>
> IMO it should be okay, since the 'queue_con(con)', which doing the
> similar things, also outside the mutex.

Hi Xiubo,

I read the patch description and skimmed through the linked trackers
but I don't understand the issue.  ceph_con_workfn() holds con->mutex
for most of the time it's running and cancel_delayed_work() is called
under the same con->mutex.  It's true that ceph_con_workfn() work may
not be finished by the time ceph_con_close() returns but I don't see
how that can result in anything bad happening.

Can you explain the issue in more detail, with pointers to specific
code snippets in the MDS client and the messenger?  Where exactly is
the "new data" (what data, please be specific) gets misused by the
"stale work"?

Thanks,

                Ilya
