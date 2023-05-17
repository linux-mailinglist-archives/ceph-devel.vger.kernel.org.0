Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8792B7066AD
	for <lists+ceph-devel@lfdr.de>; Wed, 17 May 2023 13:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbjEQL35 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 07:29:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbjEQL3z (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 07:29:55 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2AA40CC;
        Wed, 17 May 2023 04:29:53 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-510d6b939bfso752543a12.0;
        Wed, 17 May 2023 04:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684322991; x=1686914991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gU4qmxahpGLAWMbxFsDpas28WBSNd5nv5mBI1qCaNds=;
        b=Sl64T9G/tlZNS2qkLmvMB7tYaKx0TpbtwXmR5OraQYfAJzHiO4dcOtG7/fC+8a3UdE
         YRq8N9aShzNZPDd65ShBjuW4NQwRwcBdkbiWGBqV2ozMXLMtMyYjFuWBiHvLzMnrDVs4
         Xo/Kv0ayNjwOqrVPeORFp8x45020Vs3as5aiDEl6BbJHkYPaDqMhYFYCHXB3z3XtFg6v
         bTXbQQiJ1EozwR8eVtOGhefPfsIi6Bv/NwhbQXhQI/5qY8XhHXx1ZSCKduT7L5LgAh1u
         f35i11bUm4Mdt9ZK2+swwx4KpfbUpdr2ouxphKM55PDesmpjyFsEYQDhIp0CzdnoKsgT
         3rqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684322991; x=1686914991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gU4qmxahpGLAWMbxFsDpas28WBSNd5nv5mBI1qCaNds=;
        b=Mzkvx5NdyxzHlkFeWmNxYIgBXfkiVGLxx4eTfu/qgBVVNz+pESV+Pss2ZCICjkK+IN
         Rmx+0eMvF+Zk5XpTeYvaVme8hQPxSGQxqUl8HTZah4bV808b1IohfHUkpdXfBFbpWLqK
         QYK9iR3YNL4164/tLqzu5CGoHCMoZo1KCSmHv10Hu28Nh9ymqNJyaLUxJQm+omgi0+av
         UIXGqP8OGElHMl8YYJ2Ewj1JXrnQAt3jqw+PkCVH2cnGUZapuTVvZJbu21Kv2KvSoKc3
         L2MVJZ4MMPAXgfB5wjzwq07YZE4p6ZgnFbu2RBgDee/Nxnebs3jLTFVQYwBv6cCiuwsA
         tU4w==
X-Gm-Message-State: AC+VfDybSIIbgtC5xND3dvxB74i0TAUAXrRrd6nGBhRSjYqNHRGxg/d8
        Ka/AZTpTzUfz5pjfygbtwADlop/5CdwgnUaTbTA=
X-Google-Smtp-Source: ACHHUZ4/ymyjVkHoeSTYT3TNe4rw2At+SARkwTAVQCp59j6Q2tdiDslC3LiUXiezMGNDnxjSfR2fq5KeL7dHI6MVFYw=
X-Received: by 2002:a05:6402:1b03:b0:509:f221:cee2 with SMTP id
 by3-20020a0564021b0300b00509f221cee2mr1753178edb.32.1684322991248; Wed, 17
 May 2023 04:29:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230517052404.99904-1-xiubli@redhat.com> <CAOi1vP8e6NrrrV5TLYS-DpkjQN6LhfqkptR5_ue94HcHJV_2ag@mail.gmail.com>
 <b121586f-d628-a8e3-5802-298c1431f0e5@redhat.com>
In-Reply-To: <b121586f-d628-a8e3-5802-298c1431f0e5@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 17 May 2023 13:29:39 +0200
Message-ID: <CAOi1vP-vA0WAw6Jb69QDt=43fw8rgS7KvLrvKF5bEqgOS_TzUQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: force updating the msg pointer in non-split case
To:     Xiubo Li <xiubli@redhat.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, stable@vger.kernel.org,
        Frank Schilder <frans@dtu.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, May 17, 2023 at 1:04=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 5/17/23 18:31, Ilya Dryomov wrote:
> > On Wed, May 17, 2023 at 7:24=E2=80=AFAM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> When the MClientSnap reqeust's op is not CEPH_SNAP_OP_SPLIT the
> >> request may still contain a list of 'split_realms', and we need
> >> to skip it anyway. Or it will be parsed as a corrupt snaptrace.
> >>
> >> Cc: stable@vger.kernel.org
> >> Cc: Frank Schilder <frans@dtu.dk>
> >> Reported-by: Frank Schilder <frans@dtu.dk>
> >> URL: https://tracker.ceph.com/issues/61200
> >> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >> ---
> >>   fs/ceph/snap.c | 3 +++
> >>   1 file changed, 3 insertions(+)
> >>
> >> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> >> index 0e59e95a96d9..d95dfe16b624 100644
> >> --- a/fs/ceph/snap.c
> >> +++ b/fs/ceph/snap.c
> >> @@ -1114,6 +1114,9 @@ void ceph_handle_snap(struct ceph_mds_client *md=
sc,
> >>                                  continue;
> >>                          adjust_snap_realm_parent(mdsc, child, realm->=
ino);
> >>                  }
> >> +       } else {
> >> +               p +=3D sizeof(u64) * num_split_inos;
> >> +               p +=3D sizeof(u64) * num_split_realms;
> >>          }
> >>
> >>          /*
> >> --
> >> 2.40.1
> >>
> > Hi Xiubo,
> >
> > This code appears to be very old -- it goes back to the initial commit
> > 963b61eb041e ("ceph: snapshot management") in 2009.  Do you have an
> > explanation for why this popped up only now?
>
> As I remembered we hit this before in one cu BZ last year, but I
> couldn't remember exactly which one.  But I am not sure whether @Jeff
> saw this before I joint ceph team.
>
>
> > Has MDS always been including split_inos and split_realms arrays in
> > !CEPH_SNAP_OP_SPLIT case or is this a recent change?  If it's a recent
> > change, I'd argue that this needs to be addressed on the MDS side.
>
> While in MDS side for the _UPDATE op it won't send the 'split_realm'
> list just before the commit in 2017:
>
> commit 93e7267757508520dfc22cff1ab20558bd4a44d4
> Author: Yan, Zheng <zyan@redhat.com>
> Date:   Fri Jul 21 21:40:46 2017 +0800
>
>      mds: send snap related messages centrally during mds recovery
>
>      sending CEPH_SNAP_OP_SPLIT and CEPH_SNAP_OP_UPDATE messages to
>      clients centrally in MDCache::open_snaprealms()
>
>      Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
>
> Before this commit it will only send the 'split_realm' list for the
> _SPLIT op.

It sounds like we have the culprit.  This should be treated as
a regression and fixed on the MDS side.  I don't see a justification
for putting useless data on the wire.

Thanks,

                Ilya
