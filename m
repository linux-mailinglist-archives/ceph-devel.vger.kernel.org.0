Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24DC25441F0
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jun 2022 05:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237605AbiFID3u (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jun 2022 23:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234691AbiFID3r (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jun 2022 23:29:47 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289661ECD56
        for <ceph-devel@vger.kernel.org>; Wed,  8 Jun 2022 20:29:46 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so19985911pjq.2
        for <ceph-devel@vger.kernel.org>; Wed, 08 Jun 2022 20:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L7IvCTH6oembtrnk84El4CulADDhXAl51Y1Fr5CeEZ8=;
        b=cdkPLuz917Bo6/YJdMpNMNz4avGxUz3ID2BSZkcplFLk7+SfaShnyDYSAw1XqsGncc
         9/vnScfDmJ2FEPP2yLmrrMHRv6xedXah+1dikEebnVH4mQFuHW0uUhd5ryEv3wfCFqEF
         IEx3Ce/T/hih124Uw2qoYv+5kcKS0b7jhuY3+57qlTFH8gmPKKODV3cjgH6xjdLOg5VR
         SCQRKaX7m276ljaeI7PHoXtINcdWgkqVTfj5PYrZq/A9++0e8YARLVL+OpOLZIVxMxE1
         ULMh3u0JfDa3wwuYCcIqrJNTLxvjI8HB1CwzgVVdSHX1Q2sTGg/lEWFLx8ZbcdubcvHj
         ydOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L7IvCTH6oembtrnk84El4CulADDhXAl51Y1Fr5CeEZ8=;
        b=aN9WuA6hNrubRAu8w3rccZjajEohKcIZK1VOHe/P5TCX+PqqFrsaY3a+j9FN9+T4QD
         KcnVmYemGGtL8Vub2jN1J95I1zaedshvmvkGpmIaEmwEwI64YvXTaL/vjPyYr2wRYILo
         cpj0KQbSjcUYQccnoJ9YnNkSQkmggRqdKsbEbV9cRzgHeih/L9S9atjUQnKSA7IDdq4s
         BiLFHVxNYzxY6h5LwYny1NjGzTDDxUYp7H59MAQ5FaV1Uiu1mwY8zMQ2jNlpX2PWtEKF
         a6e8uPoKnJHWs4//tvlSouAKCtggrSPyzh6WItaaH4hrcDSIyKi1tEnAKN4hUCbi4+qa
         BVsg==
X-Gm-Message-State: AOAM533ihShM0OlVDChRRiHnGG48ypaQZEPHIPcIiZ2IRjB8EKXiuveJ
        BofuT6id4yrOWZTICM6mwQHOde0GSnfaGxEZfoIMIVBA5FV5/Q==
X-Google-Smtp-Source: ABdhPJxFOg/0LjmqfstV2ECvuByyTPc4UUcxOvFqdH2bkPWRVwWArF7JaSy2Wnj2NQNP/waAylH4FbKuEPe0j5fOlXY=
X-Received: by 2002:a17:903:44c:b0:164:113:a433 with SMTP id
 iw12-20020a170903044c00b001640113a433mr36704313plb.163.1654745385574; Wed, 08
 Jun 2022 20:29:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220606233142.150457-1-jlayton@kernel.org> <CAAM7YAmguEUbX7XWc9HV0traYT-CgKWdDWV8-OyjwLc2+Tk8EQ@mail.gmail.com>
 <eaa4e405-d7a5-7cf2-d9e2-4cce55f3c1f9@redhat.com>
In-Reply-To: <eaa4e405-d7a5-7cf2-d9e2-4cce55f3c1f9@redhat.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 9 Jun 2022 11:29:32 +0800
Message-ID: <CAAM7YAn7UBP-ip=71AcApu70wpvYLS9-q843LALkA9oyw8MqAw@mail.gmail.com>
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

On Thu, Jun 9, 2022 at 11:19 AM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 6/9/22 10:15 AM, Yan, Zheng wrote:
> > The recent series of patches that add "wait on async xxxx" at various
> > places do not seem correct. The correct fix should make mds avoid any
> > wait when handling async requests.
> >
> In this case I am thinking what will happen if the async create request
> is deferred, then the cap flush related request should fail to find the
> ino.
>
> Should we wait ? Then how to distinguish from migrating a subtree and a
> deferred async create cases ?
>

async op caps are revoked at freezingtree stage of subtree migration.
see Locker::invalidate_lock_caches

>
> > On Wed, Jun 8, 2022 at 12:56 PM Jeff Layton <jlayton@kernel.org> wrote:
> >> Currently, we'll call ceph_check_caps, but if we're still waiting on the
> >> reply, we'll end up spinning around on the same inode in
> >> flush_dirty_session_caps. Wait for the async create reply before
> >> flushing caps.
> >>
> >> Fixes: fbed7045f552 (ceph: wait for async create reply before sending any cap messages)
> >> URL: https://tracker.ceph.com/issues/55823
> >> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> >> ---
> >>   fs/ceph/caps.c | 1 +
> >>   1 file changed, 1 insertion(+)
> >>
> >> I don't know if this will fix the tx queue stalls completely, but I
> >> haven't seen one with this patch in place. I think it makes sense on its
> >> own, either way.
> >>
> >> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> >> index 0a48bf829671..5ecfff4b37c9 100644
> >> --- a/fs/ceph/caps.c
> >> +++ b/fs/ceph/caps.c
> >> @@ -4389,6 +4389,7 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
> >>                  ihold(inode);
> >>                  dout("flush_dirty_caps %llx.%llx\n", ceph_vinop(inode));
> >>                  spin_unlock(&mdsc->cap_dirty_lock);
> >> +               ceph_wait_on_async_create(inode);
> >>                  ceph_check_caps(ci, CHECK_CAPS_FLUSH, NULL);
> >>                  iput(inode);
> >>                  spin_lock(&mdsc->cap_dirty_lock);
> >> --
> >> 2.36.1
> >>
>
