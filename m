Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBDC545094
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jun 2022 17:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344400AbiFIPVP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jun 2022 11:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344407AbiFIPVN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jun 2022 11:21:13 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84A34AE00
        for <ceph-devel@vger.kernel.org>; Thu,  9 Jun 2022 08:21:10 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id mh16-20020a17090b4ad000b001e8313301f1so1560458pjb.1
        for <ceph-devel@vger.kernel.org>; Thu, 09 Jun 2022 08:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hrawn79EDElrpsUqYn7iblEdBf0ydoa2Wm/U1WJOOPY=;
        b=TDokCAC1O2iWOwR8QkdXNSuRKxG7Gutz3HGLtoUZDPNSrQGHF2kXVekmq4ku3rYwww
         EJIKQP5zsrXVJZbgE1vpQX+injxQcG6fRTazR/xttKSgQFWjk1nCIrh5tRAzNoEopQGL
         2zHAObeNkDgsqOuHZIgTEN3xM/qJ88iKtBJ+Upa1DzxZWWV4/tz8nJcaaCb7SdNP8ura
         5BvFFgj9CrYppa2DtKz0MzWbP49YDvECzUk8Ye8LH3US/CWNvKkJA3cfZ7cvr4PnSHU4
         sCKTJyNYhq9iCmBTTjrDS+fhImKFHJPec6NnwlrmqZZXaLkqoJUjgrtn1lN3Lun+QQMs
         jfDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hrawn79EDElrpsUqYn7iblEdBf0ydoa2Wm/U1WJOOPY=;
        b=Xc3ZZbOAEB8eUq8XlbwtmKNXBTgS9LTPHjn6tf457bBtcFwIJg2HIS6UTKb9ZOwk0u
         Lbl9cK+k1S7/vNAwttuEcYbFU238LDbuqS/mvziPAceNNGv/4lxS0SVaXYGEnuOlpIoE
         R9CD78VVQ3/3BtOitIDnH6TAqjY1IkujUZA3JVZQFHb714BfBfSYvCqEIS1coDyHrMRf
         g6JSpZdtK+I9Be2IUisbYkfFvtyoAexLBBFYC0PLIMN1gbJWyrE4JPl37zNsMs2D8gyf
         pjs5dc6/dv9+ba8j9oJ8DmUpkMqJ64RKuYjAX9ZFNuDP+ntQVaQw+oWFaWtaSx8Et/NI
         OmPA==
X-Gm-Message-State: AOAM533n34g6sbn/sfDYZ/E5830EOubJFhIUAvXRFcavbU5N6arvyoGM
        XRSNs5eYX+GkuQo/VwkU6kKV8NWEL7sYvdFThRc=
X-Google-Smtp-Source: ABdhPJwWBAFcttnmWUqO7u9iFVKTEd+eABu+GgTI+mnM2YZ4uULPaj8y07KDxeTxa8HfCEYd7MI4DUMDIjNHtw1Ex7M=
X-Received: by 2002:a17:90b:3e88:b0:1e8:8d83:8782 with SMTP id
 rj8-20020a17090b3e8800b001e88d838782mr3922908pjb.0.1654788070148; Thu, 09 Jun
 2022 08:21:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220606233142.150457-1-jlayton@kernel.org> <CAAM7YAmguEUbX7XWc9HV0traYT-CgKWdDWV8-OyjwLc2+Tk8EQ@mail.gmail.com>
 <eaa4e405-d7a5-7cf2-d9e2-4cce55f3c1f9@redhat.com> <CAAM7YAn7UBP-ip=71AcApu70wpvYLS9-q843LALkA9oyw8MqAw@mail.gmail.com>
 <115f53c7-4ad4-aa1f-05b0-66de7d2cdb03@redhat.com> <CAAM7YAnR2dir=8dhWKqYG1YMLVQ_YRADa3Kq=Q9MD-YaYbg5jA@mail.gmail.com>
 <b405ddd5-1df2-1568-6ea3-51279524e099@redhat.com>
