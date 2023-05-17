Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31766706A46
	for <lists+ceph-devel@lfdr.de>; Wed, 17 May 2023 15:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbjEQN5N (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 09:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjEQN5M (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 09:57:12 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7553E2D4D;
        Wed, 17 May 2023 06:57:10 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-50bc0117683so1484896a12.1;
        Wed, 17 May 2023 06:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684331829; x=1686923829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CgAdbKmTsyMCchxne452lAgVWf34d9RM6RyQlKJWuKo=;
        b=gMePLJwJOv/kJIv6EBGvXcFv1jzddaFkLdmJn72YpDNpwkf8clw3Q5c3K3pRjUw+ye
         /tXX4G7xA+tTcBQbFeuzArMumcDlS051PFvhzmXAJub5PXtjGU+d82SIFTi9pF1cOQbn
         k3WAreB+hy0ut99ndlyo9E7A67OlmM9v/citN3BQokzUOvGKokmBIvmfQv0Q7Vaq3Wmz
         DW+lnhlyWzaeu3yZI6/DC+daMMUHxE3avdMEfsG6v5mmRGUfm7e/90Fl1Z9GVGG/6jz3
         1eiAKNLwEgj79hzT9dcnOsOW7AnZMspcKEaS1TShct5/YU0odPlJanLFRTXL8DB4ituO
         3O4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684331829; x=1686923829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CgAdbKmTsyMCchxne452lAgVWf34d9RM6RyQlKJWuKo=;
        b=SZKlJVC4rmTQ9NHDS+cOfuU5gFfJOxhBGewdpO4cEvR0t6EgJdDuR7tDJzokd657OA
         1YFzO47ZE0qXsTyud1Z/E0oj6Bm9/rFH84WzQfEpgig/bfLbU4lPG0gkPSU1bW8+yeui
         NWubDBS7at/WjxWhY0ebkWtncsO/+pr4oMPeBLWVr7D6XDMZ1xq+4ddkOoE5DiPl0Bg0
         xvkiwCXUCRZnRez6GIIgmI0jHDfMBZkcfTOsiixp/eJwUBUU8P+DA+5qoQTldeAfgMcr
         Zurlifr2Zm2WMhaFSCu6kT4jGhloAV7HSmMWEXcA+TSQSJ9VfWU+8cP4JtEEcR91+Jti
         FBJg==
X-Gm-Message-State: AC+VfDwL5w729iYJoO4YnCr9Yb7hMb+pleId+rIRrvG4Rw7tVVM/SXVd
        RUwsTsANLzPloS5ezsk0rcnrv9mXU3FrlWLxvFA=
X-Google-Smtp-Source: ACHHUZ65TpEnlvaaz8N+3uCuWKcQFLoTxb+gLBe9tqx/squQoUETe81u8UG5FjTK1rDgxB9XU4AougfExrKxbKcX4TU=
X-Received: by 2002:a17:906:974e:b0:96a:4c61:3c87 with SMTP id
 o14-20020a170906974e00b0096a4c613c87mr22055762ejy.71.1684331828665; Wed, 17
 May 2023 06:57:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230517052404.99904-1-xiubli@redhat.com> <CAOi1vP8e6NrrrV5TLYS-DpkjQN6LhfqkptR5_ue94HcHJV_2ag@mail.gmail.com>
 <b121586f-d628-a8e3-5802-298c1431f0e5@redhat.com> <CAOi1vP-vA0WAw6Jb69QDt=43fw8rgS7KvLrvKF5bEqgOS_TzUQ@mail.gmail.com>
 <11105fba-dce6-d54e-a75d-2673e4b5f3cf@redhat.com> <CAOi1vP-xT56QYsne-n-fjSoDitEbeaEQNuxA_sKKbR=M+V7baA@mail.gmail.com>
 <5391b06a-2bb6-05f2-dd7c-c96f259ba443@redhat.com>
In-Reply-To: <5391b06a-2bb6-05f2-dd7c-c96f259ba443@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 17 May 2023 15:56:36 +0200
Message-ID: <CAOi1vP8Gwk8AwZh6X2Kss1o=pCmuboG1pNYcYNQiKF+YLVTm_Q@mail.gmail.com>
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

On Wed, May 17, 2023 at 3:33=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 5/17/23 21:11, Ilya Dryomov wrote:
> > On Wed, May 17, 2023 at 2:46=E2=80=AFPM Xiubo Li <xiubli@redhat.com> wr=
ote:
> >>
> >> On 5/17/23 19:29, Ilya Dryomov wrote:
> >>> On Wed, May 17, 2023 at 1:04=E2=80=AFPM Xiubo Li <xiubli@redhat.com> =
wrote:
> >>>> On 5/17/23 18:31, Ilya Dryomov wrote:
> >>>>> On Wed, May 17, 2023 at 7:24=E2=80=AFAM <xiubli@redhat.com> wrote:
> >>>>>> From: Xiubo Li <xiubli@redhat.com>
> >>>>>>
> >>>>>> When the MClientSnap reqeust's op is not CEPH_SNAP_OP_SPLIT the
> >>>>>> request may still contain a list of 'split_realms', and we need
> >>>>>> to skip it anyway. Or it will be parsed as a corrupt snaptrace.
> >>>>>>
> >>>>>> Cc: stable@vger.kernel.org
> >>>>>> Cc: Frank Schilder <frans@dtu.dk>
> >>>>>> Reported-by: Frank Schilder <frans@dtu.dk>
> >>>>>> URL: https://tracker.ceph.com/issues/61200
> >>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> >>>>>> ---
> >>>>>>     fs/ceph/snap.c | 3 +++
> >>>>>>     1 file changed, 3 insertions(+)
> >>>>>>
> >>>>>> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> >>>>>> index 0e59e95a96d9..d95dfe16b624 100644
> >>>>>> --- a/fs/ceph/snap.c
> >>>>>> +++ b/fs/ceph/snap.c
> >>>>>> @@ -1114,6 +1114,9 @@ void ceph_handle_snap(struct ceph_mds_client=
 *mdsc,
> >>>>>>                                    continue;
> >>>>>>                            adjust_snap_realm_parent(mdsc, child, r=
ealm->ino);
> >>>>>>                    }
> >>>>>> +       } else {
> >>>>>> +               p +=3D sizeof(u64) * num_split_inos;
> >>>>>> +               p +=3D sizeof(u64) * num_split_realms;
> >>>>>>            }
> >>>>>>
> >>>>>>            /*
> >>>>>> --
> >>>>>> 2.40.1
> >>>>>>
> >>>>> Hi Xiubo,
> >>>>>
> >>>>> This code appears to be very old -- it goes back to the initial com=
mit
> >>>>> 963b61eb041e ("ceph: snapshot management") in 2009.  Do you have an
> >>>>> explanation for why this popped up only now?
> >>>> As I remembered we hit this before in one cu BZ last year, but I
> >>>> couldn't remember exactly which one.  But I am not sure whether @Jef=
f
> >>>> saw this before I joint ceph team.
> >>>>
> >>>>
> >>>>> Has MDS always been including split_inos and split_realms arrays in
> >>>>> !CEPH_SNAP_OP_SPLIT case or is this a recent change?  If it's a rec=
ent
> >>>>> change, I'd argue that this needs to be addressed on the MDS side.
> >>>> While in MDS side for the _UPDATE op it won't send the 'split_realm'
> >>>> list just before the commit in 2017:
> >>>>
> >>>> commit 93e7267757508520dfc22cff1ab20558bd4a44d4
> >>>> Author: Yan, Zheng <zyan@redhat.com>
> >>>> Date:   Fri Jul 21 21:40:46 2017 +0800
> >>>>
> >>>>        mds: send snap related messages centrally during mds recovery
> >>>>
> >>>>        sending CEPH_SNAP_OP_SPLIT and CEPH_SNAP_OP_UPDATE messages t=
o
> >>>>        clients centrally in MDCache::open_snaprealms()
> >>>>
> >>>>        Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> >>>>
> >>>> Before this commit it will only send the 'split_realm' list for the
> >>>> _SPLIT op.
> >>> It sounds like we have the culprit.  This should be treated as
> >>> a regression and fixed on the MDS side.  I don't see a justification
> >>> for putting useless data on the wire.
> >> But we still need this patch to make it to work with the old ceph rele=
ases.
> > This is debatable:
> >
> > - given that no one noticed this for so long, the likelihood of MDS
> >    sending a CEPH_SNAP_OP_UPDATE message with bogus split_inos and
> >    split_realms arrays is very low
> >
> > - MDS side fix would be backported to supported Ceph releases
> >
> > - people who are running unsupported Ceph releases (i.e. aren't
> >    updating) are unlikely to be diligently updating their kernel client=
s
>
> Just searched the ceph tracker and I found another 3 trackers have the
> same issue:
>
> https://tracker.ceph.com/issues/57817
> https://tracker.ceph.com/issues/57703
> https://tracker.ceph.com/issues/57686
>
> So plusing this time and the previous CU case:
>
> https://www.spinics.net/lists/ceph-users/msg77106.html
>
> I have seen at least 5 times.
>
> All this are reproduced when doing MDS failover, and this is the root
> cause in MDS side.

OK, given that the fixup in the kernel client is small, it seems
justified.  But, please, add a comment in the new else branch saying
that it's there only to work around a bug in the MDS.

Thanks,

                Ilya
