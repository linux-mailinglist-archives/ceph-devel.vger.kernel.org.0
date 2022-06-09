Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F11554424B
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jun 2022 06:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiFIEDN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jun 2022 00:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiFIEDL (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jun 2022 00:03:11 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C1F1FE4C5
        for <ceph-devel@vger.kernel.org>; Wed,  8 Jun 2022 21:03:10 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id c18so12406009pgh.11
        for <ceph-devel@vger.kernel.org>; Wed, 08 Jun 2022 21:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8h38iUOc1DL3LmxbkTIVPLvG350Lnn7nlkZTntuhvg8=;
        b=buN2iejOfpgmohtn0npSt0V+M8aJJiEmJ3j5O/dQnVXACATVmP0jhtfkDO1JBTI/wF
         esTgOG75LGMnV1PwD2uSpW3lpHFDltawWlL5lyfyb1KW0mN6UrRPGAILPMBqM+Yzds5E
         OX0O4bcd6U5r5NI3o4nLQa+v9OquCOldfzYMJ93XgmDkqrAX1xw8ZHROSeCy6UBdLTps
         oE9rypzrPnbIlsgJZoLxTFxUiUAFqHKSFX2k79/GH6MMRpRxF9PPlWKGLrmGTjyzNiFk
         90oAaFCsFH5YPyvsRuQskIH3CXbMByO1VvLh3501CZttl7YOjGB2+l9oRMP2RBBE4H8j
         oPXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8h38iUOc1DL3LmxbkTIVPLvG350Lnn7nlkZTntuhvg8=;
        b=EfFHL1zrj4ZbrLP09lcenjbIftGxkAIIwI2Cs4sXQzfJlVUFlxf8oSR6JI/EMlAt8b
         YHmA8zNGIQrT4EnNBCI0qR1cHVwHm8uMN7OM6foC840L2xFDZwrsDRg/rhJGfccDx3uR
         mbarSCqAniLYFfcOdUnW7nXJq4tovikUvDG8LqaZ8KlNuWfY9I3InPxnL0JDj1Nhn1k5
         eTXscnoXS+UrwW7O7burLjq2jTt38Ubv5nJaZUwxjxNC9Ze3iTXix0Rhxm5bInmJygY8
         eMIOYYGQXNFsv2EdnnfM2XMFecH+TPdEMAHwKNHf/tVpf2bPxl/bNk8drpwQHTD3IAUv
         bHWQ==
X-Gm-Message-State: AOAM531DSqWX5pn35Vbr+oTHYjT5QDGNOZkzwTMNLOH2IupMoZVUhRox
        8alZ/PsII9wjQtgz2paEq/9SDvx2VJbcFhEYXeM=
X-Google-Smtp-Source: ABdhPJxAj6P46JzpdZU1StFoJRiT2w5pP+Q00qTIGZfSc7fXnqGyGVEoIxDtRuuMWDnZByDisc5jowr1DZav0TGQ68c=
X-Received: by 2002:a63:de01:0:b0:3fd:9833:cdcf with SMTP id
 f1-20020a63de01000000b003fd9833cdcfmr18683012pgg.315.1654747389520; Wed, 08
 Jun 2022 21:03:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220606233142.150457-1-jlayton@kernel.org> <CAAM7YAmguEUbX7XWc9HV0traYT-CgKWdDWV8-OyjwLc2+Tk8EQ@mail.gmail.com>
 <eaa4e405-d7a5-7cf2-d9e2-4cce55f3c1f9@redhat.com> <CAAM7YAn7UBP-ip=71AcApu70wpvYLS9-q843LALkA9oyw8MqAw@mail.gmail.com>
 <115f53c7-4ad4-aa1f-05b0-66de7d2cdb03@redhat.com>
In-Reply-To: <115f53c7-4ad4-aa1f-05b0-66de7d2cdb03@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 9 Jun 2022 12:02:55 +0800
Message-ID: <CAAM7YAnR2dir=8dhWKqYG1YMLVQ_YRADa3Kq=Q9MD-YaYbg5jA@mail.gmail.com>
Subject: Re: [PATCH] ceph: wait on async create before checking caps for syncfs
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 9, 2022 at 11:56 AM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 6/9/22 11:29 AM, Yan, Zheng wrote:
> > On Thu, Jun 9, 2022 at 11:19 AM Xiubo Li <xiubli@redhat.com> wrote:
> >>
> >> On 6/9/22 10:15 AM, Yan, Zheng wrote:
> >>> The recent series of patches that add "wait on async xxxx" at various
> >>> places do not seem correct. The correct fix should make mds avoid any
> >>> wait when handling async requests.
> >>>
> >> In this case I am thinking what will happen if the async create request
> >> is deferred, then the cap flush related request should fail to find the
> >> ino.
> >>
> >> Should we wait ? Then how to distinguish from migrating a subtree and a
> >> deferred async create cases ?
> >>
> > async op caps are revoked at freezingtree stage of subtree migration.
> > see Locker::invalidate_lock_caches
> >
> Sorry I may not totally understand this issue.
>
> I think you mean in case of migration and then the MDS will revoke caps
> for the async create files and then the kclient will send a MclientCap
> request to mds, right ?
>
> If my understanding is correct, there is another case that:
>
> 1, async create a fileA
>
> 2, then write a lot of data to it and then release the Fw cap ref, and
> if we should report the size to MDS, it will send a MclientCap request
> to MDS too.
>
> 3, what if the async create of fileA was deferred due to some reason,
> then the MclientCap request will fail to find the ino ?
>

Async op should not be deferred in any case.

>
> >>> On Wed, Jun 8, 2022 at 12:56 PM Jeff Layton <jlayton@kernel.org> wrote:
> >>>> Currently, we'll call ceph_check_caps, but if we're still waiting on the
> >>>> reply, we'll end up spinning around on the same inode in
> >>>> flush_dirty_session_caps. Wait for the async create reply before
> >>>> flushing caps.
> >>>>
> >>>> Fixes: fbed7045f552 (ceph: wait for async create reply before sending any cap messages)
> >>>> URL: https://tracker.ceph.com/issues/55823
> >>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> >>>> ---
> >>>>    fs/ceph/caps.c | 1 +
> >>>>    1 file changed, 1 insertion(+)
> >>>>
> >>>> I don't know if this will fix the tx queue stalls completely, but I
> >>>> haven't seen one with this patch in place. I think it makes sense on its
> >>>> own, either way.
> >>>>
> >>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> >>>> index 0a48bf829671..5ecfff4b37c9 100644
> >>>> --- a/fs/ceph/caps.c
> >>>> +++ b/fs/ceph/caps.c
> >>>> @@ -4389,6 +4389,7 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
> >>>>                   ihold(inode);
> >>>>                   dout("flush_dirty_caps %llx.%llx\n", ceph_vinop(inode));
> >>>>                   spin_unlock(&mdsc->cap_dirty_lock);
> >>>> +               ceph_wait_on_async_create(inode);
> >>>>                   ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
> >>>>                   iput(inode);
> >>>>                   spin_lock(&mdsc->cap_dirty_lock);
> >>>> --
> >>>> 2.36.1
> >>>>
>