In-Reply-To: <b405ddd5-1df2-1568-6ea3-51279524e099@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 9 Jun 2022 23:20:58 +0800
Message-ID: <CAAM7YA=PxtXBfe2Qs2FaN=uqjNZ6NjbndUFX-1YLq-OmdXzTcA@mail.gmail.com>
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

On Thu, Jun 9, 2022 at 12:18 PM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 6/9/22 12:02 PM, Yan, Zheng wrote:
> > On Thu, Jun 9, 2022 at 11:56 AM Xiubo Li <xiubli@redhat.com> wrote:
> >>
> >> On 6/9/22 11:29 AM, Yan, Zheng wrote:
> >>> On Thu, Jun 9, 2022 at 11:19 AM Xiubo Li <xiubli@redhat.com> wrote:
> >>>> On 6/9/22 10:15 AM, Yan, Zheng wrote:
> >>>>> The recent series of patches that add "wait on async xxxx" at various
> >>>>> places do not seem correct. The correct fix should make mds avoid any
> >>>>> wait when handling async requests.
> >>>>>
> >>>> In this case I am thinking what will happen if the async create request
> >>>> is deferred, then the cap flush related request should fail to find the
> >>>> ino.
> >>>>
> >>>> Should we wait ? Then how to distinguish from migrating a subtree and a
> >>>> deferred async create cases ?
> >>>>
> >>> async op caps are revoked at freezingtree stage of subtree migration.
> >>> see Locker::invalidate_lock_caches
> >>>
> >> Sorry I may not totally understand this issue.
> >>
> >> I think you mean in case of migration and then the MDS will revoke caps
> >> for the async create files and then the kclient will send a MclientCap
> >> request to mds, right ?
> >>
> >> If my understanding is correct, there is another case that:
> >>
> >> 1, async create a fileA
> >>
> >> 2, then write a lot of data to it and then release the Fw cap ref, and
> >> if we should report the size to MDS, it will send a MclientCap request
> >> to MDS too.
> >>
> >> 3, what if the async create of fileA was deferred due to some reason,
> >> then the MclientCap request will fail to find the ino ?
> >>
> > Async op should not be deferred in any case.
>
> Recently we have hit a similar bug, caused by deferring a request and
> requeuing it and the following request was executed before it.
>
that bug is mds bug.

> >>>>> On Wed, Jun 8, 2022 at 12:56 PM Jeff Layton <jlayton@kernel.org> wrote:
> >>>>>> Currently, we'll call ceph_check_caps, but if we're still waiting on the
> >>>>>> reply, we'll end up spinning around on the same inode in
> >>>>>> flush_dirty_session_caps. Wait for the async create reply before
> >>>>>> flushing caps.
> >>>>>>
> >>>>>> Fixes: fbed7045f552 (ceph: wait for async create reply before sending any cap messages)
> >>>>>> URL: https://tracker.ceph.com/issues/55823
> >>>>>> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> >>>>>> ---
> >>>>>>     fs/ceph/caps.c | 1 +
> >>>>>>     1 file changed, 1 insertion(+)
> >>>>>>
> >>>>>> I don't know if this will fix the tx queue stalls completely, but I
> >>>>>> haven't seen one with this patch in place. I think it makes sense on its
> >>>>>> own, either way.
> >>>>>>
> >>>>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> >>>>>> index 0a48bf829671..5ecfff4b37c9 100644
> >>>>>> --- a/fs/ceph/caps.c
> >>>>>> +++ b/fs/ceph/caps.c
> >>>>>> @@ -4389,6 +4389,7 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
> >>>>>>                    ihold(inode);
> >>>>>>                    dout("flush_dirty_caps %llx.%llx\n", ceph_vinop(inode));
> >>>>>>                    spin_unlock(&mdsc->cap_dirty_lock);
> >>>>>> +               ceph_wait_on_async_create(inode);
> >>>>>>                    ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
> >>>>>>                    iput(inode);
> >>>>>>                    spin_lock(&mdsc->cap_dirty_lock);
> >>>>>> --
> >>>>>> 2.36.1
> >>>>>>
>
