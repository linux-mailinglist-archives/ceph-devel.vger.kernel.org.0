Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B27B3B81E7
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jun 2021 14:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbhF3MUO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Jun 2021 08:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234376AbhF3MUN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Jun 2021 08:20:13 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 098B6C061756
        for <ceph-devel@vger.kernel.org>; Wed, 30 Jun 2021 05:17:44 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id i189so2839628ioa.8
        for <ceph-devel@vger.kernel.org>; Wed, 30 Jun 2021 05:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+yvqm68fyG+6suj7FOrJ1uvpogiC6djqngWqL6m8Wyw=;
        b=ZBM0Et6xtKW5IfD6/NzakyX2MRg3Ou7LC4fzmfLMFbhfHiqkW6PRqe3aoJCWDlB8eV
         rYp6NVfMtySfGMNXFlgHJeaTvselVtQ5olUE0havgzo9F351bPpnr6mhi3K6VF7LzeJJ
         H/pX2BdkY2UXglxbqlOKDYfo470mE/aKRgp3z+1tUiI/enud7uRjOfDd+wERiNDuBiWE
         71M1MfbGrQpG65VF9JPApaWDwBMV2ab34q5iEv94Klrfcmjf2IQEDnIxnBf0Mpvaeouk
         QErEj5jWEpYVj9CezFn3wn7JgqosWZaj8L3gd6D89b1hI82lfO/6PcEgR+yjWTnUR+Ta
         wAjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+yvqm68fyG+6suj7FOrJ1uvpogiC6djqngWqL6m8Wyw=;
        b=G7uoq7rpWq3fGB0pwCVSbPmm9ze6dPlqbzfQa7PQX9Hjs+sDpPpIJ/MAV9pRFo0l9W
         7oeOcCsCh+yF9QNTrXHE5SAvn/5g4vlaeJXQ1MIwYV38G8TxgJkXzr06gJ6JKq+wyM6G
         3KCnYFPqFauznwVRMkbPUKZA/reJAuV1jrUX6/vkGDEts4pnAjec4tsf/qPONIR2+vtu
         GBMwNUJeAAA/qEMbLke7+5EjWQrmJ0j/65KnLhcznxpH0lOyRGVw2PyOrpfJyic5vGTj
         yhPlDFpDlQCQvFqfDD4INE+F/FUlJ+zlLJWLI2hUsH5K3Zet6bH3zB2oX2JG+JqKdFul
         K96w==
X-Gm-Message-State: AOAM5332feDJown08+OCte4BYrJWxZ5wDOv0TwpdW0BzBUqyH0joEMqk
        BWDtsPBxG3hwF1Ry2XEKgLvHlxzd8LLCjvwOuHE=
X-Google-Smtp-Source: ABdhPJxO1KR0lTte76DU5Om3DzikjGPAZsdXFscS8YH5Hnq49R8kw1SnehiTnirp9/ZLa9Mw348zweZv3BMcmJ/V5wk=
X-Received: by 2002:a02:cb0f:: with SMTP id j15mr1047883jap.11.1625055463493;
 Wed, 30 Jun 2021 05:17:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210629044241.30359-1-xiubli@redhat.com> <20210629044241.30359-2-xiubli@redhat.com>
 <88c1bdbf8235b35671a84f0b0d5feca855017940.camel@kernel.org> <8cc0a19a-2c67-f807-5085-46455727e8ab@redhat.com>
In-Reply-To: <8cc0a19a-2c67-f807-5085-46455727e8ab@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 30 Jun 2021 14:17:23 +0200
Message-ID: <CAOi1vP-+K1OVA5_Fq6pdC1z0Pp4jLfGB_P+AOzJO9i7oL2uvcg@mail.gmail.com>
Subject: Re: [PATCH 1/5] ceph: export ceph_create_session_msg
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 29, 2021 at 3:27 PM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 6/29/21 9:12 PM, Jeff Layton wrote:
> > On Tue, 2021-06-29 at 12:42 +0800, xiubli@redhat.com wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> > nit: the subject of this patch is not quite right. You aren't exporting
> > it here, just making it a global symbol (within ceph.ko).
> >
>
> Yeah, will fix it.
>
>
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>   fs/ceph/mds_client.c | 15 ++++++++-------
> >>   fs/ceph/mds_client.h |  1 +
> >>   2 files changed, 9 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> >> index 2d7dcd295bb9..e49d3e230712 100644
> >> --- a/fs/ceph/mds_client.c
> >> +++ b/fs/ceph/mds_client.c
> >> @@ -1150,7 +1150,7 @@ static int __choose_mds(struct ceph_mds_client *mdsc,
> >>   /*
> >>    * session messages
> >>    */
> >> -static struct ceph_msg *create_session_msg(u32 op, u64 seq)
> >> +struct ceph_msg *ceph_create_session_msg(u32 op, u64 seq)
> >>   {
> >>      struct ceph_msg *msg;
> >>      struct ceph_mds_session_head *h;
> >> @@ -1158,7 +1158,7 @@ static struct ceph_msg *create_session_msg(u32 op, u64 seq)
> >>      msg = ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h), GFP_NOFS,
> >>                         false);
> >>      if (!msg) {
> >> -            pr_err("create_session_msg ENOMEM creating msg\n");
> >> +            pr_err("ceph_create_session_msg ENOMEM creating msg\n");
> > instead of hardcoding the function names in these error messages, use
> > __func__ instead? That makes it easier to keep up with code changes.
> >
> >       pr_err("%s ENOMEM creating msg\n", __func__);
>
> Sure, will fix this too.

I think this can be just "ENOMEM creating session msg" without the
function name to avoid repetition.

Thanks,

                Ilya
